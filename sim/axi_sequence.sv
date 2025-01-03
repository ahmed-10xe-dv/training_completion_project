/*************************************************************************
   > File Name:   axi_sequence.sv
   > Description: The axi_sequence class is a UVM sequence that generates and sends AXI transactions, 
                  including write and read requests, to the driver for simulation. It ensures randomized 
                  and controlled AXI protocol operations for verification scenarios.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_SEQUENCE
`define AXI_SEQUENCE

class axi_sequence extends uvm_sequence #(axi_seq_item);
  `uvm_object_utils(axi_sequence)

  // Constructor
  function new(string name = "axi_sequence");
      super.new(name);
  endfunction

  // Task: Body
  task body();
      begin
              wait_for_grant();
              // Create and randomize sequence item
              req = axi_seq_item::type_id::create("Write_request");
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
              req.addr = 32'hc;
              
              // Send request and wait for completion
              send_request(req);
              wait_for_item_done();

      end


      begin
              wait_for_grant();
              // Create and randomize sequence item
              req = axi_seq_item::type_id::create("Read_request");
              if (!req.randomize() with {
                      access == READ_TRAN;
                      burst == FIXED;
                      size == 4;
                      data.size == 4;
                  }) begin
                  `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
              end
              // Assign transaction details
              req.id = 5;
              req.addr = 32'h4;
              
              // Send request and wait for completion
              send_request(req);
              wait_for_item_done();
      end

  endtask // body

endclass // axi_sequence



// //------------------------------------------------------------------------------
// // Basic Write Transaction
// // This sequence generates a fixed write transaction on the AXI bus.
// //------------------------------------------------------------------------------
// class basic_write_txn extends axi_sequence;
//   `uvm_object_utils(basic_write_txn) // Register with the UVM factory

//   axi_seq_item req; // Sequence item for the write transaction

//   // Constructor
//   function new(string name = "basic_write_txn");
//     super.new(name);
//   endfunction

//   // Main sequence body
//   task body();
//     // Wait for sequencer grant
//     wait_for_grant();
//     `uvm_info(get_type_name(), "REQUEST GRANTED: FIXED WRITE", UVM_MEDIUM)

//     // Create and randomize the write request
//     req = axi_seq_item::type_id::create("write_request", this);
//     if (!req.randomize() with {access == WRITE_TRAN; burst == FIXED; size == 4; data.size == 4;})
//       `uvm_error(get_full_name(), "REQ Randomization Failed @basic_write_txn")

//     // Set transaction properties
//     req.id = 10;
//     req.addr = 4;

//     // Send the request
//     send_request(req);
//     wait_for_item_done(); // Wait for the transaction to complete
//   endtask
// endclass : basic_write_txn

// //------------------------------------------------------------------------------
// // Basic Read Transaction
// // This sequence generates a fixed read transaction on the AXI bus.
// //------------------------------------------------------------------------------
// class basic_read_txn extends axi_sequence;
//   `uvm_object_utils(basic_read_txn) // Register with the UVM factory

//   axi_seq_item req; // Sequence item for the read transaction

//   // Constructor
//   function new(string name = "basic_read_txn");
//     super.new(name);
//   endfunction

//   // Main sequence body
//   task body();
//     // Wait for sequencer grant
//     wait_for_grant();
//     `uvm_info(get_type_name(), "REQUEST GRANTED: FIXED READ", UVM_MEDIUM)

//     // Create and randomize the read request
//     req = axi_seq_item::type_id::create("read_request", this);
//     if (!req.randomize() with {access == READ_TRAN; burst == FIXED; size == 4; data.size == 4;})
//       `uvm_error(get_full_name(), "REQ Randomization Failed @basic_read_txn")

//     // Set transaction properties
//     req.id = 10;
//     req.addr = 4;

//     // Send the request
//     send_request(req);
//     wait_for_item_done(); // Wait for the transaction to complete
//   endtask
// endclass : basic_read_txn

// //------------------------------------------------------------------------------
// // Multiple Read and Write Transactions
// // This sequence generates multiple fixed read and write transactions on the AXI bus.
// //------------------------------------------------------------------------------
// class multiple_read_write extends axi_sequence;
//   `uvm_object_utils(multiple_read_write) // Register with the UVM factory

//   axi_seq_item req; // Sequence item for read/write transactions

//   // Constructor
//   function new(string name = "multiple_read_write");
//     super.new(name);
//   endfunction

//   // Main sequence body
//   task body();
//     // Generate multiple write transactions
//     for (int i = 0; i < 5; ++i) begin
//       wait_for_grant();
//       `uvm_info(get_type_name(), $sformatf("REQUEST GRANTED: FIXED WRITE (ID=%0d)", i), UVM_MEDIUM)

//       // Create and randomize the write request
//       req = axi_seq_item::type_id::create("write_request", this);
//       if (!req.randomize() with {access == WRITE_TRAN; burst == FIXED; size == 4; data.size == 4;})
//         `uvm_error(get_full_name(), "REQ Randomization Failed @multiple_read_write (WRITE)")

//       // Set transaction properties
//       req.id = i;
//       req.addr = i * 40;

//       // Send the request
//       send_request(req);
//       wait_for_item_done(); // Wait for the transaction to complete
//     end

//     // Generate multiple read transactions
//     for (int i = 0; i < 5; ++i) begin
//       wait_for_grant();
//       `uvm_info(get_type_name(), $sformatf("REQUEST GRANTED: FIXED READ (ID=%0d)", i), UVM_MEDIUM)

//       // Create and randomize the read request
//       req = axi_seq_item::type_id::create("read_request", this);
//       if (!req.randomize() with {access == READ_TRAN; burst == FIXED; size == 4; data.size == 4;})
//         `uvm_error(get_full_name(), "REQ Randomization Failed @multiple_read_write (READ)")

//       // Set transaction properties
//       req.id = i;
//       req.addr = i * 40;

//       // Send the request
//       send_request(req);
//       wait_for_item_done(); // Wait for the transaction to complete
//     end
//   endtask
// endclass : multiple_read_write


`endif