#include <ap_int.h>
#include "bnn.h"
#include "golden.h"


static inline ap_uint<6> popcount32(ap_uint<32> x) {
    #pragma HLS INLINE
    ap_uint<32> s0 = (x & 0x55555555u) + ((x >> 1) & 0x55555555u);
    ap_uint<32> s1 = (s0 & 0x33333333u) + ((s0 >> 2) & 0x33333333u);
    ap_uint<32> s2 = (s1 + (s1 >> 4)) & 0x0F0F0F0Fu;
    ap_uint<32> s3 = s2 + (s2 >> 8);
    ap_uint<32> s4 = s3 + (s3 >> 16);
    return s4(5,0);  // max value = 32
}

static inline ap_uint<32> xnor32(ap_uint<32> a, ap_uint<32> b) {
    #pragma HLS INLINE
    return ~(a ^ b);
}


void dense_layer(
    const unsigned int* input,
    const unsigned int* weights,
    int* output,
    int input_size_bits,
    int input_size_words,
    int output_neurons,
    int valid_bits
) {
    #pragma HLS INLINE off

    
    for (int n = 0; n < output_neurons; n++) {
		#pragma HLS PIPELINE II=1
   		#pragma HLS UNROLL factor=2

        int popcount_sum = 0;

        
        for (int w = 0; w < input_size_words; w++) {
            #pragma HLS UNROLL factor=2

            ap_uint<32> in  = input[w];
            ap_uint<32> wt  = weights[n * input_size_words + w];
            ap_uint<32> xnr = xnor32(in, wt);

            // Mask last word if partial bits
            if (w == input_size_words - 1 && valid_bits > 0) {
                ap_uint<32> mask = (valid_bits == 32)
                                 ? ap_uint<32>(0xFFFFFFFFu)
                                 : (ap_uint<32>(~0u) << (32 - valid_bits));
                xnr &= mask;
            }

            popcount_sum += (int)popcount32(xnr);
        }

        // BNN activation
        output[n] = (popcount_sum << 1) - input_size_bits;
    }
}


void sign_and_quantize(int* input, unsigned int* output, int size) {
    #pragma HLS INLINE off

    int num_words = (size + 31) / 32;

   
    for (int w = 0; w < num_words; w++) {
        #pragma HLS PIPELINE II=1
        ap_uint<32> outw = 0;

       
        for (int b = 0; b < 32; b++) {
            #pragma HLS UNROLL
            int i = w * 32 + b;
            if (i < size && input[i] <= 0) outw[31 - b] = 1;
        }
        output[w] = (unsigned)outw;
    }
}



void bnn(DTYPE IN[SIZE], ITYPE ys[10]) {
    #pragma HLS INTERFACE m_axi port=IN offset=slave bundle=gmem depth=25 max_read_burst_length=32 num_read_outstanding=16
    #pragma HLS INTERFACE m_axi port=ys offset=slave bundle=gmem depth=10 max_write_burst_length=16 num_write_outstanding=16
    #pragma HLS INTERFACE s_axilite port=IN bundle=control
    #pragma HLS INTERFACE s_axilite port=ys bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

	#pragma HLS DATAFLOW

    unsigned int input_buffer[25];
    #pragma HLS ARRAY_PARTITION variable=input_buffer complete

    int layer1_output[128];
    #pragma HLS ARRAY_PARTITION variable=layer1_output complete

    unsigned int layer1_quantized[4];
    #pragma HLS ARRAY_PARTITION variable=layer1_quantized complete

    int layer2_output[64];
    #pragma HLS ARRAY_PARTITION variable=layer2_output complete

    unsigned int layer2_quantized[2];
    #pragma HLS ARRAY_PARTITION variable=layer2_quantized complete

    int layer3_output[10];
    #pragma HLS ARRAY_PARTITION variable=layer3_output complete

    
    for (int i = 0; i < 25; i++) {
        #pragma HLS UNROLL
        input_buffer[i] = IN[i];
    }

	// Doing feedforward 

    // Layer 1
    dense_layer(input_buffer, golden_w1, layer1_output, 784, 25, 128, 16);
    sign_and_quantize(layer1_output, layer1_quantized, 128);

    // Layer 2
    dense_layer(layer1_quantized, golden_w2, layer2_output, 128, 4, 64, 0);
    sign_and_quantize(layer2_output, layer2_quantized, 64);

    // Layer 3
    dense_layer(layer2_quantized, golden_w3, layer3_output, 64, 2, 10, 0);

    
    for (int i = 0; i < 10; i++) {
        #pragma HLS UNROLL
        ys[i] = layer3_output[i];
    }
}

void bnn_with_layers(
    DTYPE IN[SIZE],
    ITYPE layer1[128],
    ITYPE layer2[64],
    ITYPE layer3[10]
) {
    #pragma HLS INTERFACE m_axi port=IN offset=slave bundle=gmem0 depth=25
    #pragma HLS INTERFACE m_axi port=layer1 offset=slave bundle=gmem1 depth=128
    #pragma HLS INTERFACE m_axi port=layer2 offset=slave bundle=gmem2 depth=64
    #pragma HLS INTERFACE m_axi port=layer3 offset=slave bundle=gmem3 depth=10
    #pragma HLS INTERFACE s_axilite port=IN bundle=control
    #pragma HLS INTERFACE s_axilite port=layer1 bundle=control
    #pragma HLS INTERFACE s_axilite port=layer2 bundle=control
    #pragma HLS INTERFACE s_axilite port=layer3 bundle=control
    #pragma HLS INTERFACE s_axilite port=return bundle=control

    unsigned int input_buffer[25];
    #pragma HLS ARRAY_PARTITION variable=input_buffer complete

    int layer1_output[128];
    #pragma HLS ARRAY_PARTITION variable=layer1_output complete

    unsigned int layer1_quantized[4];
    #pragma HLS ARRAY_PARTITION variable=layer1_quantized complete

    int layer2_output[64];
    #pragma HLS ARRAY_PARTITION variable=layer2_output complete

    unsigned int layer2_quantized[2];
    #pragma HLS ARRAY_PARTITION variable=layer2_quantized complete

    int layer3_output[10];
    #pragma HLS ARRAY_PARTITION variable=layer3_output complete

    for (int i = 0; i < 25; i++) {
        #pragma HLS UNROLL
        input_buffer[i] = IN[i];
    }

    dense_layer(input_buffer, golden_w1, layer1_output, 784, 25, 128, 16);
    for (int i = 0; i < 128; i++) {
        #pragma HLS UNROLL
        layer1[i] = layer1_output[i];
    }

    sign_and_quantize(layer1_output, layer1_quantized, 128);
    dense_layer(layer1_quantized, golden_w2, layer2_output, 128, 4, 64, 0);
    for (int i = 0; i < 64; i++) {
        #pragma HLS UNROLL
        layer2[i] = layer2_output[i];
    }

    sign_and_quantize(layer2_output, layer2_quantized, 64);
    dense_layer(layer2_quantized, golden_w3, layer3_output, 64, 2, 10, 0);
    for (int i = 0; i < 10; i++) {
        #pragma HLS UNROLL
        layer3[i] = layer3_output[i];
    }
}