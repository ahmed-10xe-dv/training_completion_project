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

//------------------------------------------------------------------------------
// Seq :
//
// INCR Read Address Transaction With Length 1
// This sequence generates an INCR burst Read Address transaction of len 1 on the AXI Read Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        4 bytes
//             Number of Beats:  1
//------------------------------------------------------------------------------
class incr_rd_addr_txn_len1 extends axi_rd_addr_sequence;
  `uvm_object_utils(incr_rd_addr_txn_len1)

  axi_seq_item req;

  function new(string name = "incr_rd_addr_txn_len1");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_rd_addr_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == INCR;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 1;
      req.addr = 32'h10;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : incr_rd_addr_txn_len1


//------------------------------------------------------------------------------
// Seq :
//
// INCR Read Address Transaction
// This sequence generates an INCR burst Read Address transaction on the AXI Read Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        8 bytes
//             Number of Beats:  2
//------------------------------------------------------------------------------
class incr_rd_addr_txn_len2 extends axi_rd_addr_sequence;
  `uvm_object_utils(incr_rd_addr_txn_len2)

  axi_seq_item req;

  function new(string name = "incr_rd_addr_txn_len2");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_rd_addr_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == INCR;
              size == 4;
              data.size == 8; // 2 beats * 4 bytes each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 1;
      req.addr = 32'h10;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : incr_rd_addr_txn_len2

