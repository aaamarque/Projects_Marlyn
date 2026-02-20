#include "bnn.h"
#include "golden.h"
#include <stdio.h>

void verify_layer_output(const char* layer_name, int sample_num, const int* expected, const int* predicted, int size) {
    int PASS = 1;
    int mismatch_count = 0;
    
    for(int i = 0; i < size; i++) {
        if (expected[i] != predicted[i]) {
            PASS = 0;
            mismatch_count++;
            if(mismatch_count <= 5) {  // Show first 5 mismatches only
                cout << "    Mismatch at [" << i << "]: Expected " << expected[i] 
                     << ", Got " << predicted[i] << endl;
            }
        }
    }
    
    if(PASS == 0) {
        cout << "  " << layer_name << ": FAILED  (" << mismatch_count << "/" << size << " errors)" << endl;
    } else {
        cout << "  " << layer_name << ": PASSED " << endl;
    }
}

int main() {
    cout << "========================================" << endl;
    cout << "BNN Multi-Layer Testbench" << endl;
    cout << "Testing " << NUM_SAMPLES << " samples" << endl;
    cout << "========================================" << endl << endl;
    
    int total_passed = 0;
    int total_failed = 0;
    int layer1_failures = 0;
    int layer2_failures = 0;
    int layer3_failures = 0;
    
    // Test all samples dynamically
    for(int s = 0; s < NUM_SAMPLES; s++) {
        cout << "-----------------------------------------------------------" << endl;
        cout << "Sample " << (s+1) << " - Label: " << golden_labels[s] << endl;
        
        // Get layer outputs from BNN
        int layer1_out[128];
        int layer2_out[64];
        int final_out[10];
        
        // Initialize
        for(int i = 0; i < 128; i++) layer1_out[i] = 0;
        for(int i = 0; i < 64; i++) layer2_out[i] = 0;
        for(int i = 0; i < 10; i++) final_out[i] = 0;
        
        // Run BNN inference with intermediate outputs
        bnn_with_layers(golden_inputs[s], layer1_out, layer2_out, final_out);
        
        // Verify each layer
        int sample_passed = 1;
        
        // Verify Layer 1
        int l1_pass = 1;
        for(int i = 0; i < 128; i++) {
            if(layer1_out[i] != golden_layer1_outputs[s][i]) {
                l1_pass = 0;
                layer1_failures++;
                break;
            }
        }
        if(!l1_pass) {
            sample_passed = 0;
            verify_layer_output("Layer 1", s+1, golden_layer1_outputs[s], layer1_out, 128);
        } else {
            cout << "  Layer 1: PASSED " << endl;
        }
        
        // Verify Layer 2
        int l2_pass = 1;
        for(int i = 0; i < 64; i++) {
            if(layer2_out[i] != golden_layer2_outputs[s][i]) {
                l2_pass = 0;
                layer2_failures++;
                break;
            }
        }
        if(!l2_pass) {
            sample_passed = 0;
            verify_layer_output("Layer 2", s+1, golden_layer2_outputs[s], layer2_out, 64);
        } else {
            cout << "  Layer 2: PASSED " << endl;
        }
        
        // Verify Final Layer
        int l3_pass = 1;
        for(int i = 0; i < 10; i++) {
            if(final_out[i] != golden_outputs[s][i]) {
                l3_pass = 0;
                layer3_failures++;
                break;
            }
        }
        if(!l3_pass) {
            sample_passed = 0;
            verify_layer_output("Layer 3", s+1, golden_outputs[s], final_out, 10);
        } else {
            cout << "  Layer 3: PASSED " << endl;
        }
        
        // Overall sample result
        if(sample_passed) {
            total_passed++;
            cout << "Result: ALL LAYERS PASSED " << endl;
        } else {
            total_failed++;
            cout << "Result: FAILED " << endl;
        }
    }
    
    return 0;
}