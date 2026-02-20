#ifndef __BNN_HEADER_
#define __BNN_HEADER_
#include <iostream>

using namespace std;

#include "ap_int.h"
#define DEBUG 1 

// External interface types (unchanged for compatibility)
typedef const unsigned int DTYPE; // used as an input type
typedef int ITYPE;                // used as an output type

// OPTIMIZATION 1: Add internal reduced bitwidth types
typedef ap_int<12> ITYPE_L1;  // Layer 1 outputs: range -784 to +784
typedef ap_int<9>  ITYPE_L2;  // Layer 2 outputs: range -128 to +128  
typedef ap_int<8>  ITYPE_L3;  // Layer 3 outputs: range -64 to +64

const int SIZE = 25;
void bnn(DTYPE IN[SIZE], ITYPE ys[10]);
void bnn_with_layers(DTYPE IN[SIZE], ITYPE layer1[128], ITYPE layer2[64], ITYPE layer3[10]);

#endif