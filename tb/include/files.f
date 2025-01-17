
// This file includes all the files being used in the project
//Author: Ahmed Raza

// UVM Macros and Package
`include "uvm_macros.svh"
import uvm_pkg::*;

// Bus Parameters and Memory Model
`include "bus_params_pkg.sv"
`include "dv_macros.svh"
`include "configurations.sv"


// Interfaces and Defines
`include "axi_interface.sv"
`include "ahb_interface.sv"

// Sequences and Sequence Items
`include "../sim/seq_item/axi_seq_item.sv"
`include "../sim/seq_item/ahb_seq_item.sv"
`include "../sim/base_sequence/ahb_sequence.sv"
`include "../sim/base_sequence/axi_wr_addr_sequence.sv"
`include "../sim/base_sequence/axi_rd_addr_sequence.sv"
`include "../sim/base_sequence/axi_wr_data_sequence.sv"
`include "../sim/base_sequence/axi_rd_data_sequence.sv"
`include "../sim/base_sequence/axi_wr_rsp_sequence.sv"
`include "../sim/sequence_lib/axi_wr_addr_sequence_lib.sv"
`include "../sim/sequence_lib/axi_rd_addr_sequence_lib.sv"


// Write Address Agent
`include "../agent/axi_agent/wr_addr_agent/wr_addr_sequencer.sv"
`include "../agent/axi_agent/wr_addr_agent/wr_addr_driver.sv"
`include "../agent/axi_agent/wr_addr_agent/wr_addr_monitor.sv"
`include "../agent/axi_agent/wr_addr_agent/wr_addr_agent.sv"

// Read Address Agent
`include "../agent/axi_agent/rd_addr_agent/rd_addr_sequencer.sv"
`include "../agent/axi_agent/rd_addr_agent/rd_addr_driver.sv"
`include "../agent/axi_agent/rd_addr_agent/rd_addr_monitor.sv"
`include "../agent/axi_agent/rd_addr_agent/rd_addr_agent.sv"

// Write Data Agent
`include "../agent/axi_agent/wr_data_agent/wr_data_sequencer.sv"
`include "../agent/axi_agent/wr_data_agent/wr_data_driver.sv"
`include "../agent/axi_agent/wr_data_agent/wr_data_monitor.sv"
`include "../agent/axi_agent/wr_data_agent/wr_data_agent.sv"

// Read Data Agent
`include "../agent/axi_agent/rd_data_agent/rd_data_sequencer.sv"
`include "../agent/axi_agent/rd_data_agent/rd_data_driver.sv"
`include "../agent/axi_agent/rd_data_agent/rd_data_monitor.sv"
`include "../agent/axi_agent/rd_data_agent/rd_data_agent.sv"

// Write Response Agent
`include "../agent/axi_agent/wr_rsp_agent/wr_rsp_sequencer.sv"
`include "../agent/axi_agent/wr_rsp_agent/wr_rsp_driver.sv"
`include "../agent/axi_agent/wr_rsp_agent/wr_rsp_monitor.sv"
`include "../agent/axi_agent/wr_rsp_agent/wr_rsp_agent.sv"

// AHB Agent
`include "../agent/ahb_agent/ahb_sequencer.sv"
`include "../agent/ahb_agent/ahb_driver.sv"
`include "../agent/ahb_agent/ahb_monitor.sv"
`include "../agent/ahb_agent/ahb_agent.sv"

// AXI to AHB Environment and Test
`include "../env/axi2ahb_scoreboard.sv"
`include "../env/func_coverage.sv"
`include "../env/axi_environment.sv"
`include "../env/ahb_environment.sv"
`include "../env/axi2ahb_env.sv"
`include "../test_top/test.sv"
`include "../test_top/test_lib.sv"