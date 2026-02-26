// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2024.2.2 (64-bit)
// Tool Version Limit: 2024.11
// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
// 
// ==============================================================
#ifndef __linux__

#include "xstatus.h"
#ifdef SDT
#include "xparameters.h"
#endif
#include "xbnn.h"

extern XBnn_Config XBnn_ConfigTable[];

#ifdef SDT
XBnn_Config *XBnn_LookupConfig(UINTPTR BaseAddress) {
	XBnn_Config *ConfigPtr = NULL;

	int Index;

	for (Index = (u32)0x0; XBnn_ConfigTable[Index].Name != NULL; Index++) {
		if (!BaseAddress || XBnn_ConfigTable[Index].Control_BaseAddress == BaseAddress) {
			ConfigPtr = &XBnn_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XBnn_Initialize(XBnn *InstancePtr, UINTPTR BaseAddress) {
	XBnn_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XBnn_LookupConfig(BaseAddress);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XBnn_CfgInitialize(InstancePtr, ConfigPtr);
}
#else
XBnn_Config *XBnn_LookupConfig(u16 DeviceId) {
	XBnn_Config *ConfigPtr = NULL;

	int Index;

	for (Index = 0; Index < XPAR_XBNN_NUM_INSTANCES; Index++) {
		if (XBnn_ConfigTable[Index].DeviceId == DeviceId) {
			ConfigPtr = &XBnn_ConfigTable[Index];
			break;
		}
	}

	return ConfigPtr;
}

int XBnn_Initialize(XBnn *InstancePtr, u16 DeviceId) {
	XBnn_Config *ConfigPtr;

	Xil_AssertNonvoid(InstancePtr != NULL);

	ConfigPtr = XBnn_LookupConfig(DeviceId);
	if (ConfigPtr == NULL) {
		InstancePtr->IsReady = 0;
		return (XST_DEVICE_NOT_FOUND);
	}

	return XBnn_CfgInitialize(InstancePtr, ConfigPtr);
}
#endif

#endif

