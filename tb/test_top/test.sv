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
    axi2ahb_env     env;                     // Environment handle
    // multi_seq       mul_seq;              // Virtual Seq Handle
    virtual axi_interface axi_vif;           // Virtual interface for AXI signals
    virtual ahb_interface ahb_vif;           // Virtual interface for AXI signals


    axi_wr_addr_sequence wr_addr_seq;  // AXI Write Address Sequence
    axi_rd_addr_sequence rd_addr_seq;  // AXI Read Address Sequence
    axi_wr_data_sequence wr_data_seq;  // AXI Write Data Sequence
    axi_rd_data_sequence rd_data_seq;  // AXI Read Data Sequence
    axi_wr_rsp_sequence  wr_rsp_seq;   // AXI Write Response Sequence
    ahb_sequence ahb_seq;              // AHB Sequence


    configurations  cnfg;                    // Configurations

    //-----------------------------------------------------------------------------  
    // Function: new
    //-----------------------------------------------------------------------------  
    function new(string name = "axi2ahb_test", uvm_component parent = null);
        super.new(name, parent);
        wr_addr_seq = axi_wr_addr_sequence::type_id::create("wr_addr_seq");
        rd_addr_seq = axi_rd_addr_sequence::type_id::create("rd_addr_seq");
        wr_data_seq = axi_wr_data_sequence::type_id::create("wr_data_seq");
        rd_data_seq = axi_rd_data_sequence::type_id::create("rd_data_seq");
        wr_rsp_seq =  axi_wr_rsp_sequence::type_id::create("wr_rsp_seq");
        ahb_seq = ahb_sequence::type_id::create("ahb_seq");
    endfunction : new

    //-----------------------------------------------------------------------------  
    // Function: build_phase
    //-----------------------------------------------------------------------------  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "BUILD PHASE STARTED", UVM_LOW);
        if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
            `uvm_error(get_full_name(), "Failed to connect axi_vif interface")
        if (!uvm_config_db#(virtual ahb_interface)::get(null, "*", "ahb_vif", ahb_vif))
            `uvm_error(get_full_name(), "Failed to connect ahb_vif interface")
        // cnfg.Iterations = 2;
        // Create environment
        env = axi2ahb_env::type_id::create("env", this);
        // mul_seq = multi_seq::type_id::create("mul_seq");
        // uvm_config_db #(configurations)::set(this,"*", "configurations", cnfg);
        // uvm_config_db #(uvm_active_passive_enum)::set(this, "env.wr_rsp_agnt", "is_active", UVM_PASSIVE);
        // uvm_config_db #(uvm_active_passive_enum)::set(this, "env.rd_addr_agnt", "is_active", UVM_PASSIVE);
        // uvm_config_db #(uvm_active_passive_enum)::set(this, "env.rd_data_agnt", "is_active", UVM_PASSIVE);

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

        // Uncomment it only if you want to run the sequences through Vseqr
        // mul_seq.start(env.vseqr);       // Start sequences through virtual sequencer
        // #200ns;

        fork
                wr_addr_seq.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
                rd_addr_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
                wr_data_seq.start(env.axi_env.wr_data_agnt.wr_data_sqr);
                rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
                wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
            begin
                // #140; // Added Delay to make sure that AHB sequence starts once the valid axi transactions have started 
                wait(axi_vif.ARREADY || axi_vif.AWREADY || axi_vif.ARREADY); // begin
                @(posedge axi_vif.ACLK);
                ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
                // end
            end
        join
        // #50;

        phase.drop_objection(this, "MAIN - drop_objection");
        `uvm_info(get_full_name(), "MAIN PHASE ENDED", UVM_LOW);
    endtask : main_phase

endclass : axi2ahb_test

`endif
