# Projects Portfolio

This repository showcases two distinct embedded systems projects demonstrating expertise in FPGA acceleration, high-level synthesis, embedded C programming, and hardware abstraction layer design.

---

## Repository Structure

```
BNN_Project/
├── BNN/                    ==> Binary Neural Network FPGA Implementation
│   ├── bnn_project/
│   │   ├── hls/           ==> Vitis HLS C++ implementation & testbenches
│   │   └── python/        ==> Python reference model & dataset
│   ├── Demo/              ==> Jupyter notebook demo on PYNQ board
│   └── README.md
│
├── STM32/                  ==> STM32 Microcontroller LED Communication
│   ├── main.c             ==> Interrupt-driven PID blinking logic
│   ├── leds.c/h           ==> GPIO LED driver
│   ├── timer.c/h          ==> Timer peripheral driver
│   └── README.md
│
└── README.md              ==> This file
```

---

## Project 1: Binary Neural Network (BNN) on FPGA

### **Overview**

A hardware-accelerated Binary Neural Network implementation for MNIST digit classification on a Xilinx PYNQ-Z2 FPGA board. The project shows high-level synthesis techniques.

### **Key Technologies**

- **Languages:** C/C++ (HLS), Python, Verilog (generated)
- **Tools:** Vivado, Xilinx Vitis HLS, PYNQ Framework, Jupyter Notebook
- **Hardware:** Xilinx PYNQ-Z2 (Zynq-7020 SoC)
- **Interfaces:** AXI4 Master/Slave, DMA

### **Technical Highlights**

#### **1. HLS Optimization Techniques**

- **Array Partitioning:** Complete partitioning enables parallel memory access
- **Loop Unrolling:** Strategic unrolling (factor=2) balances throughput and resource usage

#### **2. Hardware-Software Co-Design**

- **AXI4 Interface:** Burst transfers (max_read_burst_length=32) for efficient DDR memory access
- **Golden Reference Verification:** Python-generated test vectors validate each neural network layer

#### **3. Performance Metrics**

| Optimization  | Throughput   | Latency        | Interval      | BRAM | FF  | LUT |
| ------------- | ------------ | -------------- | ------------- | ---- | --- | --- |
| Baseline      | 720 KHz      | 189 cycles     | 190 cycles    | 33   | 11K | 28K |
| **Optimized** | **1.82 MHz** | **188 cycles** | **64 cycles** | 33   | 39K | 49K |



### **Skills Demonstrated**

- High-Level Synthesis (HLS) optimization
- FPGA resource management (BRAM, LUT, FF, DSP)
- AXI bus protocols and DMA
- Hardware/software co-verification
- Binary neural network algorithms

---

## Project 2: STM32 Interrupt-Driven LED Communication

### **Overview**

An embedded C project implementing a visual binary communication system on an STM32L475 microcontroller. The system transmits a 24-bit pattern using two LEDs in 2-bit chunks, demonstrating interrupt-driven design and hardware abstraction principles.

### **Key Technologies**

- **Language:** Embedded C
- **Hardware:** STM32L475 Discovery Board (ARM Cortex-M4F)
- **Peripherals:** GPIO (2 LEDs), TIM2 (Hardware Timer), NVIC (Interrupt Controller)
- **Architecture:** Bare-metal (no RTOS)

### **Technical Highlights**

#### **1. Interrupt-Driven Architecture**

- **Timer-Based Synchronization:** TIM2 generates precise 49ms interrupts for bit transmission
- **Flag-Based Communication:** Volatile flag ensures safe interrupt-to-main-loop signaling

#### **2. Hardware Abstraction Layer (HAL)**

- **Modular Driver Design:** Separate LED and Timer drivers for code reusability
- **Register-Level Programming:** Direct manipulation of STM32 peripheral registers
  - GPIO configuration (MODER, OTYPER, PUPDR, OSPEEDR, ODR)
  - Timer setup (PSC, ARR, CR1, DIER)
  - Clock management (RCC AHB2ENR, APB1ENR1)


### **System Timing**

- **Bit Rate:** 49ms per 2-bit chunk
- **Total Pattern Period:** 12 chunks × 49ms = **588ms**

### **Skills Demonstrated**

- Embedded C programming (bare-metal)
- ARM Cortex-M4 architecture
- Interrupt-driven system design
- Hardware abstraction layer (HAL) development
- Peripheral configuration (GPIO, Timers, NVIC)
- Bit manipulation and binary protocols
- Register-level hardware control
- Real-time embedded systems concepts

---
