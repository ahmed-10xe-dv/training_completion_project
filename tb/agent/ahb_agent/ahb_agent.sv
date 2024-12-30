/*************************************************************************
   > File Name:   ahb_agent.sv
   > Description: This file defines the `ahb_agent` class, which encapsulates 
                  the AHB sequencer, driver, and monitor for AXI verification.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AHB_AGENT
`define AHB_AGENT

class ahb_agent extends uvm_agent;

  `uvm_component_utils(ahb_agent)

  // Components
  ahb_sequencer ahb_sqr;
  ahb_driver    ahb_drv;
  ahb_monitor   ahb_mon;

  // Constructor
  function new(string name = "ahb_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //-----------------------------------------------------------------------------
  // Build Phase
  //-----------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ahb_drv = ahb_driver::type_id::create("ahb_drv", this);
    ahb_sqr = ahb_sequencer::type_id::create("ahb_sqr", this);
    ahb_mon = ahb_monitor::type_id::create("ahb_mon", this);
    `uvm_info(get_full_name(), "Build Phase completed for AHB Agent", UVM_LOW)
  endfunction : build_phase

  //-----------------------------------------------------------------------------
  // Connect Phase
  //-----------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    ahb_drv.seq_item_port.connect(ahb_sqr.seq_item_export);
    `uvm_info(get_full_name(), "Connect Phase completed for AHB Agent", UVM_LOW)
  endfunction : connect_phase

endclass : ahb_agent

`endif
