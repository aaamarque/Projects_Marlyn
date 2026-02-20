set ModuleHierarchy {[{
"Name" : "bnn","ID" : "0","Type" : "dataflow",
"SubInsts" : [
	{"Name" : "entry_proc_U0","ID" : "1","Type" : "sequential"},
	{"Name" : "Block_entry_gmem_rd_proc_U0","ID" : "2","Type" : "sequential"},
	{"Name" : "dense_layer_U0","ID" : "3","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_34_1","ID" : "4","Type" : "pipeline"},]},
	{"Name" : "sign_and_quantize_U0","ID" : "5","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_71_1","ID" : "6","Type" : "pipeline"},]},
	{"Name" : "dense_layer_1_U0","ID" : "7","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_34_1","ID" : "8","Type" : "pipeline"},]},
	{"Name" : "sign_and_quantize_2_U0","ID" : "9","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_71_1","ID" : "10","Type" : "pipeline"},]},
	{"Name" : "dense_layer_3_U0","ID" : "11","Type" : "sequential",
		"SubLoops" : [
		{"Name" : "VITIS_LOOP_34_1","ID" : "12","Type" : "pipeline"},]},
	{"Name" : "Block_entry_gmem_wr_proc_U0","ID" : "13","Type" : "sequential"},]
}]}