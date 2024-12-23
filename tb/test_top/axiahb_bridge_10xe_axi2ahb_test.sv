/*************************************************************************
   > File Name:   axi2ahb_test.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI2AHB_TEST
`define AXI2AHB_TEST

class axi2ahb_test extends uvm_test;
    `uvm_component_utils(axi2ahb_test)

    // Handles for environment and sequence
    axi2ahb_env env;
    axi_sequence axi_seq;

    function new(string name = "axi2ahb_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "BUILD PHASE STARTED", UVM_LOW);
        env = axi2ahb_env::type_id::create("env", this);
    endfunction

    // // Main Phase: Executes the test sequence
    // task main_phase(uvm_phase phase);
    //     // `uvm_info(get_full_name(), "MAIN PHASE STARTED", UVM_LOW);
    //     // phase.raise_objection(this, "run - raise_objection");

    //     // axi_seq = axi_sequence::type_id::create("axi_seq", this);
    //     // axi_seq.start(env.axi_agnt.axi_sqr);
    //     // #10000ns;
    //     // phase.drop_objection(this, "run - drop_objection");
    // endtask

    // Run Phase: Logs test run information
    task run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "RUN PHASE STARTED", UVM_LOW);
        phase.raise_objection(this, "run - raise_objection");

        axi_seq = axi_sequence::type_id::create("axi_seq", this);
        axi_seq.start(env.axi_agnt.axi_sqr);
        #10000ns;
        phase.drop_objection(this, "run - drop_objection");
        `uvm_info(get_full_name(), "RUN PHASE ENDED", UVM_LOW);
    endtask
endclass

`endif
