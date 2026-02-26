import numpy as np
import os
import sys
# 89.05678179322965
# 89.39

class BNN_MNIST:

    def __init__(self, batch_size=64):
        self.batch_size = batch_size

        ## for sw
        self.sign = lambda x: float(1) if x>0 else float(-1)
        self.sign = np.vectorize(self.sign)

        self.quantize = lambda x: float(0) if x == 1 else float(1)
        self.quantize = np.vectorize(self.quantize)

        self.adj = lambda x: x*2-1
        self.adj = np.vectorize(self.adj, otypes=[float])
        self.model = np.load("weights/model.npy", allow_pickle=True).item()
        # print(model.keys)
        # dict_keys(['fc1w', 'fc2w', 'fc3w'])

        self.fc1w_q = self.sign(np.array(self.model['fc1w']))
        # (128, 784)
        self.fc2w_q = self.sign(np.array(self.model['fc2w']))
        # (64, 128)
        self.fc3w_q = self.sign(np.array(self.model['fc3w']))

        self.fc1w_qntz = self.quantize(self.fc1w_q)
        self.fc2w_qntz = self.quantize(self.fc2w_q)
        self.fc3w_qntz = self.quantize(self.fc3w_q)

    def hlscode(self, input_file, first_sample, num_samples):
        """Generate golden.h from any input file using existing helper functions"""
        
        # Use existing create_packed_weights() instead of loading from files!
        fc1w_packed, fc2w_packed, fc3w_packed = self.create_packed_weights()
        
        # Load input file and detect format
        data = np.load(input_file, allow_pickle=True)
        
        if isinstance(data.item(), dict):
            data_dict = data.item()
            
            if 'X' in data_dict and isinstance(data_dict['X'], list):
                print("Detected: Pre-packed format")
                X_packed_list = data_dict['X']
                y_labels = data_dict['y']
                use_prepacked = True
                
                mnist_orig = np.load("dataset/mnist_test_data_original.npy", allow_pickle=True)
                X_orig = mnist_orig.item().get("data").reshape(-1, 784)
            else:
                print("Detected: Raw pixel format")
                X_orig = data_dict.get('data', data_dict.get('X')).reshape(-1, 784)
                y_labels = data_dict.get('label', data_dict.get('y'))
                use_prepacked = False
        else:
            print("Detected: Plain numpy array")
            X_orig = data.reshape(-1, 784)
            y_labels = None
            use_prepacked = False
        
        available_samples = len(X_packed_list) if use_prepacked else len(X_orig)
        actual_samples = min(num_samples, available_samples-first_sample)
        if first_sample >= (len(X_packed_list) if use_prepacked else len(X_orig)):
            print(f"ERROR: cannot begin at sample {first_sample}\n"
                  f"{input_file} contains {available_samples} samples")
            sys.exit(1)
        if actual_samples < num_samples:
            print(f"WARNING: Cannot generate {num_samples} samples starting at sample {first_sample}\n"
                  f"{input_file} contains {available_samples} samples\n"
                  f"Continuing with {actual_samples} samples starting at sample {first_sample}...")
        
        # Collect all samples using existing helper functions
        all_inputs = []
        all_layer1_outputs = []
        all_layer2_outputs = []
        all_final_outputs = []
        all_labels = []

        sample_idx = first_sample
        for sample_idx in range(actual_samples+first_sample):
            xs_orig = X_orig[sample_idx]
            
            # Get label
            if use_prepacked:
                ys_label = y_labels[sample_idx][0] if isinstance(y_labels[sample_idx], np.ndarray) else y_labels[sample_idx]
            else:
                ys_label = y_labels[sample_idx] if y_labels is not None else -1
            
            # Get packed input
            if use_prepacked:
                X0_bit = X_packed_list[sample_idx]
            else:
                # Use helper functions: adj -> sign -> quantize -> pack
                processed = self.quantize(self.sign(self.adj(xs_orig)))
                padded = np.concatenate([processed.flatten(), np.ones(16)])
                X0_bit = self.pack(padded.reshape(1, -1), len(padded))
            
            # Use feed_forward_quantized to get all layer outputs
            # (we'll modify it to return intermediate layers)
            l1_act, l2_act, final = self.feed_forward_with_layers(xs_orig)
            
            all_inputs.append(X0_bit)
            all_layer1_outputs.append(l1_act)
            all_layer2_outputs.append(l2_act)
            all_final_outputs.append(final)
            all_labels.append(ys_label)
        
        # Write golden.h using helper
        self.write_golden_header(
            actual_samples, 
            fc1w_packed, fc2w_packed, fc3w_packed,
            all_inputs, all_layer1_outputs, all_layer2_outputs,
            all_final_outputs, all_labels
        )
        
        print("Done")
    
    
    def feed_forward(self, input):
        """This BNN using normal MAC.

        :return:
        """
        X0_q = self.sign(self.adj(input))

        X1 = np.matmul(X0_q, self.fc1w_q.T)

        X1_q = self.sign(X1)

        X2 = np.matmul(X1_q, self.fc2w_q.T)

        X2_q = self.sign(X2)

        X3 = np.matmul(X2_q, self.fc3w_q.T)
        return X3

    def XNOR(self, a, b):
        if (a == b):
            return 1
        else:
            return 0

    def matmul_xnor(self, A, B):
        """This function calculates matrix multiplication between two vectors using XNOR.
        This function specifically designed for the current network size of 128, 64 and 10 neuron layers.

        :param A: The first quantized vector (2D array)
        :param B: The second quantized vector (2D array)
        :return:
        """
        a, b = B.shape

        res = np.zeros(b)

        A1 = A.astype(int)
        B1 = B.astype(int)

        # Determine if A is 1D or 2D
        if A.ndim == 1:
            # If A is 1D, use it directly
            A1_vec = A1
        else:
            # If A is 2D, flatten or take first row
            A1_vec = A1.flatten() if A1.shape[0] == 1 else A1[0]

        for x in range(b):
            cnt = 0
            for y in range(a):
                if a == 784:
                    # For first layer, A is always 2D with shape (1, 784)
                    cnt = cnt + self.XNOR(A1[0][y], B1[y][x])
                elif a == 128 or a == 64:
                    # For other layers, use the flattened vector
                    cnt = cnt + self.XNOR(A1_vec[y], B1[y][x])
            res[x] = cnt
        
        return res


    def matmul_vs_xnormatmul(self):
        """ This is a toy example that demonstrates how to
        multiply two binary vectors using XNOR and popcount
        :return:
        """
        a = np.array([10, -10, -5, 9, -8, 2, 3, 1, -11])
        b = np.array([12, -18, -13, -13, -14, -15, 11, 12, 13])

        a = self.sign(a)
        b = self.sign(b)

        matmul_result = np.matmul(a, b)

        # XNOR matmul
        a = self.quantize(a)
        b = self.quantize(b)

        xnormatmul_sum = 0
        for x in range(len(a)):
            # Doing XNOR and popcount
            xnormatmul_sum = xnormatmul_sum + self.XNOR(a[x], b[x])

        print("Matmul result: {}, XNOR result: {}".
              format(matmul_result, 2*xnormatmul_sum-len(a)))

    def pack(self, A, n):
        """Pack binary values into 32-bit words (MSB first)
        
        :param A: 2D array of binary values (0s and 1s)
        :param B: Total number of bits to pack
        
        :return: Array of packed uint32 values
        """
        # Flatten the input
        A_flat = A.flatten()[:n]  # Take only first n bits
        
        # Calculate number of words needed
        num_words = (n + 31) // 32
        
        # Pack bits into words (MSB first)
        packed = []
        for word_idx in range(num_words):
            word = 0
            start_bit = word_idx * 32
            end_bit = min(start_bit + 32, n)
            
            for bit_pos in range(start_bit, end_bit):
                bit_val = 1 if A_flat[bit_pos] != 0 else 0
                # MSB first: bit 31, 30, 29, ..., 0
                shift = 31 - (bit_pos - start_bit)
                word |= (bit_val << shift)
            
            packed.append(word)
        
        return np.array(packed, dtype=np.uint32)


    def quantize_scale(self, x):
        """Helper function
        :param x:
        :return:
        """

        if x == -1 or x == -1.0:
            return 1
        elif x == 1 or x == 1.0:
            return 0
        else:
            return 0  # Default case
    
    def concat4(self, li, point):
        """Helper function
        :param li:
        :param point:
        :return:
        """
        result = np.array([self.quantize_scale(li[point])], dtype=np.uint32)[0].astype(np.uint32)


        for k in range(1, 32):
            i = point + k
            result <<= 1
            result &= 0xFFFFFFFF
            result |= self.quantize_scale(li[i])
            result &= 0xFFFFFFFF
        return result.astype(np.uint32)

    def preprocessModel(self, X, y):
        """Helper function
        :param X:
        :param y:
        :return:
        """
        sample = 2
        numpydict = {"X": [], "y": []}

        X0_q = np.array([list(arr) + [1] * 16 for arr in X])

        X0_bit = self.pack(X0_q, X0_q.shape[0] * X0_q.shape[1])
        Y0 = y
        numpydict["X"].append(X0_bit)
        numpydict["y"].append(Y0)

        np.save('dataset/mnist-bit_sample{}.npy'.format(sample), numpydict, allow_pickle=True)


    def create_input(self, num_of_samples):
        """This function creates packed weights for a given number of samples.
        The created inputs are used for HLS tesbench.

        :param num_of_samples:
        :return:
        """

        mnist = np.load("dataset/mnist_test_data_original.npy", allow_pickle=True)
        X = mnist.item().get("data")
        y = mnist.item().get("label")

        X = np.reshape(X, (10000, 784))

        if num_of_samples == 0:
            num_of_samples = (len(X) // self.batch_size)

        numpydict = {"X": [], "y": []}

        for idx in range(num_of_samples):
            xs = X[self.batch_size * idx:self.batch_size * idx + self.batch_size]
            ys = y[self.batch_size * idx:self.batch_size * idx + self.batch_size]

            X0_q = self.sign(self.adj(xs))
            self.preprocessModel(X0_q, ys)

            X0_q = np.array([list(arr) + [1] * 16 for arr in X0_q])

            X0_bit = self.pack(X0_q, X0_q.shape[0] * X0_q.shape[1])
            Y0 = ys
            numpydict["X"].append(X0_bit)
            numpydict["y"].append(Y0)

        np.save('dataset/mnist-bit_sample{}.npy'.format(num_of_samples), numpydict, allow_pickle=True)



    def create_packed_weights(self):
        """Helper function: This function creates packed weights for HLS.

        :return:
        """

        fc1w_q = np.array([list(arr) + ([0] * 16) for arr in self.fc1w_qntz])
        fc1w_bit = self.pack(fc1w_q.T.T, fc1w_q.shape[0] * fc1w_q.shape[1])
        fc1w_bit = self.pack(fc1w_q, fc1w_q.shape[0] * fc1w_q.shape[1])

        fc2w_q = self.fc2w_qntz
        fc2w_bit = self.pack(fc2w_q, fc2w_q.shape[0] * fc2w_q.shape[1])

        fc3w_q = self.fc3w_qntz
        fc3w_bit = self.pack(fc3w_q, fc3w_q.shape[0] * fc3w_q.shape[1])

        np.savetxt('weights/layer1.txt', fc1w_bit)
        np.savetxt('weights/layer2.txt', fc2w_bit)
        np.savetxt('weights/layer3.txt', fc3w_bit)


        return fc1w_bit, fc2w_bit, fc3w_bit


    def write_to_file(self, w1, w2, w3):
        """ Helper function
        :param w1:
        :param w2:
        :param w3:
        :return:
        """
        # Writing to file
        with open("weights/layer1_c.txt", "w") as file1:
            # Writing data to a file
            for x in range(len(w1)):
                file1.writelines(str(w1[x])+",")

        with open("weights/layer2_c.txt", "w") as file1:
            # Writing data to a file
            for x in range(len(w2)):
                file1.writelines(str(w2[x])+",")

        with open("weights/layer3_c.txt", "w") as file1:
            # Writing data to a file
            for x in range(len(w3)):
                file1.writelines(str(w3[x])+",")

    def write_golden_header(self, num_samples, fc1w, fc2w, fc3w, 
                        inputs, l1_outs, l2_outs, final_outs, labels):
        """Helper to write golden.h file"""
    
        with open("../hls/golden.h", "w") as f:
            f.write("#ifndef __GOLDEN_H__\n#define __GOLDEN_H__\n\n")
            
            # Write weights using helper
            self.write_weight_array(f, "golden_w1", fc1w, 3200)
            self.write_weight_array(f, "golden_w2", fc2w, 256)
            self.write_weight_array(f, "golden_w3", fc3w, 20)
            
            # Write sample count
            f.write(f"#define NUM_SAMPLES {num_samples}\n\n")
            
            # Write all arrays using helpers
            self.write_2d_array(f, "golden_inputs", inputs, labels, is_uint=True)
            self.write_2d_array(f, "golden_outputs", final_outs)
            self.write_1d_array(f, "golden_labels", labels)
            self.write_2d_array(f, "golden_layer1_outputs", l1_outs)
            self.write_2d_array(f, "golden_layer2_outputs", l2_outs)
            
            f.write("#endif\n")

    def write_weight_array(self, f, name, data, size):
        """Helper to write weight array"""
        f.write(f"const unsigned int {name}[{size}] = {{\n")
        for i, val in enumerate(data):
            if i % 10 == 0:
                f.write("    ")
            f.write(f"{int(val)}")
            if i < len(data) - 1:
                f.write(",")
            if (i + 1) % 10 == 0:
                f.write("\n")
        if len(data) % 10 != 0:
            f.write("\n")
        f.write("};\n\n")

    def write_2d_array(self, f, name, data, labels=None, is_uint=False):
        """Helper to write 2D array"""
        dtype = "unsigned int" if is_uint else "int"
        rows = len(data)
        cols = len(data[0])
        
        f.write(f"const {dtype} {name}[{rows}][{cols}] = {{\n")
        for idx, row in enumerate(data):
            f.write("    {")
            for i, val in enumerate(row):
                f.write(f"{val}")
                if i < len(row) - 1:
                    f.write(",")
            f.write("}")
            if idx < len(data) - 1:
                f.write(",\n")
        f.write("\n};\n\n")

    def write_1d_array(self, f, name, data):
        """Helper to write 1D array"""
        f.write(f"const int {name}[{len(data)}] = {{")
        for idx, val in enumerate(data):
            f.write(f"{val}")
            if idx < len(data) - 1:
                f.write(",")
        f.write("};\n\n")


    def feed_forward_with_layers(self, input):
        """Modified feed_forward_quantized that returns intermediate layers
        
        :param input: MNIST sample input (784 pixels)
        :return: (layer1_activations, layer2_activations, final_output)
        """
        # Layer 1 - using existing helper functions
        X0_input = self.quantize(self.sign(self.adj(input)))
        X0_input = np.array([X0_input])
        layer1_output = self.matmul_xnor(X0_input, self.fc1w_qntz.T)
        layer1_activations = (layer1_output * 2 - 784).astype(int).flatten()
        
        # Layer 2
        layer2_input = self.sign(layer1_activations)
        layer2_quantized = self.quantize(layer2_input)
        layer2_quantized_2d = np.array([layer2_quantized])
        layer2_output = self.matmul_xnor(layer2_quantized_2d, self.fc2w_qntz.T)
        layer2_activations = (layer2_output * 2 - 128).astype(int).flatten()
        
        # Layer 3
        layer3_input = self.sign(layer2_activations)
        layer3_quantized = self.quantize(layer3_input)
        layer3_quantized_2d = np.array([layer3_quantized])
        layer3_output = self.matmul_xnor(layer3_quantized_2d, self.fc3w_qntz.T)
        final_output = (layer3_output * 2 - 64).astype(int).flatten()
        
        return layer1_activations, layer2_activations, final_output


    def visualize(self, data, true_label, predicated_label):
        """This function prints image, true label and predicted label.

        :param data:
        :param true_label:
        :param predicated_label:
        :return:
        """
        # Visualization
        import matplotlib.pyplot as plt

        # Import the matplotlib.pyplot module for visualization purposes

        plt.imshow(data, cmap='gray')
        # Display the image at index 0 from the train_data dataset using imshow()
        # The cmap='gray' argument specifies that the image should be displayed in grayscale

        plt.title("true label: {}, predicted label :{}".format(true_label, predicated_label))
        # Set the title of the plot to the label/target corresponding to the image at index 0
        # The '%i' is a placeholder that will be replaced by the value of train_data.targets[0]

        plt.show()
        # Display the plot

    def run_test_visalize(self, num_samples):
        """This function is for debugging. Used for visualizing
        the input (MNIST image), the predicted output and the true output.

        :return:
        """


        mnist = np.load("dataset/mnist_test_data_original.npy", allow_pickle=True)
        X = mnist.item().get("data")
        y = mnist.item().get("label")

        # self.visualize(X[0], y[0], y[0])
        X = np.reshape(X, (10000, 784))
        print(X.shape)


        for idx in range(num_samples):
            xs = X[idx]
            ys = y[idx]
            outputs = self.feed_forward(xs)
            xs_plot = np.reshape(xs, (28, 28))
            self.visualize(xs_plot, ys, np.argmax(outputs))

    def run_test(self, use_normal_mac=False):
        """This function is for testing

        :param use_normal_mac: Setting this parameter calls self.feed_forward (uses MAC),
        otherwise, it calls feed_forward_quantized which uses XNOR

        :return:
        """

        prediction = []

        i = 0

        mnist = np.load("dataset/mnist_test_data_original.npy", allow_pickle=True)
        X = mnist.item().get("data")
        y = mnist.item().get("label")

        # self.visualize(X[0], y[0], y[0])
        X = np.reshape(X, (10000, 784))
        print("The shape of the input: {}".format(X.shape))

        # mnist = np.load("dataset/mnist-original.npy", allow_pickle=True)
        # X = mnist.item().get("data").T
        # y = mnist.item().get("label")[0]

        if use_normal_mac is True:
            inference_function = self.feed_forward
        else:
            inference_function = self.feed_forward_quantized


        for idx in range(len(X) // self.batch_size):
        # for idx in range(10):
            xs = X[self.batch_size * idx:self.batch_size * idx + self.batch_size]
            ys = y[self.batch_size * idx:self.batch_size * idx + self.batch_size]

            # outputs = self.feed_forward(xs)
            # outputs = self.feed_forward_quantized(xs)
            outputs = inference_function(xs)


            for output, yk in zip(outputs, ys):
                prediction.append(np.argmax(output) == (yk))
            i += 1
            # print("{}th iter".format(idx))
            # print("Predicted: {}, True: {}".format(np.argmax(output), yk))


        score = np.mean(prediction) * 100
        # print(score)
        return score


def main():
    """Main function to handle command-line arguments"""
    import sys
    
    if len(sys.argv) < 4:
        print("Usage: python3 bnn_mnist.py <input_file> [first_sample] [num_samples]")
        sys.exit(0)
    
    input_file = sys.argv[1]
    start_sample = int(sys.argv[2])
    num_samples = int(sys.argv[3])
    
    if not os.path.exists(input_file):
        print(f"Error: File not found: {input_file}")
        sys.exit(1)
    
    bnn = BNN_MNIST()
    bnn.hlscode(input_file, start_sample, num_samples)

if __name__ == "__main__":
    main()