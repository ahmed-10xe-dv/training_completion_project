/*************************************************************************
   > File Name:   multi_seq.sv
   > Description: Multi-sequence class to manage concurrent AXI and AHB 
                  sequences in a UVM testbench.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

class multi_seq extends uvm_sequence;

    //-------------------------------------------------------------------------
    // Factory Registration and Sequencer Declaration
    //-------------------------------------------------------------------------
    `uvm_object_utils(multi_seq)
    `uvm_declare_p_sequencer(virtual_sequencer)

    //-------------------------------------------------------------------------
    // Member Variables
    //-------------------------------------------------------------------------
    axi_sequence wr_addr_seq;  // AXI Write Address Sequence
    axi_sequence rd_addr_seq;  // AXI Read Address Sequence
    axi_sequence wr_data_seq;  // AXI Write Data Sequence
    axi_sequence rd_data_seq;  // AXI Read Data Sequence
    axi_sequence wr_rsp_seq;  // AXI Write Response Sequence
    ahb_sequence ahb_seq;      // AHB Sequence

    //-------------------------------------------------------------------------
    // Constructor
    //-------------------------------------------------------------------------
    function new(string name = "multi_seq");
        super.new(name);
        wr_addr_seq = axi_sequence::type_id::create("wr_addr_seq");
        rd_addr_seq = axi_sequence::type_id::create("rd_addr_seq");
        wr_data_seq = axi_sequence::type_id::create("wr_data_seq");
        rd_data_seq = axi_sequence::type_id::create("rd_data_seq");
        wr_rsp_seq = axi_sequence::type_id::create("wr_rsp_seq");
        ahb_seq = ahb_sequence::type_id::create("ahb_seq");
    endfunction

    //-------------------------------------------------------------------------
    // Pre-body Task
    // Creates test sequences for AXI and AHB
    //-------------------------------------------------------------------------
    task pre_body();

    endtask

    //-------------------------------------------------------------------------
    // Main Body Task
    // Starts the AXI and AHB sequences concurrently
    //-------------------------------------------------------------------------
    virtual task body();
        fork
            fork
                wr_addr_seq.start(p_sequencer.wr_addr_sqr);
                rd_addr_seq.start(p_sequencer.rd_addr_sqr);
                wr_data_seq.start(p_sequencer.wr_data_sqr);
                rd_data_seq.start(p_sequencer.rd_data_sqr);
                wr_rsp_seq.start(p_sequencer.wr_rsp_sqr);
            join
            begin
                // #140; // Added Delay to make sure that AHB sequence starts once the valid axi transactions have started 
                ahb_seq.start(p_sequencer.ahb_sqr);
            end
        join
        // #500;
    endtask

endclass
