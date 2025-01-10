/*************************************************************************
   > File Name:   axi_wr_addr_sequence_lib.sv
   > Description: These are the sequences extended from base axi write addres 
                  sequence to test different cases
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_WR_ADDR_SEQUENCE_LIB
`define AXI_WR_ADDR_SEQUENCE_LIB

//------------------------------------------------------------------------------
// Seq 1: 
//
// Basic Write Address Transaction
// This sequence generates a fixed write Address transaction on the AXI Write Address Channel.
// It contains:
//             Busrt:            Fixed
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  1
//------------------------------------------------------------------------------

class basic_wr_addr_txn extends axi_wr_addr_sequence;
    `uvm_object_utils(basic_wr_addr_txn) // Register with the UVM factory
  
    axi_seq_item req; // Sequence item for the write transaction
  
    // Constructor
    function new(string name = "basic_wr_addr_txn");
      super.new(name);
    endfunction
  
    // Main sequence body
    task body();
      begin
            wait_for_grant();
            // Create and randomize sequence item
            req = axi_seq_item::type_id::create("basic_wr_addr_req");
            if (!req.randomize() with {
                    access == WRITE_TRAN;
                    burst == FIXED;
                    size == 4;
                    data.size == 4;
                }) begin
                `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
            end
            // Assign transaction details
            req.id = 4;
            req.addr = 32'h10;
            
            // Send request and wait for completion
            send_request(req);
            wait_for_item_done();
    end
  
    endtask
  endclass : basic_wr_addr_txn


//------------------------------------------------------------------------------
// Basic Inc Write Transaction
// This sequence generates a INc write transaction of size 16 bytes on the AXI bus.
//------------------------------------------------------------------------------
class basic_inc_write_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(basic_inc_write_txn) // Register with the UVM factory

  axi_seq_item req; // Sequence item for the write transaction

  // Constructor
  function new(string name = "basic_inc_write_txn");
    super.new(name);
  endfunction

  // Main sequence body
  task body();
    begin
          wait_for_grant();
          // Create and randomize sequence item
          req = axi_seq_item::type_id::create("basic_inc_write_txn_request");
          if (!req.randomize() with {
                  access == WRITE_TRAN;
                  burst == INCR;
                  size == 4;
                  data.size == 8;
              }) begin
              `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
          end
          // Assign transaction details
          req.id = 2;
          req.addr = 32'h10;
          
          // Send request and wait for completion
          send_request(req);
          wait_for_item_done();
          req.print();
  end

  endtask
endclass : basic_inc_write_txn

`endif