# Makefile for BNN project
# Tested with Vitis HLS 2024.2

TOP = bnn

# Use vitis_hls directly
HLS_COMPILER = vitis_hls

# Source files
TCL_SCRIPT = script.tcl

# Default target
all: csim

# Run C simulation
# ... (Top of Makefile remains the same)

# Run C simulation
csim:
	@echo "Running C simulation..."
	@echo "open_project $(TOP)" > run_csim.tcl
	@echo "add_files bnn.cpp" >> run_csim.tcl             # <--- ADD THIS
	@echo "add_files -tb bnn_test.cpp" >> run_csim.tcl    # <--- ADD THIS
	@echo "open_solution solution1" >> run_csim.tcl
	@echo "set_top $(TOP)" >> run_csim.tcl                # <--- GOOD PRACTICE
	@echo "csim_design" >> run_csim.tcl
	@echo "exit" >> run_csim.tcl
	@$(HLS_COMPILER) -f run_csim.tcl
	@rm -f run_csim.tcl

# Synthesize
csynth:
	@echo "Running synthesis..."
	@echo "open_project $(TOP)" > run_csynth.tcl
	@echo "add_files bnn.cpp" >> run_csynth.tcl
	@echo "open_solution solution1" >> run_csynth.tcl
	@echo "set_top $(TOP)" >> run_csynth.tcl
	@echo "set_part {xc7z020clg400-1}" >> run_csynth.tcl
	@echo "create_clock -period 10 -name default" >> run_csynth.tcl
	@echo "csynth_design" >> run_csynth.tcl
	@echo "exit" >> run_csynth.tcl
	@$(HLS_COMPILER) -f run_csynth.tcl
	@rm -f run_csynth.tcl

# Co-simulation
cosim:
	@echo "Running co-simulation..."
	@echo "open_project $(TOP)" > run_cosim.tcl
	@echo "add_files bnn.cpp" >> run_cosim.tcl
	@echo "add_files -tb bnn_test.cpp" >> run_cosim.tcl
	@echo "open_solution solution1" >> run_cosim.tcl
	@echo "set_top $(TOP)" >> run_cosim.tcl
	@echo "cosim_design" >> run_cosim.tcl
	@echo "exit" >> run_cosim.tcl
	@$(HLS_COMPILER) -f run_cosim.tcl
	@rm -f run_cosim.tcl

# ... (Rest of Makefile remains the same)

# Run full HLS flow
hls:
	@echo "Running HLS..."
	@$(HLS_COMPILER) -f $(TCL_SCRIPT)

# Generate synthesis report
report:
	@echo "Copying synthesis report..."
	@if [ -f $(TOP)/solution1/syn/report/$(TOP)_csynth.rpt ]; then \
		cp $(TOP)/solution1/syn/report/$(TOP)_csynth.rpt .; \
		echo "Report copied to $(TOP)_csynth.rpt"; \
		head -100 $(TOP)_csynth.rpt; \
	else \
		echo "Error: Synthesis report not found. Run 'make csynth' first."; \
	fi

# Export IP
export:
	@echo "Exporting IP..."
	@echo "open_project $(TOP)" > run_export.tcl
	@echo "open_solution solution1" >> run_export.tcl
	@echo "export_design -format ip_catalog -rtl verilog" >> run_export.tcl
	@echo "exit" >> run_export.tcl
	@$(HLS_COMPILER) -f run_export.tcl
	@rm -f run_export.tcl

# Clean
clean:
	@echo "Cleaning build files..."
	@rm -rf *.log *.jou run_*.tcl *.rpt .Xil

# Deep clean
distclean: clean
	@echo "Deep cleaning..."
	@rm -rf $(TOP)

.PHONY: all csim csynth cosim hls export report clean distclean