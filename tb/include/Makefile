# # Makefile for UVM-based verification of AXI to AHB bridge
# # Author: Ahmed Raza
# # Date: 15 January 2025

# # Variables
# VLOG_CMD = xvlog --incr --relax -L uvm -prj tb_top_vlog.prj
# VHDL_CMD = xvhdl --incr --relax -prj tb_top_vhdl.prj
# ELAB_CMD = xelab --incr --debug typical --relax --mt 8 -L xil_defaultlib \
#           -L axi_ahblite_bridge_v3_0_23 -L uvm -L unisims_ver -L unimacro_ver \
#           -L secureip -L xpm --snapshot tb_top_behav xil_defaultlib.tb_top \
#           xil_defaultlib.glbl -log elaborate.log
# SIM_CMD = xsim tb_top_behav -key {Behavioral:sim_1:Functional:tb_top} \
#           -runall -R -log simulate.log
# COV_CMD = xcrg -report_format html -dir

# TESTLIST_FILE = testlist.txt
# COV_DIR = write_tests
# TESTNAME = incr_wr_len256_test
# COV_NAME = incr_wr_len256_test

# # Targets
# all: compile elaborate simulate

# compile:
# 	@echo "Compiling Verilog and VHDL sources..."
# 	@echo $(VLOG_CMD)
# 	@$(VLOG_CMD) 2>&1 | tee compile.log
# 	@echo $(VHDL_CMD)
# 	@$(VHDL_CMD) 2>&1 | tee -a compile.log
# 	@echo "Compilation completed."

# elaborate:
# 	@echo "Elaborating design..."
# 	@echo $(ELAB_CMD)
# 	@$(ELAB_CMD)
# 	@echo "Elaboration completed."

# simulate:
# 	@echo "Simulating design..."
# 	@echo $(SIM_CMD) --cov_db_dir $(COV_DIR) --cov_db_name $(COV_NAME) \
# 	      --testplusarg UVM_TESTNAME=$(TESTNAME)
# 	@$(SIM_CMD) --cov_db_dir $(COV_DIR) --cov_db_name $(COV_NAME) \
# 	      --testplusarg UVM_TESTNAME=$(TESTNAME)
# 	@echo "Simulation completed."

# run_test:
# 	@echo "Running test: $(TESTNAME)"
# 	@$(MAKE) simulate TESTNAME=$(TESTNAME) \
# 	    COV_DIR=$(shell echo $(TESTNAME) | grep -q 'rd' && echo read_tests || \
# 	               echo $(TESTNAME) | grep -q 'wr_rd' && echo read_write_tests || \
# 	               echo write_tests) \
# 	    COV_NAME=$(TESTNAME)
# 	@echo "Test $(TESTNAME) completed."

# run_all:
# 	@echo "Running all tests in $(TESTLIST_FILE)..."
# 	@while read -r TEST; do \
# 	    $(MAKE) simulate TESTNAME=$$TEST \
# 	        COV_DIR=$$(echo $$TEST | grep -q 'rd' && echo read_tests || \
# 	                   echo $$TEST | grep -q 'wr_rd' && echo read_write_tests || \
# 	                   echo write_tests) \
# 	        COV_NAME=$$TEST; \
# 	done < $(TESTLIST_FILE)
# 	@echo "All tests completed."

# coverage:
# 	@echo "Generating coverage report..."
# 	@echo $(COV_CMD) ./$(COV_DIR)
# 	@$(COV_CMD) ./$(COV_DIR)
# 	@echo "Coverage report generated."

# clean:
# 	@echo "Cleaning generated files..."
# 	@rm -rf compile.log elaborate.log simulate.log *.jou *.pb xsim.dir
# 	@echo "Cleanup completed."

# .PHONY: all compile elaborate simulate run_test run_all coverage clean
