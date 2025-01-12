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


    // Read Sequences
    basic_rd_addr_txn             basic_rd_seq;               // Basic Read Address Sequence
    incr_rd_addr_txn_len1         inc_rd_len1_seq;
    incr_rd_addr_txn_len2         inc_rd_len2_seq;                // Incremental Read Address Sequence
    wrap_rd_large_data_txn        wrap_rd_large_seq;          // Wrap Read with Large Data
    incr_rd_single_beat_txn       incr_rd_single_beat_seq;    // Incremental Single Beat Read
    fixed_rd_large_txn            fixed_rd_large_seq;         // Fixed Burst Read with Large Size
    wrap_rd_small_width_txn       wrap_rd_small_width_seq;    // Wrap Read with Small Data Width
    incr_rd_mixed_size_txn        incr_rd_mixed_size_seq;     // Incremental Read with Mixed Data Sizes
    fixed_rd_single_small_txn     fixed_rd_single_small_seq;  // Fixed Burst Single Beat Small Read
    incr_rd_large_offset_txn      incr_rd_large_offset_seq;   // Incremental Read with Large Offset
    fixed_rd_alt_beat_txn         fixed_rd_alt_beat_seq;      // Fixed Read with Alternating Beats
    wrap_rd_non_aligned_txn       wrap_rd_non_aligned_seq;    // Wrap Read with Non-Aligned Address
    incr_rd_rand_addr_inc_txn     incr_rd_rand_addr_seq;      // Incremental Read with Randomized Address Increments
    wrap_rd_full_data_bus_txn     wrap_rd_full_data_seq;      // Wrap Read Filling Full Data Bus
    fixed_rd_seq_data_inc_txn     fixed_rd_seq_data_inc_seq;  // Fixed Read with Sequential Data Increment
    incr_rd_var_beat_txn          incr_rd_var_beat_seq;       // Incremental Read with Variable Beats
    wrap_rd_misaligned_txn        wrap_rd_misaligned_seq;     // Wrap Read with Misaligned Address
    fixed_rd_alt_id_txn           fixed_rd_alt_id_seq;        // Fixed Read with Alternating IDs
    rd_single_beat_multiple_txn   rd_single_beat_multi_seq;   // Single Beat Read Multiple Transactions

    // Write Addr Sequences
    fixed_wr_seq_data_inc_txn fixd_wr_seq_multiple_beats;



    // Write Data Sequences
    fixed_wr_seq_data_inc_txn fixd_wr_data_seq_multiple_beats;





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


        // Instantiate read sequences
        basic_rd_seq               = basic_rd_addr_txn::type_id::create("basic_rd_seq");
        inc_rd_len1_seq            = incr_rd_addr_txn_len1::type_id::create("inc_rd_len1_seq");
        inc_rd_len2_seq            = incr_rd_addr_txn_len2::type_id::create("inc_rd_len2_seq");
        wrap_rd_large_seq          = wrap_rd_large_data_txn::type_id::create("wrap_rd_large_seq");
        incr_rd_single_beat_seq    = incr_rd_single_beat_txn::type_id::create("incr_rd_single_beat_seq");
        fixed_rd_large_seq         = fixed_rd_large_txn::type_id::create("fixed_rd_large_seq");
        wrap_rd_small_width_seq    = wrap_rd_small_width_txn::type_id::create("wrap_rd_small_width_seq");
        incr_rd_mixed_size_seq     = incr_rd_mixed_size_txn::type_id::create("incr_rd_mixed_size_seq");
        fixed_rd_single_small_seq  = fixed_rd_single_small_txn::type_id::create("fixed_rd_single_small_seq");
        incr_rd_large_offset_seq   = incr_rd_large_offset_txn::type_id::create("incr_rd_large_offset_seq");
        fixed_rd_alt_beat_seq      = fixed_rd_alt_beat_txn::type_id::create("fixed_rd_alt_beat_seq");
        wrap_rd_non_aligned_seq    = wrap_rd_non_aligned_txn::type_id::create("wrap_rd_non_aligned_seq");
        incr_rd_rand_addr_seq      = incr_rd_rand_addr_inc_txn::type_id::create("incr_rd_rand_addr_seq");
        wrap_rd_full_data_seq      = wrap_rd_full_data_bus_txn::type_id::create("wrap_rd_full_data_seq");
        fixed_rd_seq_data_inc_seq  = fixed_rd_seq_data_inc_txn::type_id::create("fixed_rd_seq_data_inc_seq");
        incr_rd_var_beat_seq       = incr_rd_var_beat_txn::type_id::create("incr_rd_var_beat_seq");
        wrap_rd_misaligned_seq     = wrap_rd_misaligned_txn::type_id::create("wrap_rd_misaligned_seq");
        fixed_rd_alt_id_seq        = fixed_rd_alt_id_txn::type_id::create("fixed_rd_alt_id_seq");
        rd_single_beat_multi_seq   = rd_single_beat_multiple_txn::type_id::create("rd_single_beat_multi_seq");


        // Write Sequences
        fixd_wr_seq_multiple_beats = fixed_wr_seq_data_inc_txn::type_id::create("fixd_wr_seq_multiple_beats");

        // Write Data Sequences
        fixd_wr_data_seq_multiple_beats = fixed_wr_seq_data_inc_txn::type_id::create("fixd_wr_data_seq_multiple_beats");


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
