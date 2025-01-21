# UVM Based Verification of AXI to AHB Bridge
# Author: Ahmed Raza
# Date: 15 Jan 2025

# Variables
VLOG_PRJ = /home/ahmed/Ahmed\ Raza/project_2/project_2.sim/sim_1/behav/xsim/tb_top_vlog.prj
VHDL_PRJ = /home/ahmed/Ahmed\ Raza/project_2/project_2.sim/sim_1/behav/xsim/tb_top_vhdl.prj
SIMULATOR = xsim
ELAB = xelab
XVLOG = xvlog
XVHDL = xvhdl
XCRG = xcrg
TOP_SNAPSHOT = tb_top_behav
UVM_LIBS = -L uvm
SIM_LOG = simulate.log
COV_DIR = write_tests
COV_NAME = incr_wr_len256_test
COV_REPORT_DIR = ./write_tests

RESULTS_DIR = simulation_results

default: compile elaborate

# Create the results directory if it doesn't exist
prepare_dirs:
	@mkdir -p $(RESULTS_DIR)

# Compilation step
compile: prepare_dirs
	echo "$(XVLOG) --incr --relax $(UVM_LIBS) -prj $(VLOG_PRJ)"
	$(XVLOG) --incr --relax $(UVM_LIBS) -prj $(VLOG_PRJ) 2>&1 | tee $(RESULTS_DIR)/compile.log
	echo "$(XVHDL) --incr --relax -prj $(VHDL_PRJ)"
	$(XVHDL) --incr --relax -prj $(VHDL_PRJ) 2>&1 | tee -a $(RESULTS_DIR)/compile.log

# Elaboration step
elaborate: prepare_dirs
	echo "$(ELAB) --incr --debug typical --relax --mt 8 -L xil_defaultlib -L axi_ahblite_bridge_v3_0_23 $(UVM_LIBS) -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot $(TOP_SNAPSHOT) xil_defaultlib.tb_top xil_defaultlib.glbl -log elaborate.log"
	$(ELAB) --incr --debug typical --relax --mt 8 -L xil_defaultlib -L axi_ahblite_bridge_v3_0_23 $(UVM_LIBS) -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot $(TOP_SNAPSHOT) xil_defaultlib.tb_top xil_defaultlib.glbl -log $(RESULTS_DIR)/elaborate.log

# Simulation step for a single test
simulate_single: prepare_dirs
	@test -n "$(TEST)" || (echo "Please specify a TEST name with TEST=<test_name>" && exit 1)
	@TEST_DIR=$(RESULTS_DIR)/$(TEST); \
	mkdir -p $$TEST_DIR; \
	echo "Running test: $(TEST)"; \
	echo "$(SIMULATOR) $(TOP_SNAPSHOT) -key {Behavioral:sim_1:Functional:tb_top} -runall -R -view /home/ahmed/Ahmed Raza/project_2/tb_top_behav.wcfg -log $$TEST_DIR/$(SIM_LOG) --cov_db_dir $$TEST_DIR --cov_db_name $(TEST) --testplusarg UVM_TESTNAME=$(TEST)"; \
	$(SIMULATOR) $(TOP_SNAPSHOT) -key {Behavioral:sim_1:Functional:tb_top} -runall -R -view "/home/ahmed/Ahmed Raza/project_2/tb_top_behav.wcfg" -log $$TEST_DIR/$(SIM_LOG) --cov_db_dir $$TEST_DIR --cov_db_name $(TEST) --testplusarg UVM_TESTNAME=$(TEST)

# Simulation step for all tests in a list
simulate_all: prepare_dirs
	@test -n "$(TEST_LIST)" || (echo "Please specify a TEST_LIST file with TEST_LIST=<file_name>" && exit 1)
	@while IFS= read -r TEST; do \
		TEST_DIR=$(RESULTS_DIR)/$$TEST; \
		mkdir -p $$TEST_DIR; \
		echo "Running test: $$TEST"; \
		echo "$(SIMULATOR) $(TOP_SNAPSHOT) -key {Behavioral:sim_1:Functional:tb_top} -runall -R -view /home/ahmed/Ahmed Raza/project_2/tb_top_behav.wcfg -log $$TEST_DIR/$(SIM_LOG) --cov_db_dir $$TEST_DIR --cov_db_name $$TEST --testplusarg UVM_TESTNAME=$$TEST"; \
		$(SIMULATOR) $(TOP_SNAPSHOT) -key {Behavioral:sim_1:Functional:tb_top} -runall -R -view "/home/ahmed/Ahmed Raza/project_2/tb_top_behav.wcfg" -log $$TEST_DIR/$(SIM_LOG) --cov_db_dir $$TEST_DIR --cov_db_name $$TEST --testplusarg UVM_TESTNAME=$$TEST; \
	done < $(TEST_LIST)

# Coverage report generation
coverage_report: prepare_dirs
	@test -n "$(COV_REPORT_DIR)" || (echo "Please specify a COV_REPORT_DIR with COV_REPORT_DIR=<dir_name>" && exit 1)
	echo "$(XCRG) -report_format html -dir ./$(COV_REPORT_DIR)"
	$(XCRG) -report_format html -dir ./$(COV_REPORT_DIR)

# Clean logs and other generated files
clean:
	@echo "Cleaning up..."
	rm -rf ./xsim.dir ./webtalk*.jou *.log *.pb *.wdb *.jou
	@echo "Cleanup completed."

.PHONY: all compile elaborate simulate run_test run_all coverage clean