//------------------------------------------------------------------------------
// Seq 3:
//
// WRAP Read Address Transaction with Larger Data Width
// This sequence generates a WRAP burst Read Address transaction on the AXI Read Address Channel.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        16 bytes
//             Number of Beats:  2
//------------------------------------------------------------------------------
class wrap_rd_large_data_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(wrap_rd_large_data_txn)

  axi_seq_item req;

  function new(string name = "wrap_rd_large_data_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_rd_large_data_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == WRAP;
              size == 4;
              data.size == 16; // 4 beats * 4 bytes each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 2;
      req.addr = 32'h20;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : wrap_rd_large_data_txn

//------------------------------------------------------------------------------
// Seq 4:
//
// INCR Read Address Transaction with Single Beat
// This sequence generates a single-beat INCR Read Address transaction.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  2 bytes
//             Transaction Type: Read
//             Data Size:        2 bytes
//             Number of Beats:  1
//------------------------------------------------------------------------------
class incr_rd_single_beat_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(incr_rd_single_beat_txn)

  axi_seq_item req;

  function new(string name = "incr_rd_single_beat_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_rd_single_beat_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == INCR;
              size == 2;
              data.size == 2;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 3;
      req.addr = 32'h30;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : incr_rd_single_beat_txn


//------------------------------------------------------------------------------
// Seq 5:
//
// FIXED Burst with Large Data Size
// This sequence generates a FIXED burst Read Address transaction on the AXI Read Address Channel.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  8 bytes
//             Transaction Type: Read
//             Data Size:        32 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------
class fixed_rd_large_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(fixed_rd_large_txn)

  axi_seq_item req;

  function new(string name = "fixed_rd_large_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("fixed_rd_large_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == FIXED;
              size == 2;
              data.size == 32; // 16 beats *  2 bytes each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 4;
      req.addr = 32'h40;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : fixed_rd_large_txn

//------------------------------------------------------------------------------
// Seq 6:
//
// WRAP Burst with Small Data Width
// This sequence generates a WRAP burst Read Address transaction with minimal data width.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  1 byte
//             Transaction Type: Read
//             Data Size:        4 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------
class wrap_rd_small_width_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(wrap_rd_small_width_txn)

  axi_seq_item req;

  function new(string name = "wrap_rd_small_width_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_rd_small_width_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == WRAP;
              size == 1;
              data.size == 4; // 4 beats * 1 byte each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 5;
      req.addr = 32'h50;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : wrap_rd_small_width_txn

//------------------------------------------------------------------------------
// Seq 7:
//
// INCR Burst with Mixed Data Size
// This sequence generates an INCR burst Read Address transaction on the AXI Read Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        12 bytes
//             Number of Beats:  3
//------------------------------------------------------------------------------
class incr_rd_mixed_size_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(incr_rd_mixed_size_txn)

  axi_seq_item req;

  function new(string name = "incr_rd_mixed_size_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_rd_mixed_size_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == INCR;
              size == 4;
              data.size == 12; // 3 beats * 4 bytes each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 6;
      req.addr = 32'h60;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : incr_rd_mixed_size_txn

//------------------------------------------------------------------------------
// Seq 8:
//
// FIXED Burst with Single Beat and Small Data
// This sequence generates a single-beat FIXED burst with minimal data.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  1 byte
//             Transaction Type: Read
//             Data Size:        1 byte
//             Number of Beats:  1
//------------------------------------------------------------------------------
class fixed_rd_single_small_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(fixed_rd_single_small_txn)

  axi_seq_item req;

  function new(string name = "fixed_rd_single_small_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("fixed_rd_single_small_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == FIXED;
              size == 1;
              data.size == 1; // Single beat of 1 byte
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 7;
      req.addr = 32'h70;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : fixed_rd_single_small_txn



//------------------------------------------------------------------------------
// Seq 10:
//
// INCR Burst with Large Address Offset
// This sequence generates an INCR burst Read Address transaction with a large address offset.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        16 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------
class incr_rd_large_offset_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(incr_rd_large_offset_txn)

  axi_seq_item req;

  function new(string name = "incr_rd_large_offset_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_rd_large_offset_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == INCR;
              size == 4;
              data.size == 16; // 4 beats * 4 bytes each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 9;
      req.addr = 32'h100;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : incr_rd_large_offset_txn

//------------------------------------------------------------------------------
// Seq 11:
//
// FIXED Burst with Alternating Beat Addresses
// This sequence generates a FIXED burst Read Address transaction with alternating beat addresses.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        24 bytes
//             Number of Beats:  6
//------------------------------------------------------------------------------
class fixed_rd_alt_beat_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(fixed_rd_alt_beat_txn)

  axi_seq_item req;

  function new(string name = "fixed_rd_alt_beat_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("fixed_rd_alt_beat_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == FIXED;
              size == 4;
              data.size == 24; // 6 beats * 4 bytes each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 10;
      req.addr = 32'h200;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : fixed_rd_alt_beat_txn

//------------------------------------------------------------------------------
// Seq 12:
//
// WRAP Burst with Non-Aligned Address
// This sequence generates a WRAP burst Read Address transaction with a non-aligned start address.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  2 bytes
//             Transaction Type: Read
//             Data Size:        8 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------
class wrap_rd_non_aligned_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(wrap_rd_non_aligned_txn)

  axi_seq_item req;

  function new(string name = "wrap_rd_non_aligned_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_rd_non_aligned_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == WRAP;
              size == 2;
              data.size == 8; // 4 beats * 2 bytes each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 11;
      req.addr = 32'h30A; // Non-aligned address
      send_request(req);
      wait_for_item_done();
  endtask
endclass : wrap_rd_non_aligned_txn

// //------------------------------------------------------------------------------
// // Seq 13:
// //
// // FIXED Burst with Small Data and High ID
// // This sequence generates a FIXED burst Read Address transaction with a small data size and high ID.
// // It contains:
// //             Burst:            FIXED
// //             Data Lane Width:  1 byte
// //             Transaction Type: Read
// //             Data Size:        2 bytes
// //             Number of Beats:  2
// //------------------------------------------------------------------------------
// class fixed_rd_small_high_id_txn extends axi_rd_addr_sequence;
//   `uvm_object_utils(fixed_rd_small_high_id_txn)

//   axi_seq_item req;

//   function new(string name = "fixed_rd_small_high_id_txn");
//       super.new(name);
//   endfunction

//   task body();
//       wait_for_grant();
//       req = axi_seq_item::type_id::create("fixed_rd_small_high_id_req");
//       if (!req.randomize() with {
//               access == READ_TRAN;
//               burst == FIXED;
//               size == 1;
//               data.size == 2; // 2 beats * 1 byte each
//           }) begin
//           `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
//       end
//       req.id = 1023; // High ID value
//       req.addr = 32'h400;
//       send_request(req);
//       wait_for_item_done();
//   endtask
// endclass : fixed_rd_small_high_id_txn

//------------------------------------------------------------------------------
// Seq 14:
//
// INCR Burst with Random Address Increment
// This sequence generates an INCR burst with random address increments between beats.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        16 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------
class incr_rd_rand_addr_inc_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(incr_rd_rand_addr_inc_txn)

  axi_seq_item req;

  function new(string name = "incr_rd_rand_addr_inc_txn");
      super.new(name);
  endfunction

  task body();
      for (int i = 0; i < 4; i++) begin
          wait_for_grant();
          req = axi_seq_item::type_id::create($sformatf("incr_rd_rand_addr_inc_req_%0d", i));
          if (!req.randomize() with {
                  access == READ_TRAN;
                  burst == INCR;
                  size == 4;
                  data.size == 4; // Single beat * 4 bytes each
              }) begin
              `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
          end
          req.id = i + 2; // Arbitrary ID
          req.addr = 32'h500 + (i * $urandom_range(8, 16)); // Random increment
          send_request(req);
          wait_for_item_done();
      end
  endtask
endclass : incr_rd_rand_addr_inc_txn


//------------------------------------------------------------------------------
// Seq 15:
//
// WRAP Burst with Full Data Bus Utilization
// This sequence generates a WRAP burst Read Address transaction that fully utilizes the data bus.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        30 bytes
//             Number of Beats:  // 7 beats * 4 bytes each + 1 beat * 2 bytes 
//------------------------------------------------------------------------------
class wrap_rd_full_data_bus_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(wrap_rd_full_data_bus_txn)

  axi_seq_item req;

  function new(string name = "wrap_rd_full_data_bus_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_rd_full_data_bus_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == WRAP;
              size == 4;
              data.size == 30; // 7 beats * 4 bytes each + 1 beat * 2 bytes 
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 15;
      req.addr = 32'h600;
      send_request(req);
      wait_for_item_done();
  endtask
endclass : wrap_rd_full_data_bus_txn

//------------------------------------------------------------------------------
// Seq 16:
//
// FIXED Burst with Sequential Data Size Increment
// This sequence generates a FIXED burst Read Address transaction with sequentially increasing data sizes.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        Variable (4 to 16 bytes)
//             Number of Beats:  4
//------------------------------------------------------------------------------
class fixed_rd_seq_data_inc_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(fixed_rd_seq_data_inc_txn)

  axi_seq_item req;

  function new(string name = "fixed_rd_seq_data_inc_txn");
      super.new(name);
  endfunction

  task body();
      for (int i = 1; i <= 4; i++) begin
          wait_for_grant();
          req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_data_inc_req_%0d", i));
          if (!req.randomize() with {
                  access == READ_TRAN;
                  burst == FIXED;
                  size == 4;
                  data.size == i * 4; // Incremental data size: 4, 8, 12, 16 bytes
              }) begin
              `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
          end
          req.id = 1 + i;
          req.addr = 32'h700 + (i * 4);
          send_request(req);
          wait_for_item_done();
      end
  endtask
endclass : fixed_rd_seq_data_inc_txn

//------------------------------------------------------------------------------
// Seq 17:
//
// INCR Burst with Variable Beat Count
// This sequence generates an INCR burst Read Address transaction with variable beat counts.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  2 bytes
//             Transaction Type: Read
//             Data Size:        2 bytes * Beat Count
//             Number of Beats:  2 to 6
//------------------------------------------------------------------------------
class incr_rd_var_beat_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(incr_rd_var_beat_txn)

  axi_seq_item req;

  function new(string name = "incr_rd_var_beat_txn");
      super.new(name);
  endfunction

  task body();
      for (int beats = 2; beats <= 6; beats++) begin
          wait_for_grant();
          req = axi_seq_item::type_id::create($sformatf("incr_rd_var_beat_req_%0d", beats));
          if (!req.randomize() with {
                  access == READ_TRAN;
                  burst == INCR;
                  size == 2;
                  data.size == beats * 2; // Data size depends on the number of beats
              }) begin
              `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
          end
          req.id = 2 + beats;
          req.addr = 32'h800 + (beats * 8);
          send_request(req);
          wait_for_item_done();
      end
  endtask
endclass : incr_rd_var_beat_txn

//------------------------------------------------------------------------------
// Seq 18:
//
// WRAP Burst with Misaligned Address
// This sequence generates a WRAP burst Read Address transaction with a misaligned starting address.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  1 byte
//             Transaction Type: Read
//             Data Size:        8 bytes
//             Number of Beats:  8
//------------------------------------------------------------------------------
class wrap_rd_misaligned_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(wrap_rd_misaligned_txn)

  axi_seq_item req;

  function new(string name = "wrap_rd_misaligned_txn");
      super.new(name);
  endfunction

  task body();
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_rd_misaligned_req");
      if (!req.randomize() with {
              access == READ_TRAN;
              burst == WRAP;
              size == 1;
              data.size == 8; // 8 beats * 1 byte each
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 25;
      req.addr = 32'h90B; // Misaligned address
      send_request(req);
      wait_for_item_done();
  endtask
endclass : wrap_rd_misaligned_txn

//------------------------------------------------------------------------------
// Seq 19:
//
// FIXED Burst with Alternating IDs
// This sequence generates a FIXED burst Read Address transaction with alternating IDs.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        32 bytes
//             Number of Beats:  8
//------------------------------------------------------------------------------
class fixed_rd_alt_id_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(fixed_rd_alt_id_txn)

  axi_seq_item req;

  function new(string name = "fixed_rd_alt_id_txn");
      super.new(name);
  endfunction

  task body();
      for (int i = 0; i < 4; i++) begin
          wait_for_grant();
          req = axi_seq_item::type_id::create($sformatf("fixed_rd_alt_id_req_%0d", i));
          if (!req.randomize() with {
                  access == READ_TRAN;
                  burst == FIXED;
                  size == 4;
                  data.size == 32; // 8 beats * 4 bytes each
              }) begin
              `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
          end
          req.id = (i % 2 == 0) ? 2 : 3; // Alternating ID: 2, 3
          req.addr = 32'hA00 + (i * 16);
          send_request(req);
          wait_for_item_done();
      end
  endtask
endclass : fixed_rd_alt_id_txn

//------------------------------------------------------------------------------
// Seq 21: 
//
// Basic Read Transaction with single beat multiple transactions in it 
// This sequence generates a fixed Read Address transaction on the AXI Read Address Channel.
// It contains:
//             Busrt:            Fixed
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        4 bytes
//             Number of Beats:  1 per transaction
//             Total Txns:       5
//------------------------------------------------------------------------------

class rd_single_beat_multiple_txn extends axi_rd_addr_sequence;
  `uvm_object_utils(rd_single_beat_multiple_txn) // Register with the UVM factory

  axi_seq_item req; // Sequence item for the rdite transaction

  // Constructor
  function new(string name = "rd_single_beat_multiple_txn");
    super.new(name);
  endfunction

  // Main sequence body
  task body();
    begin
      for (int i = 0; i < 5 ; i++ ) begin
        wait_for_grant();
        // Create and randomize sequence item
        req = axi_seq_item::type_id::create("rd_single_beat_multiple_txn_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == FIXED;
                size == 4;
                data.size == 4;
            }) begin
            `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
        end
        // Assign transaction details
        req.id = i+4;
        req.addr = (i+4)*16;
        
        // Send request and wait for completion
        send_request(req);
        wait_for_item_done();
      end
  end

  endtask
endclass : rd_single_beat_multiple_txn


// class incr_rd_addr_seq extends uvm_sequence #(axi_transaction);
//   `uvm_object_utils(incr_rd_addr_seq)

//   function new(string name = "incr_rd_addr_seq");
//       super.new(name);
//   endfunction

//   task body();
//       axi_transaction trans;
//       foreach (i [1:14]) begin
//           trans = axi_transaction::type_id::create("trans", this);
//           trans.access = READ_TRAN;
//           trans.burst = INCR;
//           trans.size = 4;
//           trans.data.size = 32;
//           trans.addr = (i - 1) * 16;
//           start_item(trans);
//           finish_item(trans);
//       end
//   endtask : body
// endclass : incr_rd_addr_seq



// class single_fixed_rd_addr_seq extends uvm_sequence #(axi_transaction);
//   `uvm_object_utils(single_fixed_rd_addr_seq)

//   function new(string name = "single_fixed_rd_addr_seq");
//       super.new(name);
//   endfunction

//   task body();
//       axi_transaction trans;
//       trans = axi_transaction::type_id::create("trans", this);
//       trans.access = READ_TRAN;
//       trans.burst = FIXED;
//       trans.size = 4;
//       trans.data.size = 4;
//       trans.addr = 4;
//       start_item(trans);
//       finish_item(trans);
//   endtask : body
// endclass : single_fixed_rd_addr_seq


// class multi_fixed_rd_addr_seq extends uvm_sequence #(axi_transaction);
//   `uvm_object_utils(multi_fixed_rd_addr_seq)

//   function new(string name = "multi_fixed_rd_addr_seq");
//       super.new(name);
//   endfunction

//   task body();
//       axi_transaction trans;
//       foreach (i [0:4]) begin
//           trans = axi_transaction::type_id::create("trans", this);
//           trans.access = READ_TRAN;
//           trans.burst = FIXED;
//           trans.size = 4;
//           trans.data.size = 4;
//           trans.addr = i * 40;
//           start_item(trans);
//           finish_item(trans);
//       end
//   endtask : body
// endclass : multi_fixed_rd_addr_seq


// class fixed_burst_single_addr_rd_seq extends uvm_sequence #(axi_transaction);
//   `uvm_object_utils(fixed_burst_single_addr_rd_seq)

//   function new(string name = "fixed_burst_single_addr_rd_seq");
//       super.new(name);
//   endfunction

//   task body();
//       axi_transaction trans;
//       trans = axi_transaction::type_id::create("trans", this);
//       trans.access = READ_TRAN;
//       trans.burst = FIXED;
//       trans.size = 4;
//       trans.data.size = 4;
//       trans.addr = 60;
//       start_item(trans);
//       finish_item(trans);
//   endtask : body
// endclass : fixed_burst_single_addr_rd_seq
















`endif