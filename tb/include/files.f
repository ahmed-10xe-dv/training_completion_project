
// This file includes all the files being used in the project
//Author: Ahmed Raza

// UVM Macros and Package
`include "uvm_macros.svh"
import uvm_pkg::*;

// Bus Parameters and Memory Model
`include "bus_params_pkg.sv"
`include "mem_model_pkg.sv"
import mem_model_pkg::*;
`include "dv_macros.svh"
`include "mem_model.sv"
`include "configurations.sv"


// Interfaces and Defines
`include "axi_interface.sv"
`include "ahb_interface.sv"

// Sequences and Sequence Items
`include "../sim/axi_seq_item.sv"
`include "../sim/axi_sequence.sv"
`include "../sim/axi_sequence_lib.sv"
`include "../sim/ahb_seq_item.sv"
`include "../sim/ahb_sequence.sv"

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

// Multi-Sequence
`include "../Vsequencer/multi_sequencer.sv"
`include "../Vsequencer/multi_seq.sv"

// AXI to AHB Environment and Test
`include "../env/axi2ahb_scoreboard.sv"
`include "../env/axi_environment.sv"
`include "../env/ahb_environment.sv"
`include "../env/axi2ahb_env.sv"
`include "../test_top/test.sv"
`include "../test_top/test_lib.sv"

