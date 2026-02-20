set moduleName bnn
set isTopModule 1
set isCombinational 0
set isDatapathOnly 0
set isPipelined 1
set pipeline_type dataflow
set FunctionProtocol ap_ctrl_hs
set isOneStateSeq 0
set ProfileFlag 0
set StallSigGenFlag 0
set isEnableWaveformDebug 1
set hasInterrupt 0
set DLRegFirstOffset 0
set DLRegItemOffset 0
set svuvm_can_support 1
set cdfgNum 10
set C_modelName {bnn}
set C_modelType { void 0 }
set ap_memory_interface_dict [dict create]
set C_modelArgList {
	{ gmem int 32 regular {axi_master 2}  }
	{ IN_r int 64 regular {axi_slave 0}  }
	{ ys int 64 regular {axi_slave 0}  }
}
set hasAXIMCache 0
set l_AXIML2Cache [list]
set AXIMCacheInstDict [dict create]
set C_modelArgMapList {[ 
	{ "Name" : "gmem", "interface" : "axi_master", "bitwidth" : 32, "direction" : "READWRITE", "bitSlice":[ {"cElement": [{"cName": "IN_r","offset": { "type": "dynamic","port_name": "IN_r","bundle": "control"},"direction": "READONLY"},{"cName": "ys","offset": { "type": "dynamic","port_name": "ys","bundle": "control"},"direction": "WRITEONLY"}]}]} , 
 	{ "Name" : "IN_r", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":16}, "offset_end" : {"in":27}} , 
 	{ "Name" : "ys", "interface" : "axi_slave", "bundle":"control","type":"ap_none","bitwidth" : 64, "direction" : "READONLY", "offset" : {"in":28}, "offset_end" : {"in":39}} ]}
# RTL Port declarations: 
set portNum 65
set portList { 
	{ s_axi_control_AWVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_AWREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_AWADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_WVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_WREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_WDATA sc_in sc_lv 32 signal -1 } 
	{ s_axi_control_WSTRB sc_in sc_lv 4 signal -1 } 
	{ s_axi_control_ARVALID sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_ARREADY sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_ARADDR sc_in sc_lv 6 signal -1 } 
	{ s_axi_control_RVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_RREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_RDATA sc_out sc_lv 32 signal -1 } 
	{ s_axi_control_RRESP sc_out sc_lv 2 signal -1 } 
	{ s_axi_control_BVALID sc_out sc_logic 1 signal -1 } 
	{ s_axi_control_BREADY sc_in sc_logic 1 signal -1 } 
	{ s_axi_control_BRESP sc_out sc_lv 2 signal -1 } 
	{ ap_clk sc_in sc_logic 1 clock -1 } 
	{ ap_rst_n sc_in sc_logic 1 reset -1 active_low_sync } 
	{ interrupt sc_out sc_logic 1 signal -1 } 
	{ m_axi_gmem_AWVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_AWREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_AWADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_AWID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_AWLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_gmem_AWSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_AWBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_AWLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_AWCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_AWPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_AWQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_AWREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_AWUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_WVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_WREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_WDATA sc_out sc_lv 32 signal 0 } 
	{ m_axi_gmem_WSTRB sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_WLAST sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_WID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_WUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_ARVALID sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_ARREADY sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_ARADDR sc_out sc_lv 64 signal 0 } 
	{ m_axi_gmem_ARID sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_ARLEN sc_out sc_lv 8 signal 0 } 
	{ m_axi_gmem_ARSIZE sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_ARBURST sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_ARLOCK sc_out sc_lv 2 signal 0 } 
	{ m_axi_gmem_ARCACHE sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_ARPROT sc_out sc_lv 3 signal 0 } 
	{ m_axi_gmem_ARQOS sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_ARREGION sc_out sc_lv 4 signal 0 } 
	{ m_axi_gmem_ARUSER sc_out sc_lv 1 signal 0 } 
	{ m_axi_gmem_RVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_RREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_RDATA sc_in sc_lv 32 signal 0 } 
	{ m_axi_gmem_RLAST sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_RID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_RUSER sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_RRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_BVALID sc_in sc_logic 1 signal 0 } 
	{ m_axi_gmem_BREADY sc_out sc_logic 1 signal 0 } 
	{ m_axi_gmem_BRESP sc_in sc_lv 2 signal 0 } 
	{ m_axi_gmem_BID sc_in sc_lv 1 signal 0 } 
	{ m_axi_gmem_BUSER sc_in sc_lv 1 signal 0 } 
}
set NewPortList {[ 
	{ "name": "s_axi_control_AWADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "AWADDR" },"address":[{"name":"bnn","role":"start","value":"0","valid_bit":"0"},{"name":"bnn","role":"continue","value":"0","valid_bit":"4"},{"name":"bnn","role":"auto_start","value":"0","valid_bit":"7"},{"name":"IN_r","role":"data","value":"16"},{"name":"ys","role":"data","value":"28"}] },
	{ "name": "s_axi_control_AWVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWVALID" } },
	{ "name": "s_axi_control_AWREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "AWREADY" } },
	{ "name": "s_axi_control_WVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WVALID" } },
	{ "name": "s_axi_control_WREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "WREADY" } },
	{ "name": "s_axi_control_WDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "WDATA" } },
	{ "name": "s_axi_control_WSTRB", "direction": "in", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "control", "role": "WSTRB" } },
	{ "name": "s_axi_control_ARADDR", "direction": "in", "datatype": "sc_lv", "bitwidth":6, "type": "signal", "bundle":{"name": "control", "role": "ARADDR" },"address":[{"name":"bnn","role":"start","value":"0","valid_bit":"0"},{"name":"bnn","role":"done","value":"0","valid_bit":"1"},{"name":"bnn","role":"idle","value":"0","valid_bit":"2"},{"name":"bnn","role":"ready","value":"0","valid_bit":"3"},{"name":"bnn","role":"auto_start","value":"0","valid_bit":"7"}] },
	{ "name": "s_axi_control_ARVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARVALID" } },
	{ "name": "s_axi_control_ARREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "ARREADY" } },
	{ "name": "s_axi_control_RVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RVALID" } },
	{ "name": "s_axi_control_RREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "RREADY" } },
	{ "name": "s_axi_control_RDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "control", "role": "RDATA" } },
	{ "name": "s_axi_control_RRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "RRESP" } },
	{ "name": "s_axi_control_BVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BVALID" } },
	{ "name": "s_axi_control_BREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "BREADY" } },
	{ "name": "s_axi_control_BRESP", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "control", "role": "BRESP" } },
	{ "name": "interrupt", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "control", "role": "interrupt" } }, 
 	{ "name": "ap_clk", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "clock", "bundle":{"name": "ap_clk", "role": "default" }} , 
 	{ "name": "ap_rst_n", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "reset", "bundle":{"name": "ap_rst_n", "role": "default" }} , 
 	{ "name": "m_axi_gmem_AWVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWVALID" }} , 
 	{ "name": "m_axi_gmem_AWREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWREADY" }} , 
 	{ "name": "m_axi_gmem_AWADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem", "role": "AWADDR" }} , 
 	{ "name": "m_axi_gmem_AWID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWID" }} , 
 	{ "name": "m_axi_gmem_AWLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem", "role": "AWLEN" }} , 
 	{ "name": "m_axi_gmem_AWSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "AWSIZE" }} , 
 	{ "name": "m_axi_gmem_AWBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "AWBURST" }} , 
 	{ "name": "m_axi_gmem_AWLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "AWLOCK" }} , 
 	{ "name": "m_axi_gmem_AWCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "AWCACHE" }} , 
 	{ "name": "m_axi_gmem_AWPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "AWPROT" }} , 
 	{ "name": "m_axi_gmem_AWQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "AWQOS" }} , 
 	{ "name": "m_axi_gmem_AWREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "AWREGION" }} , 
 	{ "name": "m_axi_gmem_AWUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "AWUSER" }} , 
 	{ "name": "m_axi_gmem_WVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WVALID" }} , 
 	{ "name": "m_axi_gmem_WREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WREADY" }} , 
 	{ "name": "m_axi_gmem_WDATA", "direction": "out", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "WDATA" }} , 
 	{ "name": "m_axi_gmem_WSTRB", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "WSTRB" }} , 
 	{ "name": "m_axi_gmem_WLAST", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WLAST" }} , 
 	{ "name": "m_axi_gmem_WID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WID" }} , 
 	{ "name": "m_axi_gmem_WUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "WUSER" }} , 
 	{ "name": "m_axi_gmem_ARVALID", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARVALID" }} , 
 	{ "name": "m_axi_gmem_ARREADY", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARREADY" }} , 
 	{ "name": "m_axi_gmem_ARADDR", "direction": "out", "datatype": "sc_lv", "bitwidth":64, "type": "signal", "bundle":{"name": "gmem", "role": "ARADDR" }} , 
 	{ "name": "m_axi_gmem_ARID", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARID" }} , 
 	{ "name": "m_axi_gmem_ARLEN", "direction": "out", "datatype": "sc_lv", "bitwidth":8, "type": "signal", "bundle":{"name": "gmem", "role": "ARLEN" }} , 
 	{ "name": "m_axi_gmem_ARSIZE", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "ARSIZE" }} , 
 	{ "name": "m_axi_gmem_ARBURST", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "ARBURST" }} , 
 	{ "name": "m_axi_gmem_ARLOCK", "direction": "out", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "ARLOCK" }} , 
 	{ "name": "m_axi_gmem_ARCACHE", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "ARCACHE" }} , 
 	{ "name": "m_axi_gmem_ARPROT", "direction": "out", "datatype": "sc_lv", "bitwidth":3, "type": "signal", "bundle":{"name": "gmem", "role": "ARPROT" }} , 
 	{ "name": "m_axi_gmem_ARQOS", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "ARQOS" }} , 
 	{ "name": "m_axi_gmem_ARREGION", "direction": "out", "datatype": "sc_lv", "bitwidth":4, "type": "signal", "bundle":{"name": "gmem", "role": "ARREGION" }} , 
 	{ "name": "m_axi_gmem_ARUSER", "direction": "out", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "ARUSER" }} , 
 	{ "name": "m_axi_gmem_RVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RVALID" }} , 
 	{ "name": "m_axi_gmem_RREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RREADY" }} , 
 	{ "name": "m_axi_gmem_RDATA", "direction": "in", "datatype": "sc_lv", "bitwidth":32, "type": "signal", "bundle":{"name": "gmem", "role": "RDATA" }} , 
 	{ "name": "m_axi_gmem_RLAST", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RLAST" }} , 
 	{ "name": "m_axi_gmem_RID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RID" }} , 
 	{ "name": "m_axi_gmem_RUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "RUSER" }} , 
 	{ "name": "m_axi_gmem_RRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "RRESP" }} , 
 	{ "name": "m_axi_gmem_BVALID", "direction": "in", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BVALID" }} , 
 	{ "name": "m_axi_gmem_BREADY", "direction": "out", "datatype": "sc_logic", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BREADY" }} , 
 	{ "name": "m_axi_gmem_BRESP", "direction": "in", "datatype": "sc_lv", "bitwidth":2, "type": "signal", "bundle":{"name": "gmem", "role": "BRESP" }} , 
 	{ "name": "m_axi_gmem_BID", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BID" }} , 
 	{ "name": "m_axi_gmem_BUSER", "direction": "in", "datatype": "sc_lv", "bitwidth":1, "type": "signal", "bundle":{"name": "gmem", "role": "BUSER" }}  ]}

set RtlHierarchyInfo {[
	{"ID" : "0", "Level" : "0", "Path" : "`AUTOTB_DUT_INST", "Parent" : "", "Child" : ["1", "2", "3", "4", "5", "32", "66", "72", "74", "78", "79", "80", "81", "82", "83", "84", "85", "86", "87", "88", "89", "90", "91", "92", "93", "94", "95", "96", "97", "98", "99", "100", "101", "102", "103", "104", "105", "106", "107", "108", "109", "110", "111", "112", "113", "114", "115", "116", "117", "118", "119", "120", "121", "122", "123", "124", "125", "126", "127", "128", "129", "130", "131", "132", "133", "134", "135", "136", "137", "138", "139", "140", "141", "142", "143", "144", "145", "146", "147", "148", "149", "150", "151", "152", "153", "154", "155", "156", "157", "158", "159", "160", "161", "162", "163", "164", "165", "166", "167", "168", "169", "170", "171", "172", "173", "174", "175", "176", "177", "178", "179", "180", "181", "182", "183", "184", "185", "186", "187", "188", "189", "190", "191", "192", "193", "194", "195", "196", "197", "198", "199", "200", "201", "202", "203", "204", "205", "206", "207", "208", "209", "210", "211", "212", "213", "214", "215", "216", "217", "218", "219", "220", "221", "222", "223", "224", "225", "226", "227", "228", "229", "230", "231", "232", "233", "234", "235", "236", "237", "238", "239", "240", "241", "242", "243", "244", "245", "246", "247", "248", "249", "250", "251", "252", "253", "254", "255", "256", "257", "258", "259", "260", "261", "262", "263", "264", "265", "266", "267", "268", "269", "270", "271", "272", "273", "274", "275", "276", "277", "278", "279", "280", "281", "282", "283", "284", "285", "286", "287", "288", "289", "290", "291", "292", "293", "294", "295", "296", "297", "298", "299", "300", "301", "302", "303", "304", "305", "306", "307", "308", "309", "310", "311", "312"],
		"CDFG" : "bnn",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "0", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "Dataflow", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "1",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "188", "EstimateLatencyMax" : "188",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "1",
		"InDataflowNetwork" : "0",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"InputProcess" : [
			{"ID" : "3", "Name" : "entry_proc_U0"},
			{"ID" : "4", "Name" : "Block_entry_gmem_rd_proc_U0"}],
		"OutputProcess" : [
			{"ID" : "78", "Name" : "Block_entry_gmem_wr_proc_U0"}],
		"Port" : [
			{"Name" : "gmem", "Type" : "MAXI", "Direction" : "IO",
				"SubConnect" : [
					{"ID" : "4", "SubInstance" : "Block_entry_gmem_rd_proc_U0", "Port" : "gmem"},
					{"ID" : "78", "SubInstance" : "Block_entry_gmem_wr_proc_U0", "Port" : "gmem"}]},
			{"Name" : "IN_r", "Type" : "None", "Direction" : "I"},
			{"Name" : "ys", "Type" : "None", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_0"}]},
			{"Name" : "p_ZL9golden_w1_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_1"}]},
			{"Name" : "p_ZL9golden_w1_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_2"}]},
			{"Name" : "p_ZL9golden_w1_3", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_3"}]},
			{"Name" : "p_ZL9golden_w1_4", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_4"}]},
			{"Name" : "p_ZL9golden_w1_5", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_5"}]},
			{"Name" : "p_ZL9golden_w1_6", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_6"}]},
			{"Name" : "p_ZL9golden_w1_7", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_7"}]},
			{"Name" : "p_ZL9golden_w1_8", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_8"}]},
			{"Name" : "p_ZL9golden_w1_9", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_9"}]},
			{"Name" : "p_ZL9golden_w1_10", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_10"}]},
			{"Name" : "p_ZL9golden_w1_11", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_11"}]},
			{"Name" : "p_ZL9golden_w1_12", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_12"}]},
			{"Name" : "p_ZL9golden_w1_13", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_13"}]},
			{"Name" : "p_ZL9golden_w1_14", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_14"}]},
			{"Name" : "p_ZL9golden_w1_15", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_15"}]},
			{"Name" : "p_ZL9golden_w1_16", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_16"}]},
			{"Name" : "p_ZL9golden_w1_17", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_17"}]},
			{"Name" : "p_ZL9golden_w1_18", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_18"}]},
			{"Name" : "p_ZL9golden_w1_19", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_19"}]},
			{"Name" : "p_ZL9golden_w1_20", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_20"}]},
			{"Name" : "p_ZL9golden_w1_21", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_21"}]},
			{"Name" : "p_ZL9golden_w1_22", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_22"}]},
			{"Name" : "p_ZL9golden_w1_23", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_23"}]},
			{"Name" : "p_ZL9golden_w1_24", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "5", "SubInstance" : "dense_layer_U0", "Port" : "p_ZL9golden_w1_24"}]},
			{"Name" : "p_ZL9golden_w2_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "66", "SubInstance" : "dense_layer_1_U0", "Port" : "p_ZL9golden_w2_0"}]},
			{"Name" : "p_ZL9golden_w2_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "66", "SubInstance" : "dense_layer_1_U0", "Port" : "p_ZL9golden_w2_1"}]},
			{"Name" : "p_ZL9golden_w2_2", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "66", "SubInstance" : "dense_layer_1_U0", "Port" : "p_ZL9golden_w2_2"}]},
			{"Name" : "p_ZL9golden_w2_3", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "66", "SubInstance" : "dense_layer_1_U0", "Port" : "p_ZL9golden_w2_3"}]},
			{"Name" : "p_ZL9golden_w3_0", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "74", "SubInstance" : "dense_layer_3_U0", "Port" : "p_ZL9golden_w3_0"}]},
			{"Name" : "p_ZL9golden_w3_1", "Type" : "Memory", "Direction" : "I",
				"SubConnect" : [
					{"ID" : "74", "SubInstance" : "dense_layer_3_U0", "Port" : "p_ZL9golden_w3_1"}]}]},
	{"ID" : "1", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.control_s_axi_U", "Parent" : "0"},
	{"ID" : "2", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.gmem_m_axi_U", "Parent" : "0"},
	{"ID" : "3", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.entry_proc_U0", "Parent" : "0",
		"CDFG" : "entry_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "1",
		"VariableLatency" : "0", "ExactLatency" : "0", "EstimateLatencyMin" : "0", "EstimateLatencyMax" : "0",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "ys", "Type" : "None", "Direction" : "I"},
			{"Name" : "ys_c", "Type" : "Fifo", "Direction" : "O", "DependentProc" : ["78"], "DependentChan" : "79", "DependentChanDepth" : "8", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "ys_c_blk_n", "Type" : "RtlSignal"}]}]},
	{"ID" : "4", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Block_entry_gmem_rd_proc_U0", "Parent" : "0",
		"CDFG" : "Block_entry_gmem_rd_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "32", "EstimateLatencyMax" : "32",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "IN_r", "Type" : "None", "Direction" : "I"},
			{"Name" : "gmem", "Type" : "MAXI", "Direction" : "I",
				"BlockSignal" : [
					{"Name" : "gmem_blk_n_AR", "Type" : "RtlSignal"},
					{"Name" : "gmem_blk_n_R", "Type" : "RtlSignal"}]}]},
	{"ID" : "5", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0", "Parent" : "0", "Child" : ["6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"],
		"CDFG" : "dense_layer",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "72", "EstimateLatencyMax" : "72",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "80", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "81", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "82", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "83", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read4", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "84", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read5", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "85", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "86", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read7", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "87", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read8", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "88", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read9", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "89", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read10", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "90", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read11", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "91", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read12", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "92", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read13", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "93", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read14", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "94", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read15", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "95", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read16", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "96", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read17", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "97", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read18", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "98", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read19", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "99", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read20", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "100", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read21", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "101", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read22", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "102", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read23", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "103", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read24", "Type" : "None", "Direction" : "I", "DependentProc" : ["4"], "DependentChan" : "104", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_ZL9golden_w1_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_3", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_4", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_5", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_6", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_7", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_8", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_9", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_10", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_11", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_12", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_13", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_14", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_15", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_16", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_17", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_18", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_19", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_20", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_21", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_22", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_23", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w1_24", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_34_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter7", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter7", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "6", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_0_U", "Parent" : "5"},
	{"ID" : "7", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_1_U", "Parent" : "5"},
	{"ID" : "8", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_2_U", "Parent" : "5"},
	{"ID" : "9", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_3_U", "Parent" : "5"},
	{"ID" : "10", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_4_U", "Parent" : "5"},
	{"ID" : "11", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_5_U", "Parent" : "5"},
	{"ID" : "12", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_6_U", "Parent" : "5"},
	{"ID" : "13", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_7_U", "Parent" : "5"},
	{"ID" : "14", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_8_U", "Parent" : "5"},
	{"ID" : "15", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_9_U", "Parent" : "5"},
	{"ID" : "16", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_10_U", "Parent" : "5"},
	{"ID" : "17", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_11_U", "Parent" : "5"},
	{"ID" : "18", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_12_U", "Parent" : "5"},
	{"ID" : "19", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_13_U", "Parent" : "5"},
	{"ID" : "20", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_14_U", "Parent" : "5"},
	{"ID" : "21", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_15_U", "Parent" : "5"},
	{"ID" : "22", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_16_U", "Parent" : "5"},
	{"ID" : "23", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_17_U", "Parent" : "5"},
	{"ID" : "24", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_18_U", "Parent" : "5"},
	{"ID" : "25", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_19_U", "Parent" : "5"},
	{"ID" : "26", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_20_U", "Parent" : "5"},
	{"ID" : "27", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_21_U", "Parent" : "5"},
	{"ID" : "28", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_22_U", "Parent" : "5"},
	{"ID" : "29", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_23_U", "Parent" : "5"},
	{"ID" : "30", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.p_ZL9golden_w1_24_U", "Parent" : "5"},
	{"ID" : "31", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_U0.flow_control_loop_pipe_U", "Parent" : "5"},
	{"ID" : "32", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0", "Parent" : "0", "Child" : ["33", "34", "35", "36", "37", "38", "39", "40", "41", "42", "43", "44", "45", "46", "47", "48", "49", "50", "51", "52", "53", "54", "55", "56", "57", "58", "59", "60", "61", "62", "63", "64", "65"],
		"CDFG" : "sign_and_quantize",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "9", "EstimateLatencyMax" : "9",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "105", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "106", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "107", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "108", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read4", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "109", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read5", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "110", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "111", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read7", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "112", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read8", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "113", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read9", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "114", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read10", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "115", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read11", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "116", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read12", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "117", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read13", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "118", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read14", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "119", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read15", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "120", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read16", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "121", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read17", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "122", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read18", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "123", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read19", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "124", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read20", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "125", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read21", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "126", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read22", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "127", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read23", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "128", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read24", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "129", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read25", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "130", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read26", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "131", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read27", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "132", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read28", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "133", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read29", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "134", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read30", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "135", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read31", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "136", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read32", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "137", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read33", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "138", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read34", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "139", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read35", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "140", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read36", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "141", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read37", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "142", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read38", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "143", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read39", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "144", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read40", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "145", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read41", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "146", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read42", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "147", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read43", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "148", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read44", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "149", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read45", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "150", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read46", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "151", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read47", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "152", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read48", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "153", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read49", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "154", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read50", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "155", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read51", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "156", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read52", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "157", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read53", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "158", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read54", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "159", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read55", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "160", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read56", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "161", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read57", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "162", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read58", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "163", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read59", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "164", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read60", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "165", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read61", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "166", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read62", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "167", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read63", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "168", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read64", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "169", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read65", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "170", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read66", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "171", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read67", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "172", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read68", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "173", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read69", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "174", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read70", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "175", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read71", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "176", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read72", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "177", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read73", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "178", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read74", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "179", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read75", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "180", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read76", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "181", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read77", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "182", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read78", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "183", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read79", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "184", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read80", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "185", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read81", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "186", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read82", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "187", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read83", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "188", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read84", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "189", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read85", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "190", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read86", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "191", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read87", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "192", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read88", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "193", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read89", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "194", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read90", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "195", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read91", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "196", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read92", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "197", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read93", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "198", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read94", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "199", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read95", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "200", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read96", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "201", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read97", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "202", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read98", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "203", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read99", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "204", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read100", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "205", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read101", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "206", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read102", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "207", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read103", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "208", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read104", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "209", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read105", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "210", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read106", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "211", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read107", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "212", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read108", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "213", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read109", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "214", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read110", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "215", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read111", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "216", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read112", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "217", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read113", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "218", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read114", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "219", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read115", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "220", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read116", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "221", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read117", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "222", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read118", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "223", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read119", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "224", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read120", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "225", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read121", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "226", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read122", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "227", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read123", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "228", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read124", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "229", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read125", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "230", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read126", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "231", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read127", "Type" : "None", "Direction" : "I", "DependentProc" : ["5"], "DependentChan" : "232", "DependentChanDepth" : "2", "DependentChanType" : "1"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_71_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "33", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U55", "Parent" : "32"},
	{"ID" : "34", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U56", "Parent" : "32"},
	{"ID" : "35", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U57", "Parent" : "32"},
	{"ID" : "36", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U58", "Parent" : "32"},
	{"ID" : "37", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U59", "Parent" : "32"},
	{"ID" : "38", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U60", "Parent" : "32"},
	{"ID" : "39", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U61", "Parent" : "32"},
	{"ID" : "40", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U62", "Parent" : "32"},
	{"ID" : "41", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U63", "Parent" : "32"},
	{"ID" : "42", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U64", "Parent" : "32"},
	{"ID" : "43", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U65", "Parent" : "32"},
	{"ID" : "44", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U66", "Parent" : "32"},
	{"ID" : "45", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U67", "Parent" : "32"},
	{"ID" : "46", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U68", "Parent" : "32"},
	{"ID" : "47", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U69", "Parent" : "32"},
	{"ID" : "48", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U70", "Parent" : "32"},
	{"ID" : "49", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U71", "Parent" : "32"},
	{"ID" : "50", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U72", "Parent" : "32"},
	{"ID" : "51", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U73", "Parent" : "32"},
	{"ID" : "52", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U74", "Parent" : "32"},
	{"ID" : "53", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U75", "Parent" : "32"},
	{"ID" : "54", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U76", "Parent" : "32"},
	{"ID" : "55", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U77", "Parent" : "32"},
	{"ID" : "56", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U78", "Parent" : "32"},
	{"ID" : "57", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U79", "Parent" : "32"},
	{"ID" : "58", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U80", "Parent" : "32"},
	{"ID" : "59", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U81", "Parent" : "32"},
	{"ID" : "60", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U82", "Parent" : "32"},
	{"ID" : "61", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U83", "Parent" : "32"},
	{"ID" : "62", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U84", "Parent" : "32"},
	{"ID" : "63", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U85", "Parent" : "32"},
	{"ID" : "64", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.sparsemux_9_2_13_1_1_U86", "Parent" : "32"},
	{"ID" : "65", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_U0.flow_control_loop_pipe_U", "Parent" : "32"},
	{"ID" : "66", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.dense_layer_1_U0", "Parent" : "0", "Child" : ["67", "68", "69", "70", "71"],
		"CDFG" : "dense_layer_1",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "37", "EstimateLatencyMax" : "37",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["32"], "DependentChan" : "233", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["32"], "DependentChan" : "234", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I", "DependentProc" : ["32"], "DependentChan" : "235", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I", "DependentProc" : ["32"], "DependentChan" : "236", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_ZL9golden_w2_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w2_1", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w2_2", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w2_3", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_34_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "67", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_1_U0.p_ZL9golden_w2_0_U", "Parent" : "66"},
	{"ID" : "68", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_1_U0.p_ZL9golden_w2_1_U", "Parent" : "66"},
	{"ID" : "69", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_1_U0.p_ZL9golden_w2_2_U", "Parent" : "66"},
	{"ID" : "70", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_1_U0.p_ZL9golden_w2_3_U", "Parent" : "66"},
	{"ID" : "71", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_1_U0.flow_control_loop_pipe_U", "Parent" : "66"},
	{"ID" : "72", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_2_U0", "Parent" : "0", "Child" : ["73"],
		"CDFG" : "sign_and_quantize_2",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "6", "EstimateLatencyMax" : "6",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "237", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "238", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "239", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "240", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read4", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "241", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read5", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "242", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "243", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read7", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "244", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read8", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "245", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read9", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "246", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read10", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "247", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read11", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "248", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read12", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "249", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read13", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "250", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read14", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "251", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read15", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "252", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read16", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "253", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read17", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "254", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read18", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "255", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read19", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "256", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read20", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "257", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read21", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "258", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read22", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "259", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read23", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "260", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read24", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "261", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read25", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "262", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read26", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "263", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read27", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "264", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read28", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "265", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read29", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "266", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read30", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "267", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read31", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "268", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read32", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "269", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read33", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "270", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read34", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "271", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read35", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "272", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read36", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "273", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read37", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "274", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read38", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "275", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read39", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "276", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read40", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "277", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read41", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "278", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read42", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "279", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read43", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "280", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read44", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "281", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read45", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "282", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read46", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "283", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read47", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "284", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read48", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "285", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read49", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "286", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read50", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "287", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read51", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "288", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read52", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "289", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read53", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "290", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read54", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "291", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read55", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "292", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read56", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "293", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read57", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "294", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read58", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "295", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read59", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "296", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read60", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "297", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read61", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "298", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read62", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "299", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read63", "Type" : "None", "Direction" : "I", "DependentProc" : ["66"], "DependentChan" : "300", "DependentChanDepth" : "2", "DependentChanType" : "1"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_71_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter3", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter3", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "73", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.sign_and_quantize_2_U0.flow_control_loop_pipe_U", "Parent" : "72"},
	{"ID" : "74", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.dense_layer_3_U0", "Parent" : "0", "Child" : ["75", "76", "77"],
		"CDFG" : "dense_layer_3",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "10", "EstimateLatencyMax" : "10",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["72"], "DependentChan" : "301", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["72"], "DependentChan" : "302", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_ZL9golden_w3_0", "Type" : "Memory", "Direction" : "I"},
			{"Name" : "p_ZL9golden_w3_1", "Type" : "Memory", "Direction" : "I"}],
		"Loop" : [
			{"Name" : "VITIS_LOOP_34_1", "PipelineType" : "UPC",
				"LoopDec" : {"FSMBitwidth" : "1", "FirstState" : "ap_ST_fsm_pp0_stage0", "FirstStateIter" : "ap_enable_reg_pp0_iter0", "FirstStateBlock" : "ap_block_pp0_stage0_subdone", "LastState" : "ap_ST_fsm_pp0_stage0", "LastStateIter" : "ap_enable_reg_pp0_iter4", "LastStateBlock" : "ap_block_pp0_stage0_subdone", "QuitState" : "ap_ST_fsm_pp0_stage0", "QuitStateIter" : "ap_enable_reg_pp0_iter4", "QuitStateBlock" : "ap_block_pp0_stage0_subdone", "OneDepthLoop" : "0", "has_ap_ctrl" : "1", "has_continue" : "1"}}]},
	{"ID" : "75", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_3_U0.p_ZL9golden_w3_0_U", "Parent" : "74"},
	{"ID" : "76", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_3_U0.p_ZL9golden_w3_1_U", "Parent" : "74"},
	{"ID" : "77", "Level" : "2", "Path" : "`AUTOTB_DUT_INST.dense_layer_3_U0.flow_control_loop_pipe_U", "Parent" : "74"},
	{"ID" : "78", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.Block_entry_gmem_wr_proc_U0", "Parent" : "0",
		"CDFG" : "Block_entry_gmem_wr_proc",
		"Protocol" : "ap_ctrl_hs",
		"ControlExist" : "1", "ap_start" : "1", "ap_ready" : "1", "ap_done" : "1", "ap_continue" : "1", "ap_idle" : "1", "real_start" : "0",
		"Pipeline" : "None", "UnalignedPipeline" : "0", "RewindPipeline" : "0", "ProcessNetwork" : "0",
		"II" : "0",
		"VariableLatency" : "1", "ExactLatency" : "-1", "EstimateLatencyMin" : "16", "EstimateLatencyMax" : "16",
		"Combinational" : "0",
		"Datapath" : "0",
		"ClockEnable" : "0",
		"HasSubDataflow" : "0",
		"InDataflowNetwork" : "1",
		"HasNonBlockingOperation" : "0",
		"IsBlackBox" : "0",
		"Port" : [
			{"Name" : "ys", "Type" : "Fifo", "Direction" : "I", "DependentProc" : ["3"], "DependentChan" : "79", "DependentChanDepth" : "8", "DependentChanType" : "2",
				"BlockSignal" : [
					{"Name" : "ys_blk_n", "Type" : "RtlSignal"}]},
			{"Name" : "gmem", "Type" : "MAXI", "Direction" : "O",
				"BlockSignal" : [
					{"Name" : "gmem_blk_n_AW", "Type" : "RtlSignal"},
					{"Name" : "gmem_blk_n_W", "Type" : "RtlSignal"},
					{"Name" : "gmem_blk_n_B", "Type" : "RtlSignal"}]},
			{"Name" : "p_read", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "303", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read1", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "304", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read2", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "305", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read3", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "306", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read4", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "307", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read5", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "308", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read6", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "309", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read7", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "310", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read8", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "311", "DependentChanDepth" : "2", "DependentChanType" : "1"},
			{"Name" : "p_read9", "Type" : "None", "Direction" : "I", "DependentProc" : ["74"], "DependentChan" : "312", "DependentChanDepth" : "2", "DependentChanType" : "1"}]},
	{"ID" : "79", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.ys_c_U", "Parent" : "0"},
	{"ID" : "80", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc_channel_U", "Parent" : "0"},
	{"ID" : "81", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc2_channel_U", "Parent" : "0"},
	{"ID" : "82", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc3_channel_U", "Parent" : "0"},
	{"ID" : "83", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc4_channel_U", "Parent" : "0"},
	{"ID" : "84", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc5_channel_U", "Parent" : "0"},
	{"ID" : "85", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc6_channel_U", "Parent" : "0"},
	{"ID" : "86", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc7_channel_U", "Parent" : "0"},
	{"ID" : "87", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc8_channel_U", "Parent" : "0"},
	{"ID" : "88", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc9_channel_U", "Parent" : "0"},
	{"ID" : "89", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc10_channel_U", "Parent" : "0"},
	{"ID" : "90", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc11_channel_U", "Parent" : "0"},
	{"ID" : "91", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc12_channel_U", "Parent" : "0"},
	{"ID" : "92", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc13_channel_U", "Parent" : "0"},
	{"ID" : "93", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc14_channel_U", "Parent" : "0"},
	{"ID" : "94", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc15_channel_U", "Parent" : "0"},
	{"ID" : "95", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc16_channel_U", "Parent" : "0"},
	{"ID" : "96", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc17_channel_U", "Parent" : "0"},
	{"ID" : "97", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc18_channel_U", "Parent" : "0"},
	{"ID" : "98", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc19_channel_U", "Parent" : "0"},
	{"ID" : "99", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc20_channel_U", "Parent" : "0"},
	{"ID" : "100", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc21_channel_U", "Parent" : "0"},
	{"ID" : "101", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc22_channel_U", "Parent" : "0"},
	{"ID" : "102", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc23_channel_U", "Parent" : "0"},
	{"ID" : "103", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc24_channel_U", "Parent" : "0"},
	{"ID" : "104", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.p_loc25_channel_U", "Parent" : "0"},
	{"ID" : "105", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_U", "Parent" : "0"},
	{"ID" : "106", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_1_U", "Parent" : "0"},
	{"ID" : "107", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_2_U", "Parent" : "0"},
	{"ID" : "108", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_3_U", "Parent" : "0"},
	{"ID" : "109", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_4_U", "Parent" : "0"},
	{"ID" : "110", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_5_U", "Parent" : "0"},
	{"ID" : "111", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_6_U", "Parent" : "0"},
	{"ID" : "112", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_7_U", "Parent" : "0"},
	{"ID" : "113", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_8_U", "Parent" : "0"},
	{"ID" : "114", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_9_U", "Parent" : "0"},
	{"ID" : "115", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_10_U", "Parent" : "0"},
	{"ID" : "116", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_11_U", "Parent" : "0"},
	{"ID" : "117", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_12_U", "Parent" : "0"},
	{"ID" : "118", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_13_U", "Parent" : "0"},
	{"ID" : "119", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_14_U", "Parent" : "0"},
	{"ID" : "120", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_15_U", "Parent" : "0"},
	{"ID" : "121", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_16_U", "Parent" : "0"},
	{"ID" : "122", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_17_U", "Parent" : "0"},
	{"ID" : "123", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_18_U", "Parent" : "0"},
	{"ID" : "124", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_19_U", "Parent" : "0"},
	{"ID" : "125", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_20_U", "Parent" : "0"},
	{"ID" : "126", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_21_U", "Parent" : "0"},
	{"ID" : "127", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_22_U", "Parent" : "0"},
	{"ID" : "128", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_23_U", "Parent" : "0"},
	{"ID" : "129", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_24_U", "Parent" : "0"},
	{"ID" : "130", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_25_U", "Parent" : "0"},
	{"ID" : "131", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_26_U", "Parent" : "0"},
	{"ID" : "132", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_27_U", "Parent" : "0"},
	{"ID" : "133", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_28_U", "Parent" : "0"},
	{"ID" : "134", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_29_U", "Parent" : "0"},
	{"ID" : "135", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_30_U", "Parent" : "0"},
	{"ID" : "136", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_31_U", "Parent" : "0"},
	{"ID" : "137", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_32_U", "Parent" : "0"},
	{"ID" : "138", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_33_U", "Parent" : "0"},
	{"ID" : "139", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_34_U", "Parent" : "0"},
	{"ID" : "140", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_35_U", "Parent" : "0"},
	{"ID" : "141", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_36_U", "Parent" : "0"},
	{"ID" : "142", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_37_U", "Parent" : "0"},
	{"ID" : "143", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_38_U", "Parent" : "0"},
	{"ID" : "144", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_39_U", "Parent" : "0"},
	{"ID" : "145", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_40_U", "Parent" : "0"},
	{"ID" : "146", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_41_U", "Parent" : "0"},
	{"ID" : "147", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_42_U", "Parent" : "0"},
	{"ID" : "148", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_43_U", "Parent" : "0"},
	{"ID" : "149", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_44_U", "Parent" : "0"},
	{"ID" : "150", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_45_U", "Parent" : "0"},
	{"ID" : "151", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_46_U", "Parent" : "0"},
	{"ID" : "152", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_47_U", "Parent" : "0"},
	{"ID" : "153", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_48_U", "Parent" : "0"},
	{"ID" : "154", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_49_U", "Parent" : "0"},
	{"ID" : "155", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_50_U", "Parent" : "0"},
	{"ID" : "156", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_51_U", "Parent" : "0"},
	{"ID" : "157", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_52_U", "Parent" : "0"},
	{"ID" : "158", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_53_U", "Parent" : "0"},
	{"ID" : "159", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_54_U", "Parent" : "0"},
	{"ID" : "160", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_55_U", "Parent" : "0"},
	{"ID" : "161", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_56_U", "Parent" : "0"},
	{"ID" : "162", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_57_U", "Parent" : "0"},
	{"ID" : "163", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_58_U", "Parent" : "0"},
	{"ID" : "164", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_59_U", "Parent" : "0"},
	{"ID" : "165", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_60_U", "Parent" : "0"},
	{"ID" : "166", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_61_U", "Parent" : "0"},
	{"ID" : "167", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_62_U", "Parent" : "0"},
	{"ID" : "168", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_63_U", "Parent" : "0"},
	{"ID" : "169", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_64_U", "Parent" : "0"},
	{"ID" : "170", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_65_U", "Parent" : "0"},
	{"ID" : "171", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_66_U", "Parent" : "0"},
	{"ID" : "172", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_67_U", "Parent" : "0"},
	{"ID" : "173", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_68_U", "Parent" : "0"},
	{"ID" : "174", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_69_U", "Parent" : "0"},
	{"ID" : "175", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_70_U", "Parent" : "0"},
	{"ID" : "176", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_71_U", "Parent" : "0"},
	{"ID" : "177", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_72_U", "Parent" : "0"},
	{"ID" : "178", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_73_U", "Parent" : "0"},
	{"ID" : "179", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_74_U", "Parent" : "0"},
	{"ID" : "180", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_75_U", "Parent" : "0"},
	{"ID" : "181", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_76_U", "Parent" : "0"},
	{"ID" : "182", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_77_U", "Parent" : "0"},
	{"ID" : "183", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_78_U", "Parent" : "0"},
	{"ID" : "184", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_79_U", "Parent" : "0"},
	{"ID" : "185", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_80_U", "Parent" : "0"},
	{"ID" : "186", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_81_U", "Parent" : "0"},
	{"ID" : "187", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_82_U", "Parent" : "0"},
	{"ID" : "188", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_83_U", "Parent" : "0"},
	{"ID" : "189", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_84_U", "Parent" : "0"},
	{"ID" : "190", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_85_U", "Parent" : "0"},
	{"ID" : "191", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_86_U", "Parent" : "0"},
	{"ID" : "192", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_87_U", "Parent" : "0"},
	{"ID" : "193", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_88_U", "Parent" : "0"},
	{"ID" : "194", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_89_U", "Parent" : "0"},
	{"ID" : "195", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_90_U", "Parent" : "0"},
	{"ID" : "196", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_91_U", "Parent" : "0"},
	{"ID" : "197", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_92_U", "Parent" : "0"},
	{"ID" : "198", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_93_U", "Parent" : "0"},
	{"ID" : "199", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_94_U", "Parent" : "0"},
	{"ID" : "200", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_95_U", "Parent" : "0"},
	{"ID" : "201", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_96_U", "Parent" : "0"},
	{"ID" : "202", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_97_U", "Parent" : "0"},
	{"ID" : "203", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_98_U", "Parent" : "0"},
	{"ID" : "204", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_99_U", "Parent" : "0"},
	{"ID" : "205", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_100_U", "Parent" : "0"},
	{"ID" : "206", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_101_U", "Parent" : "0"},
	{"ID" : "207", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_102_U", "Parent" : "0"},
	{"ID" : "208", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_103_U", "Parent" : "0"},
	{"ID" : "209", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_104_U", "Parent" : "0"},
	{"ID" : "210", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_105_U", "Parent" : "0"},
	{"ID" : "211", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_106_U", "Parent" : "0"},
	{"ID" : "212", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_107_U", "Parent" : "0"},
	{"ID" : "213", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_108_U", "Parent" : "0"},
	{"ID" : "214", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_109_U", "Parent" : "0"},
	{"ID" : "215", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_110_U", "Parent" : "0"},
	{"ID" : "216", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_111_U", "Parent" : "0"},
	{"ID" : "217", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_112_U", "Parent" : "0"},
	{"ID" : "218", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_113_U", "Parent" : "0"},
	{"ID" : "219", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_114_U", "Parent" : "0"},
	{"ID" : "220", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_115_U", "Parent" : "0"},
	{"ID" : "221", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_116_U", "Parent" : "0"},
	{"ID" : "222", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_117_U", "Parent" : "0"},
	{"ID" : "223", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_118_U", "Parent" : "0"},
	{"ID" : "224", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_119_U", "Parent" : "0"},
	{"ID" : "225", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_120_U", "Parent" : "0"},
	{"ID" : "226", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_121_U", "Parent" : "0"},
	{"ID" : "227", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_122_U", "Parent" : "0"},
	{"ID" : "228", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_123_U", "Parent" : "0"},
	{"ID" : "229", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_124_U", "Parent" : "0"},
	{"ID" : "230", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_125_U", "Parent" : "0"},
	{"ID" : "231", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_126_U", "Parent" : "0"},
	{"ID" : "232", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_output_127_U", "Parent" : "0"},
	{"ID" : "233", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_quantized_U", "Parent" : "0"},
	{"ID" : "234", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_quantized_1_U", "Parent" : "0"},
	{"ID" : "235", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_quantized_2_U", "Parent" : "0"},
	{"ID" : "236", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer1_quantized_3_U", "Parent" : "0"},
	{"ID" : "237", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_U", "Parent" : "0"},
	{"ID" : "238", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_1_U", "Parent" : "0"},
	{"ID" : "239", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_2_U", "Parent" : "0"},
	{"ID" : "240", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_3_U", "Parent" : "0"},
	{"ID" : "241", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_4_U", "Parent" : "0"},
	{"ID" : "242", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_5_U", "Parent" : "0"},
	{"ID" : "243", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_6_U", "Parent" : "0"},
	{"ID" : "244", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_7_U", "Parent" : "0"},
	{"ID" : "245", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_8_U", "Parent" : "0"},
	{"ID" : "246", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_9_U", "Parent" : "0"},
	{"ID" : "247", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_10_U", "Parent" : "0"},
	{"ID" : "248", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_11_U", "Parent" : "0"},
	{"ID" : "249", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_12_U", "Parent" : "0"},
	{"ID" : "250", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_13_U", "Parent" : "0"},
	{"ID" : "251", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_14_U", "Parent" : "0"},
	{"ID" : "252", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_15_U", "Parent" : "0"},
	{"ID" : "253", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_16_U", "Parent" : "0"},
	{"ID" : "254", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_17_U", "Parent" : "0"},
	{"ID" : "255", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_18_U", "Parent" : "0"},
	{"ID" : "256", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_19_U", "Parent" : "0"},
	{"ID" : "257", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_20_U", "Parent" : "0"},
	{"ID" : "258", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_21_U", "Parent" : "0"},
	{"ID" : "259", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_22_U", "Parent" : "0"},
	{"ID" : "260", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_23_U", "Parent" : "0"},
	{"ID" : "261", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_24_U", "Parent" : "0"},
	{"ID" : "262", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_25_U", "Parent" : "0"},
	{"ID" : "263", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_26_U", "Parent" : "0"},
	{"ID" : "264", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_27_U", "Parent" : "0"},
	{"ID" : "265", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_28_U", "Parent" : "0"},
	{"ID" : "266", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_29_U", "Parent" : "0"},
	{"ID" : "267", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_30_U", "Parent" : "0"},
	{"ID" : "268", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_31_U", "Parent" : "0"},
	{"ID" : "269", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_32_U", "Parent" : "0"},
	{"ID" : "270", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_33_U", "Parent" : "0"},
	{"ID" : "271", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_34_U", "Parent" : "0"},
	{"ID" : "272", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_35_U", "Parent" : "0"},
	{"ID" : "273", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_36_U", "Parent" : "0"},
	{"ID" : "274", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_37_U", "Parent" : "0"},
	{"ID" : "275", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_38_U", "Parent" : "0"},
	{"ID" : "276", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_39_U", "Parent" : "0"},
	{"ID" : "277", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_40_U", "Parent" : "0"},
	{"ID" : "278", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_41_U", "Parent" : "0"},
	{"ID" : "279", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_42_U", "Parent" : "0"},
	{"ID" : "280", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_43_U", "Parent" : "0"},
	{"ID" : "281", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_44_U", "Parent" : "0"},
	{"ID" : "282", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_45_U", "Parent" : "0"},
	{"ID" : "283", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_46_U", "Parent" : "0"},
	{"ID" : "284", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_47_U", "Parent" : "0"},
	{"ID" : "285", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_48_U", "Parent" : "0"},
	{"ID" : "286", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_49_U", "Parent" : "0"},
	{"ID" : "287", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_50_U", "Parent" : "0"},
	{"ID" : "288", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_51_U", "Parent" : "0"},
	{"ID" : "289", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_52_U", "Parent" : "0"},
	{"ID" : "290", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_53_U", "Parent" : "0"},
	{"ID" : "291", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_54_U", "Parent" : "0"},
	{"ID" : "292", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_55_U", "Parent" : "0"},
	{"ID" : "293", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_56_U", "Parent" : "0"},
	{"ID" : "294", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_57_U", "Parent" : "0"},
	{"ID" : "295", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_58_U", "Parent" : "0"},
	{"ID" : "296", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_59_U", "Parent" : "0"},
	{"ID" : "297", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_60_U", "Parent" : "0"},
	{"ID" : "298", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_61_U", "Parent" : "0"},
	{"ID" : "299", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_62_U", "Parent" : "0"},
	{"ID" : "300", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_output_63_U", "Parent" : "0"},
	{"ID" : "301", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_quantized_U", "Parent" : "0"},
	{"ID" : "302", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer2_quantized_1_U", "Parent" : "0"},
	{"ID" : "303", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_U", "Parent" : "0"},
	{"ID" : "304", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_1_U", "Parent" : "0"},
	{"ID" : "305", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_2_U", "Parent" : "0"},
	{"ID" : "306", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_3_U", "Parent" : "0"},
	{"ID" : "307", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_4_U", "Parent" : "0"},
	{"ID" : "308", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_5_U", "Parent" : "0"},
	{"ID" : "309", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_6_U", "Parent" : "0"},
	{"ID" : "310", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_7_U", "Parent" : "0"},
	{"ID" : "311", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_8_U", "Parent" : "0"},
	{"ID" : "312", "Level" : "1", "Path" : "`AUTOTB_DUT_INST.layer3_output_9_U", "Parent" : "0"}]}


set ArgLastReadFirstWriteLatency {
	bnn {
		gmem {Type IO LastRead 32 FirstWrite -1}
		IN_r {Type I LastRead 0 FirstWrite -1}
		ys {Type I LastRead 0 FirstWrite -1}
		p_ZL9golden_w1_0 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_1 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_2 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_3 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_4 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_5 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_6 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_7 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_8 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_9 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_10 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_11 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_12 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_13 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_14 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_15 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_16 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_17 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_18 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_19 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_20 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_21 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_22 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_23 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_24 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w2_0 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w2_1 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w2_2 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w2_3 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w3_0 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w3_1 {Type I LastRead -1 FirstWrite -1}}
	entry_proc {
		ys {Type I LastRead 0 FirstWrite -1}
		ys_c {Type O LastRead -1 FirstWrite 0}}
	Block_entry_gmem_rd_proc {
		IN_r {Type I LastRead 0 FirstWrite -1}
		gmem {Type I LastRead 32 FirstWrite -1}}
	dense_layer {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		p_read4 {Type I LastRead 0 FirstWrite -1}
		p_read5 {Type I LastRead 0 FirstWrite -1}
		p_read6 {Type I LastRead 0 FirstWrite -1}
		p_read7 {Type I LastRead 0 FirstWrite -1}
		p_read8 {Type I LastRead 0 FirstWrite -1}
		p_read9 {Type I LastRead 0 FirstWrite -1}
		p_read10 {Type I LastRead 0 FirstWrite -1}
		p_read11 {Type I LastRead 0 FirstWrite -1}
		p_read12 {Type I LastRead 0 FirstWrite -1}
		p_read13 {Type I LastRead 0 FirstWrite -1}
		p_read14 {Type I LastRead 0 FirstWrite -1}
		p_read15 {Type I LastRead 0 FirstWrite -1}
		p_read16 {Type I LastRead 0 FirstWrite -1}
		p_read17 {Type I LastRead 0 FirstWrite -1}
		p_read18 {Type I LastRead 0 FirstWrite -1}
		p_read19 {Type I LastRead 0 FirstWrite -1}
		p_read20 {Type I LastRead 0 FirstWrite -1}
		p_read21 {Type I LastRead 0 FirstWrite -1}
		p_read22 {Type I LastRead 0 FirstWrite -1}
		p_read23 {Type I LastRead 0 FirstWrite -1}
		p_read24 {Type I LastRead 0 FirstWrite -1}
		p_ZL9golden_w1_0 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_1 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_2 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_3 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_4 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_5 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_6 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_7 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_8 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_9 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_10 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_11 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_12 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_13 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_14 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_15 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_16 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_17 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_18 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_19 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_20 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_21 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_22 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_23 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w1_24 {Type I LastRead -1 FirstWrite -1}}
	sign_and_quantize {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		p_read4 {Type I LastRead 0 FirstWrite -1}
		p_read5 {Type I LastRead 0 FirstWrite -1}
		p_read6 {Type I LastRead 0 FirstWrite -1}
		p_read7 {Type I LastRead 0 FirstWrite -1}
		p_read8 {Type I LastRead 0 FirstWrite -1}
		p_read9 {Type I LastRead 0 FirstWrite -1}
		p_read10 {Type I LastRead 0 FirstWrite -1}
		p_read11 {Type I LastRead 0 FirstWrite -1}
		p_read12 {Type I LastRead 0 FirstWrite -1}
		p_read13 {Type I LastRead 0 FirstWrite -1}
		p_read14 {Type I LastRead 0 FirstWrite -1}
		p_read15 {Type I LastRead 0 FirstWrite -1}
		p_read16 {Type I LastRead 0 FirstWrite -1}
		p_read17 {Type I LastRead 0 FirstWrite -1}
		p_read18 {Type I LastRead 0 FirstWrite -1}
		p_read19 {Type I LastRead 0 FirstWrite -1}
		p_read20 {Type I LastRead 0 FirstWrite -1}
		p_read21 {Type I LastRead 0 FirstWrite -1}
		p_read22 {Type I LastRead 0 FirstWrite -1}
		p_read23 {Type I LastRead 0 FirstWrite -1}
		p_read24 {Type I LastRead 0 FirstWrite -1}
		p_read25 {Type I LastRead 0 FirstWrite -1}
		p_read26 {Type I LastRead 0 FirstWrite -1}
		p_read27 {Type I LastRead 0 FirstWrite -1}
		p_read28 {Type I LastRead 0 FirstWrite -1}
		p_read29 {Type I LastRead 0 FirstWrite -1}
		p_read30 {Type I LastRead 0 FirstWrite -1}
		p_read31 {Type I LastRead 0 FirstWrite -1}
		p_read32 {Type I LastRead 0 FirstWrite -1}
		p_read33 {Type I LastRead 0 FirstWrite -1}
		p_read34 {Type I LastRead 0 FirstWrite -1}
		p_read35 {Type I LastRead 0 FirstWrite -1}
		p_read36 {Type I LastRead 0 FirstWrite -1}
		p_read37 {Type I LastRead 0 FirstWrite -1}
		p_read38 {Type I LastRead 0 FirstWrite -1}
		p_read39 {Type I LastRead 0 FirstWrite -1}
		p_read40 {Type I LastRead 0 FirstWrite -1}
		p_read41 {Type I LastRead 0 FirstWrite -1}
		p_read42 {Type I LastRead 0 FirstWrite -1}
		p_read43 {Type I LastRead 0 FirstWrite -1}
		p_read44 {Type I LastRead 0 FirstWrite -1}
		p_read45 {Type I LastRead 0 FirstWrite -1}
		p_read46 {Type I LastRead 0 FirstWrite -1}
		p_read47 {Type I LastRead 0 FirstWrite -1}
		p_read48 {Type I LastRead 0 FirstWrite -1}
		p_read49 {Type I LastRead 0 FirstWrite -1}
		p_read50 {Type I LastRead 0 FirstWrite -1}
		p_read51 {Type I LastRead 0 FirstWrite -1}
		p_read52 {Type I LastRead 0 FirstWrite -1}
		p_read53 {Type I LastRead 0 FirstWrite -1}
		p_read54 {Type I LastRead 0 FirstWrite -1}
		p_read55 {Type I LastRead 0 FirstWrite -1}
		p_read56 {Type I LastRead 0 FirstWrite -1}
		p_read57 {Type I LastRead 0 FirstWrite -1}
		p_read58 {Type I LastRead 0 FirstWrite -1}
		p_read59 {Type I LastRead 0 FirstWrite -1}
		p_read60 {Type I LastRead 0 FirstWrite -1}
		p_read61 {Type I LastRead 0 FirstWrite -1}
		p_read62 {Type I LastRead 0 FirstWrite -1}
		p_read63 {Type I LastRead 0 FirstWrite -1}
		p_read64 {Type I LastRead 0 FirstWrite -1}
		p_read65 {Type I LastRead 0 FirstWrite -1}
		p_read66 {Type I LastRead 0 FirstWrite -1}
		p_read67 {Type I LastRead 0 FirstWrite -1}
		p_read68 {Type I LastRead 0 FirstWrite -1}
		p_read69 {Type I LastRead 0 FirstWrite -1}
		p_read70 {Type I LastRead 0 FirstWrite -1}
		p_read71 {Type I LastRead 0 FirstWrite -1}
		p_read72 {Type I LastRead 0 FirstWrite -1}
		p_read73 {Type I LastRead 0 FirstWrite -1}
		p_read74 {Type I LastRead 0 FirstWrite -1}
		p_read75 {Type I LastRead 0 FirstWrite -1}
		p_read76 {Type I LastRead 0 FirstWrite -1}
		p_read77 {Type I LastRead 0 FirstWrite -1}
		p_read78 {Type I LastRead 0 FirstWrite -1}
		p_read79 {Type I LastRead 0 FirstWrite -1}
		p_read80 {Type I LastRead 0 FirstWrite -1}
		p_read81 {Type I LastRead 0 FirstWrite -1}
		p_read82 {Type I LastRead 0 FirstWrite -1}
		p_read83 {Type I LastRead 0 FirstWrite -1}
		p_read84 {Type I LastRead 0 FirstWrite -1}
		p_read85 {Type I LastRead 0 FirstWrite -1}
		p_read86 {Type I LastRead 0 FirstWrite -1}
		p_read87 {Type I LastRead 0 FirstWrite -1}
		p_read88 {Type I LastRead 0 FirstWrite -1}
		p_read89 {Type I LastRead 0 FirstWrite -1}
		p_read90 {Type I LastRead 0 FirstWrite -1}
		p_read91 {Type I LastRead 0 FirstWrite -1}
		p_read92 {Type I LastRead 0 FirstWrite -1}
		p_read93 {Type I LastRead 0 FirstWrite -1}
		p_read94 {Type I LastRead 0 FirstWrite -1}
		p_read95 {Type I LastRead 0 FirstWrite -1}
		p_read96 {Type I LastRead 0 FirstWrite -1}
		p_read97 {Type I LastRead 0 FirstWrite -1}
		p_read98 {Type I LastRead 0 FirstWrite -1}
		p_read99 {Type I LastRead 0 FirstWrite -1}
		p_read100 {Type I LastRead 0 FirstWrite -1}
		p_read101 {Type I LastRead 0 FirstWrite -1}
		p_read102 {Type I LastRead 0 FirstWrite -1}
		p_read103 {Type I LastRead 0 FirstWrite -1}
		p_read104 {Type I LastRead 0 FirstWrite -1}
		p_read105 {Type I LastRead 0 FirstWrite -1}
		p_read106 {Type I LastRead 0 FirstWrite -1}
		p_read107 {Type I LastRead 0 FirstWrite -1}
		p_read108 {Type I LastRead 0 FirstWrite -1}
		p_read109 {Type I LastRead 0 FirstWrite -1}
		p_read110 {Type I LastRead 0 FirstWrite -1}
		p_read111 {Type I LastRead 0 FirstWrite -1}
		p_read112 {Type I LastRead 0 FirstWrite -1}
		p_read113 {Type I LastRead 0 FirstWrite -1}
		p_read114 {Type I LastRead 0 FirstWrite -1}
		p_read115 {Type I LastRead 0 FirstWrite -1}
		p_read116 {Type I LastRead 0 FirstWrite -1}
		p_read117 {Type I LastRead 0 FirstWrite -1}
		p_read118 {Type I LastRead 0 FirstWrite -1}
		p_read119 {Type I LastRead 0 FirstWrite -1}
		p_read120 {Type I LastRead 0 FirstWrite -1}
		p_read121 {Type I LastRead 0 FirstWrite -1}
		p_read122 {Type I LastRead 0 FirstWrite -1}
		p_read123 {Type I LastRead 0 FirstWrite -1}
		p_read124 {Type I LastRead 0 FirstWrite -1}
		p_read125 {Type I LastRead 0 FirstWrite -1}
		p_read126 {Type I LastRead 0 FirstWrite -1}
		p_read127 {Type I LastRead 0 FirstWrite -1}}
	dense_layer_1 {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		p_ZL9golden_w2_0 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w2_1 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w2_2 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w2_3 {Type I LastRead -1 FirstWrite -1}}
	sign_and_quantize_2 {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_read2 {Type I LastRead 0 FirstWrite -1}
		p_read3 {Type I LastRead 0 FirstWrite -1}
		p_read4 {Type I LastRead 0 FirstWrite -1}
		p_read5 {Type I LastRead 0 FirstWrite -1}
		p_read6 {Type I LastRead 0 FirstWrite -1}
		p_read7 {Type I LastRead 0 FirstWrite -1}
		p_read8 {Type I LastRead 0 FirstWrite -1}
		p_read9 {Type I LastRead 0 FirstWrite -1}
		p_read10 {Type I LastRead 0 FirstWrite -1}
		p_read11 {Type I LastRead 0 FirstWrite -1}
		p_read12 {Type I LastRead 0 FirstWrite -1}
		p_read13 {Type I LastRead 0 FirstWrite -1}
		p_read14 {Type I LastRead 0 FirstWrite -1}
		p_read15 {Type I LastRead 0 FirstWrite -1}
		p_read16 {Type I LastRead 0 FirstWrite -1}
		p_read17 {Type I LastRead 0 FirstWrite -1}
		p_read18 {Type I LastRead 0 FirstWrite -1}
		p_read19 {Type I LastRead 0 FirstWrite -1}
		p_read20 {Type I LastRead 0 FirstWrite -1}
		p_read21 {Type I LastRead 0 FirstWrite -1}
		p_read22 {Type I LastRead 0 FirstWrite -1}
		p_read23 {Type I LastRead 0 FirstWrite -1}
		p_read24 {Type I LastRead 0 FirstWrite -1}
		p_read25 {Type I LastRead 0 FirstWrite -1}
		p_read26 {Type I LastRead 0 FirstWrite -1}
		p_read27 {Type I LastRead 0 FirstWrite -1}
		p_read28 {Type I LastRead 0 FirstWrite -1}
		p_read29 {Type I LastRead 0 FirstWrite -1}
		p_read30 {Type I LastRead 0 FirstWrite -1}
		p_read31 {Type I LastRead 0 FirstWrite -1}
		p_read32 {Type I LastRead 0 FirstWrite -1}
		p_read33 {Type I LastRead 0 FirstWrite -1}
		p_read34 {Type I LastRead 0 FirstWrite -1}
		p_read35 {Type I LastRead 0 FirstWrite -1}
		p_read36 {Type I LastRead 0 FirstWrite -1}
		p_read37 {Type I LastRead 0 FirstWrite -1}
		p_read38 {Type I LastRead 0 FirstWrite -1}
		p_read39 {Type I LastRead 0 FirstWrite -1}
		p_read40 {Type I LastRead 0 FirstWrite -1}
		p_read41 {Type I LastRead 0 FirstWrite -1}
		p_read42 {Type I LastRead 0 FirstWrite -1}
		p_read43 {Type I LastRead 0 FirstWrite -1}
		p_read44 {Type I LastRead 0 FirstWrite -1}
		p_read45 {Type I LastRead 0 FirstWrite -1}
		p_read46 {Type I LastRead 0 FirstWrite -1}
		p_read47 {Type I LastRead 0 FirstWrite -1}
		p_read48 {Type I LastRead 0 FirstWrite -1}
		p_read49 {Type I LastRead 0 FirstWrite -1}
		p_read50 {Type I LastRead 0 FirstWrite -1}
		p_read51 {Type I LastRead 0 FirstWrite -1}
		p_read52 {Type I LastRead 0 FirstWrite -1}
		p_read53 {Type I LastRead 0 FirstWrite -1}
		p_read54 {Type I LastRead 0 FirstWrite -1}
		p_read55 {Type I LastRead 0 FirstWrite -1}
		p_read56 {Type I LastRead 0 FirstWrite -1}
		p_read57 {Type I LastRead 0 FirstWrite -1}
		p_read58 {Type I LastRead 0 FirstWrite -1}
		p_read59 {Type I LastRead 0 FirstWrite -1}
		p_read60 {Type I LastRead 0 FirstWrite -1}
		p_read61 {Type I LastRead 0 FirstWrite -1}
		p_read62 {Type I LastRead 0 FirstWrite -1}
		p_read63 {Type I LastRead 0 FirstWrite -1}}
	dense_layer_3 {
		p_read {Type I LastRead 0 FirstWrite -1}
		p_read1 {Type I LastRead 0 FirstWrite -1}
		p_ZL9golden_w3_0 {Type I LastRead -1 FirstWrite -1}
		p_ZL9golden_w3_1 {Type I LastRead -1 FirstWrite -1}}
	Block_entry_gmem_wr_proc {
		ys {Type I LastRead 0 FirstWrite -1}
		gmem {Type O LastRead 12 FirstWrite 2}
		p_read {Type I LastRead 1 FirstWrite -1}
		p_read1 {Type I LastRead 2 FirstWrite -1}
		p_read2 {Type I LastRead 3 FirstWrite -1}
		p_read3 {Type I LastRead 4 FirstWrite -1}
		p_read4 {Type I LastRead 5 FirstWrite -1}
		p_read5 {Type I LastRead 6 FirstWrite -1}
		p_read6 {Type I LastRead 7 FirstWrite -1}
		p_read7 {Type I LastRead 8 FirstWrite -1}
		p_read8 {Type I LastRead 9 FirstWrite -1}
		p_read9 {Type I LastRead 10 FirstWrite -1}}}

set hasDtUnsupportedChannel 0

set PerformanceInfo {[
	{"Name" : "Latency", "Min" : "188", "Max" : "188"}
	, {"Name" : "Interval", "Min" : "64", "Max" : "64"}
]}

set PipelineEnableSignalInfo {[
]}

set Spec2ImplPortList { 
	gmem { m_axi {  { m_axi_gmem_AWVALID VALID 1 1 }  { m_axi_gmem_AWREADY READY 0 1 }  { m_axi_gmem_AWADDR ADDR 1 64 }  { m_axi_gmem_AWID ID 1 1 }  { m_axi_gmem_AWLEN SIZE 1 8 }  { m_axi_gmem_AWSIZE BURST 1 3 }  { m_axi_gmem_AWBURST LOCK 1 2 }  { m_axi_gmem_AWLOCK CACHE 1 2 }  { m_axi_gmem_AWCACHE PROT 1 4 }  { m_axi_gmem_AWPROT QOS 1 3 }  { m_axi_gmem_AWQOS REGION 1 4 }  { m_axi_gmem_AWREGION USER 1 4 }  { m_axi_gmem_AWUSER DATA 1 1 }  { m_axi_gmem_WVALID VALID 1 1 }  { m_axi_gmem_WREADY READY 0 1 }  { m_axi_gmem_WDATA FIFONUM 1 32 }  { m_axi_gmem_WSTRB STRB 1 4 }  { m_axi_gmem_WLAST LAST 1 1 }  { m_axi_gmem_WID ID 1 1 }  { m_axi_gmem_WUSER DATA 1 1 }  { m_axi_gmem_ARVALID VALID 1 1 }  { m_axi_gmem_ARREADY READY 0 1 }  { m_axi_gmem_ARADDR ADDR 1 64 }  { m_axi_gmem_ARID ID 1 1 }  { m_axi_gmem_ARLEN SIZE 1 8 }  { m_axi_gmem_ARSIZE BURST 1 3 }  { m_axi_gmem_ARBURST LOCK 1 2 }  { m_axi_gmem_ARLOCK CACHE 1 2 }  { m_axi_gmem_ARCACHE PROT 1 4 }  { m_axi_gmem_ARPROT QOS 1 3 }  { m_axi_gmem_ARQOS REGION 1 4 }  { m_axi_gmem_ARREGION USER 1 4 }  { m_axi_gmem_ARUSER DATA 1 1 }  { m_axi_gmem_RVALID VALID 0 1 }  { m_axi_gmem_RREADY READY 1 1 }  { m_axi_gmem_RDATA FIFONUM 0 32 }  { m_axi_gmem_RLAST LAST 0 1 }  { m_axi_gmem_RID ID 0 1 }  { m_axi_gmem_RUSER DATA 0 1 }  { m_axi_gmem_RRESP RESP 0 2 }  { m_axi_gmem_BVALID VALID 0 1 }  { m_axi_gmem_BREADY READY 1 1 }  { m_axi_gmem_BRESP RESP 0 2 }  { m_axi_gmem_BID ID 0 1 }  { m_axi_gmem_BUSER DATA 0 1 } } }
}

set maxi_interface_dict [dict create]
dict set maxi_interface_dict gmem { CHANNEL_NUM 0 BUNDLE gmem NUM_READ_OUTSTANDING 16 NUM_WRITE_OUTSTANDING 16 MAX_READ_BURST_LENGTH 32 MAX_WRITE_BURST_LENGTH 16 READ_WRITE_MODE READ_WRITE}

# RTL port scheduling information:
set fifoSchedulingInfoList { 
}

# RTL bus port read request latency information:
set busReadReqLatencyList { 
	{ gmem 1 }
}

# RTL bus port write response latency information:
set busWriteResLatencyList { 
	{ gmem 1 }
}

# RTL array port load latency information:
set memoryLoadLatencyList { 
}
