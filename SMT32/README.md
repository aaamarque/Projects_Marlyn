# STM32 LED Blinker Project

```
├── STM32
│   ├── main.c ==> main program with PID blinking logic
│   ├── leds.c ==> LED driver implementation
│   ├── leds.h ==> LED driver header
│   ├── timer.c ==> Timer peripheral driver implementation
│   ├── timer.h ==> Timer peripheral header
│   ├── STM32.MOV ==> Demo video
│   └── README.md
```

**Demo Video:** STM32.MOV (See project folder)

## Project Overview

This project implements a Personal ID (PID) blinker on an STM32L475 microcontroller using two LEDs (PA5 and PB14). The system encodes a PID using a preamble pattern followed by 2-bit chunks transmitted in reverse order, creating a visual binary communication system.

---

## 1) **System Architecture & Implementation**

### **Main Program (main.c)**

The main program orchestrates the PID blinking sequence using interrupt-driven timing. Key features include:

- **PID Encoding:** The PID is encoded as `REVERSE_TWO_PPID = 0b110011010101000001100110` (24-bit pattern including preamble)
- **Bit-Pair Transmission:** Transmits 2 bits at a time using two LEDs to represent binary values (0b00, 0b01, 0b10, 0b11)
- **Interrupt-Driven Design:** Uses Timer 2 (TIM2) interrupts to control blink timing at 49ms intervals
- **State Machine:** Implements `blink_ppid()` function that shifts through the encoded pattern, automatically reloading when complete

The interrupt handler `TIM2_IRQHandler()` sets a software flag that triggers the next bit-pair display in the main loop, ensuring clean separation between interrupt context and main execution.

### **LED Driver (leds.c / leds.h)**

Provides hardware abstraction for controlling the two LEDs:

- **Initialization:** Configures GPIO ports A and B with proper clock enables, mode settings (output), and pin characteristics
- **Pin Configuration:** Sets PA5 and PB14 as push-pull outputs with appropriate speed settings
- **LED Control:** `leds_set(uint8_t led)` function takes a 2-bit value and drives both LEDs accordingly:
  - Bit 0 (LSB) → PA5
  - Bit 1 (MSB) → PB14

### **Timer Driver (timer.c / timer.h)**

Manages TIM2 peripheral for precise timing:

- **Clock Configuration:** Sets up APB1 clock for TIM2 with prescaler (`PRESCALER_TO_MS = 3999`) to achieve millisecond resolution
- **Interrupt Setup:** Configures NVIC with priority 0 and enables timer interrupts
- **Flexible Timing:** `timer_set_ms()` function allows dynamic period adjustment
- **Timer Control:** Provides initialization and reset capabilities for clean timer operation

---

## 2) **Design Techniques & Optimizations**

### **Interrupt-Driven Architecture**

- **Non-Blocking Design:** Main loop does busy-wait; it responds to interrupt flags 
- **Flag-Based Synchronization:** Software interrupt flag (`interrupt_flag`) provides communication between main loop and interrupt.

### **Bit Manipulation & Encoding**

- **Efficient Bit Shifting:** Uses right-shift operations (`>> 2`) to extract 2-bit chunks without loops
- **Mask-Based Extraction:** `PPID_MASK = 0b11` isolates the least significant 2 bits for display
- **Automatic Reload:** Pattern automatically reloads when fully shifted out.


### **Memory Efficiency**

- **Static Variables:** `blink_ppid()` uses static storage for pattern state.

---

## 3) **Hardware Configuration & Peripherals**

### **GPIO Configuration**

Both LED pins are configured with:

- **Mode:** General Purpose Output
- **Type:** Push-Pull
- **Pull-up/Pull-down:** Disabled
- **Speed:** Low speed mode

### **Timer Configuration (TIM2)**

- **Clock Source:** APB1 peripheral bus
- **Prescaler:** 3999
- **Auto-Reload:** Configurable via `timer_set_ms()` for desired blink period
- **Update Interrupt:** Enabled to trigger on counter overflow.

---

## 4) **Demo & Operation**

### **Visual Communication Protocol**

The system implements a binary communication protocol using two LEDs:

- **2-bit Encoding:** Each state represents a 2-bit value:
  - Both OFF = 0b00
  - PA5 ON, PB14 OFF = 0b01
  - PA5 OFF, PB14 ON = 0b10
  - Both ON = 0b11
- **Transmission Format:** Preamble (for synchronization) + PID in reverse 2-bit chunks
- **Timing:** 49ms per 2-bit chunk provides clear visual separation

### **Testing & Verification**

To verify correct operation:

1. **Visual Inspection:** Watch LED pattern.


