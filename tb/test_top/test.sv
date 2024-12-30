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
    axi_sequence wr_addr_seq;          // Write address sequence
    axi_sequence rd_addr_seq;          // Read address sequence
    axi_sequence wr_data_seq;          // Write data sequence
    axi_sequence rd_data_seq;          // Read data sequence
    ahb_sequence ahb_seq;              // AHB sequence

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

        // Create test sequences
        wr_addr_seq = axi_sequence::type_id::create("wr_addr_seq", this);
        rd_addr_seq = axi_sequence::type_id::create("rd_addr_seq", this);
        wr_data_seq = axi_sequence::type_id::create("wr_data_seq", this);
        rd_data_seq = axi_sequence::type_id::create("rd_data_seq", this);
        ahb_seq = ahb_sequence::type_id::create("ahb_seq", this);

        // Start sequences concurrently
        fork
            wr_addr_seq.start(env.wr_addr_agnt.wr_addr_sqr);
            // rd_addr_seq.start(env.rd_addr_agnt.rd_addr_sqr);
            wr_data_seq.start(env.wr_data_agnt.wr_data_sqr);
            // rd_data_seq.start(env.rd_data_agnt.rd_data_sqr);
            ahb_seq.start(env.ahb_agnt.ahb_sqr);
        join

        // Wait for a specific time to ensure operations complete
        #1000ns;

        phase.drop_objection(this, "MAIN - drop_objection");
        `uvm_info(get_full_name(), "MAIN PHASE ENDED", UVM_LOW);
    endtask : main_phase

endclass : axi2ahb_test

`endif
