/*************************************************************************
   > File Name:   axi2ahb_env.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI2AHB_ENV
`define AXI2AHB_ENV

class axi2ahb_env extends uvm_env;
    `uvm_component_utils(axi2ahb_env)

    axi_agent axi_agnt;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase: Creates AXI agent
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "BUILD Phase of Axi_Env", UVM_LOW);
        axi_agnt = axi_agent::type_id::create("axi_agnt", this);
    endfunction

    // Connect Phase: Connects AXI monitor analysis port to scoreboard
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name(), "CONNECT", UVM_LOW);
    endfunction

endclass

`endif
