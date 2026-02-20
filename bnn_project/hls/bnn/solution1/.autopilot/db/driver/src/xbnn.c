// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.2.2 (64-bit)
// Tool Version Limit: 2024.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
/***************************** Include Files *********************************/
#include "xbnn.h"

/************************** Function Implementation *************************/
#ifndef __linux__
int XBnn_CfgInitialize(XBnn *InstancePtr, XBnn_Config *ConfigPtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(ConfigPtr != NULL);

    InstancePtr->Control_BaseAddress = ConfigPtr->Control_BaseAddress;
    InstancePtr->IsReady = XIL_COMPONENT_IS_READY;

    return XST_SUCCESS;
}
#endif

void XBnn_Start(XBnn *InstancePtr) {
    u32 Data;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_AP_CTRL) & 0x80;
    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_AP_CTRL, Data | 0x01);
}

u32 XBnn_IsDone(XBnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_AP_CTRL);
    return (Data >> 1) & 0x1;
}

u32 XBnn_IsIdle(XBnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_AP_CTRL);
    return (Data >> 2) & 0x1;
}

u32 XBnn_IsReady(XBnn *InstancePtr) {
    u32 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_AP_CTRL);
    // check ap_start to see if the pcore is ready for next input
    return !(Data & 0x1);
}

void XBnn_EnableAutoRestart(XBnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_AP_CTRL, 0x80);
}

void XBnn_DisableAutoRestart(XBnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_AP_CTRL, 0);
}

void XBnn_Set_IN_r(XBnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IN_R_DATA, (u32)(Data));
    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IN_R_DATA + 4, (u32)(Data >> 32));
}

u64 XBnn_Get_IN_r(XBnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IN_R_DATA);
    Data += (u64)XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IN_R_DATA + 4) << 32;
    return Data;
}

void XBnn_Set_ys(XBnn *InstancePtr, u64 Data) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_YS_DATA, (u32)(Data));
    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_YS_DATA + 4, (u32)(Data >> 32));
}

u64 XBnn_Get_ys(XBnn *InstancePtr) {
    u64 Data;

    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Data = XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_YS_DATA);
    Data += (u64)XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_YS_DATA + 4) << 32;
    return Data;
}

void XBnn_InterruptGlobalEnable(XBnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_GIE, 1);
}

void XBnn_InterruptGlobalDisable(XBnn *InstancePtr) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_GIE, 0);
}

void XBnn_InterruptEnable(XBnn *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IER);
    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IER, Register | Mask);
}

void XBnn_InterruptDisable(XBnn *InstancePtr, u32 Mask) {
    u32 Register;

    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    Register =  XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IER);
    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IER, Register & (~Mask));
}

void XBnn_InterruptClear(XBnn *InstancePtr, u32 Mask) {
    Xil_AssertVoid(InstancePtr != NULL);
    Xil_AssertVoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    XBnn_WriteReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_ISR, Mask);
}

u32 XBnn_InterruptGetEnabled(XBnn *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_IER);
}

u32 XBnn_InterruptGetStatus(XBnn *InstancePtr) {
    Xil_AssertNonvoid(InstancePtr != NULL);
    Xil_AssertNonvoid(InstancePtr->IsReady == XIL_COMPONENT_IS_READY);

    return XBnn_ReadReg(InstancePtr->Control_BaseAddress, XBNN_CONTROL_ADDR_ISR);
}

