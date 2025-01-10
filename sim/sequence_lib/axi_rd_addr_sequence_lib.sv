/*************************************************************************
   > File Name:   axi_rd_addr_sequence_lib.sv
   > Description: These are the sequences extended from base axi read addres 
                  sequence to test different cases
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_RD_ADDR_SEQUENCE_LIB
`define AXI_RD_ADDR_SEQUENCE_LIB

//------------------------------------------------------------------------------
// Seq 1: 
//
// Basic Read Address Transaction
// This sequence generates a fixed Read Address transaction on the AXI Read Address Channel.
// It contains:
//             Busrt:            Fixed
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        4 bytes
//             Number of Beats:  1
//------------------------------------------------------------------------------

class basic_rd_addr_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(basic_rd_addr_txn) // Register with the UVM factory
  
    axi_seq_item req; // Sequence item for the rdite transaction
  
    // Constructor
    function new(string name = "basic_rd_addr_txn");
      super.new(name);
    endfunction
  
    // Main sequence body
    task body();
      begin
            wait_for_grant();
            // Create and randomize sequence item
            req = axi_seq_item::type_id::create("basic_rd_addr_req");
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 4;
                    data.size == 4;
                }) begin
                `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
            end
            // Assign transaction details
            req.id = 7;
            req.addr = 32'h1c;
            
            // Send request and wait for completion
            send_request(req);
            wait_for_item_done();
    end
  
    endtask
  endclass : basic_rd_addr_txn


  class basic_rd_multiple_beats_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(basic_rd_multiple_beats_txn) // Register with the UVM factory
  
    axi_seq_item req; // Sequence item for the rdite transaction
  
    // Constructor
    function new(string name = "basic_rd_multiple_beats_txn");
      super.new(name);
    endfunction
  
    // Main sequence body
    task body();
      begin
        for (int i = 0; i < 5 ; i++ ) begin
          wait_for_grant();
          // Create and randomize sequence item
          req = axi_seq_item::type_id::create("basic_rd_addr_req");
          if (!req.randomize() with {
                  access == READ_TRAN;
                  burst == FIXED;
                  size == 4;
                  data.size == 4;
              }) begin
              `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
          end
          // Assign transaction details
          req.id = i;
          req.addr = i*16;
          
          // Send request and wait for completion
          send_request(req);
          wait_for_item_done();
        end
    end
  
    endtask
  endclass : basic_rd_multiple_beats_txn

`endif