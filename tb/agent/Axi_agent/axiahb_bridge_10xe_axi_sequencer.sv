/*************************************************************************
   > File Name:   axi_sequencer.sv
   > Description: Handles sequences of AXI transactions (axi_seq_item).
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_SEQUENCER
`define AXI_SEQUENCER

class axi_sequencer extends uvm_sequencer #(axi_seq_item);
    `uvm_component_utils(axi_sequencer)

    function new(string name = "axi_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction : new

endclass

`endif