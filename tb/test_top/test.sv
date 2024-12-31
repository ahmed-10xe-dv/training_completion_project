/*************************************************************************
   > File Name:   axi2ahb_test.sv
   > Description: This file implements the AXI to AHB testbench, which 
                  initializes the environment and sequences to verify the
                  AXI to AHB bridge functionality.
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

    // Environment and sequence handles
    axi2ahb_env env;                   // Environment handle
    multi_seq mul_seq;                 // Virtual Seq Handle
    mem_model_pkg::mem_model#(bus_params_pkg::BUS_AW, bus_params_pkg::BUS_DW, bus_params_pkg::BUS_DBW) mem_model_inst;



    //-----------------------------------------------------------------------------  
    // Function: new
    //-----------------------------------------------------------------------------  
    function new(string name = "axi2ahb_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

    //-----------------------------------------------------------------------------  
    // Function: build_phase
    //-----------------------------------------------------------------------------  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "BUILD PHASE STARTED", UVM_LOW);
        
        // Create environment
        env = axi2ahb_env::type_id::create("env", this);
        mul_seq = multi_seq::type_id::create("mul_seq");

        // Instantiate 4kB memory
        mem_model_inst = mem_model_pkg::mem_model#()::type_id::create("mem_model_inst"); 
        // mem_model_pkg::mem_model#(bus_params_pkg::BUS_AW, bus_params_pkg::BUS_DW, bus_params_pkg::BUS_DBW) mem_model_inst;


    endfunction : build_phase

    //-----------------------------------------------------------------------------  
    // Function: end_of_elaboration_phase
    //-----------------------------------------------------------------------------  
    function void end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    //-----------------------------------------------------------------------------  
    // Task: main_phase
    // Description: Executes the test sequence during the main phase.
    //-----------------------------------------------------------------------------  
    task main_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "MAIN PHASE STARTED", UVM_LOW);
        phase.raise_objection(this, "MAIN - raise_objection");

        // TO DO :  Load memory here
        mul_seq.mem = mem_model_inst;   // Assign memory to multi sequence
        
        mul_seq.start(env.vseqr);

        // Wait for a specific time to ensure operations complete
        #1000ns;

        phase.drop_objection(this, "MAIN - drop_objection");
        `uvm_info(get_full_name(), "MAIN PHASE ENDED", UVM_LOW);
    endtask : main_phase

endclass : axi2ahb_test

`endif
