/*************************************************************************
   > File Name:   ahb_seq_item.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_AGENT
`define AXI_AGENT

class axi_agent extends uvm_agent;
    `uvm_component_utils(axi_agent)
    axi_driver axi_dri;
    axi_sequencer axi_sqr;
    axi_monitor axi_mon;
  
    function new(string name = "axi_agent", uvm_component parent = null);
      super.new(name, parent);
    endfunction
  
    // Build Phase
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      axi_dri = axi_driver::type_id::create("axi_dri", this);
      axi_sqr = axi_sequencer::type_id::create("axi_sqr", this);
      axi_mon = axi_monitor::type_id::create("axi_mon", this);
      `uvm_info(get_full_name(), ":: In Build Phase @agent::", UVM_LOW)
    endfunction
  
    // Connect Phase
    function void connect_phase(uvm_phase phase);
      axi_dri.seq_item_port.connect(axi_sqr.seq_item_export);
      `uvm_info(get_full_name(), ":: In Connect Phase @agent::", UVM_LOW)
    endfunction
  endclass
  `endif
  
  