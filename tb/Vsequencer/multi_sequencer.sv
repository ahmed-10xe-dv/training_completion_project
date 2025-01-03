/*************************************************************************
   > File Name:   virtual_sequencer.sv
   > Description: Virtual sequencer managing AHB and AXI sequencers.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

class virtual_sequencer extends uvm_sequencer;

    //-------------------------------------------------------------------------
    // Member Variables
    // The virtual sequencer manages individual AXI and AHB sequencers.
    //-------------------------------------------------------------------------
    wr_addr_sequencer wr_addr_sqr;     // Write address sequencer for AXI
    rd_addr_sequencer rd_addr_sqr;     // Read address sequencer for AXI
    wr_data_sequencer wr_data_sqr;     // Write data sequencer for AXI
    rd_data_sequencer rd_data_sqr;     // Read data sequencer for AXI
    wr_rsp_sequencer wr_rsp_sqr;     // Write Response sequencer for AXI
    ahb_sequencer     ahb_sqr;         // Sequencer for AHB transactions

    //-------------------------------------------------------------------------
    // Factory Registration
    //-------------------------------------------------------------------------
    `uvm_component_utils(virtual_sequencer)

    //-------------------------------------------------------------------------
    // Constructor
    //-------------------------------------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

endclass
