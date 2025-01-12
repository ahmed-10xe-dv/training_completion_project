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


//------------------------------------------------------------------------------
// Seq 2: 
//
// Incremental Write Address Transaction
// This sequence generates an incremental write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        16 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------

class incr_wr_addr_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(incr_wr_addr_txn)

  axi_seq_item req;

  function new(string name = "incr_wr_addr_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_wr_addr_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == INCR;
              size == 4;
              data.size == 16;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 3;
      req.addr = 32'h20;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : incr_wr_addr_txn

//------------------------------------------------------------------------------
// Seq 3: 
//
// Wrap Write with Large Data Transaction
// This sequence generates a wrap write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  8
//------------------------------------------------------------------------------

class wrap_wr_large_data_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(wrap_wr_large_data_txn)

  axi_seq_item req;

  function new(string name = "wrap_wr_large_data_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_wr_large_data_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == WRAP;
              size == 4;
              data.size == 32;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 7;
      req.addr = 32'h40;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : wrap_wr_large_data_txn

//------------------------------------------------------------------------------
// Seq 4: 
//
// Incremental Write Single Beat Transaction
// This sequence generates an incremental write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  1
//------------------------------------------------------------------------------

class incr_wr_single_beat_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(incr_wr_single_beat_txn)

  axi_seq_item req;

  function new(string name = "incr_wr_single_beat_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_wr_single_beat_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == INCR;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 1;
      req.addr = 32'h60;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : incr_wr_single_beat_txn



//------------------------------------------------------------------------------
// Seq 5: 
//
// Fixed Write Large Transaction
// This sequence generates a fixed write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  8
//------------------------------------------------------------------------------

class fixed_wr_large_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(fixed_wr_large_txn)

  axi_seq_item req;

  function new(string name = "fixed_wr_large_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("fixed_wr_large_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == FIXED;
              size == 4;
              data.size == 30;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 5;
      req.addr = 32'h80;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : fixed_wr_large_txn


//------------------------------------------------------------------------------
// Seq 6: 
//
// Wrap Write with Small Data Width Transaction
// This sequence generates a wrap write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  2 bytes
//             Transaction Type: Write
//             Data Size:        2 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------

class wrap_wr_small_width_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(wrap_wr_small_width_txn)

  axi_seq_item req;

  function new(string name = "wrap_wr_small_width_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_wr_small_width_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == WRAP;
              size == 2;
              data.size == 2;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 2;
      req.addr = 32'h100;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : wrap_wr_small_width_txn



//------------------------------------------------------------------------------
// Seq 7: 
//
// Incremental Write with Mixed Data Sizes
// This sequence generates an incremental write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  1 to 4 bytes
//             Transaction Type: Write
//             Data Size:        Mixed
//             Number of Beats:  6
//------------------------------------------------------------------------------

class incr_wr_mixed_size_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(incr_wr_mixed_size_txn)

  axi_seq_item req;

  function new(string name = "incr_wr_mixed_size_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_wr_mixed_size_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == INCR;
              size inside {1, 2, 4};
              data.size inside {1, 2, 4};
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 6;
      req.addr = 32'h120;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : incr_wr_mixed_size_txn


//------------------------------------------------------------------------------
// Seq 8: 
//
// Fixed Write Single Small Beat Transaction
// This sequence generates a fixed write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  1 byte
//             Transaction Type: Write
//             Data Size:        1 byte
//             Number of Beats:  1
//------------------------------------------------------------------------------

class fixed_wr_single_small_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(fixed_wr_single_small_txn)

  axi_seq_item req;

  function new(string name = "fixed_wr_single_small_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("fixed_wr_single_small_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == FIXED;
              size == 1;
              data.size == 1;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 3;
      req.addr = 32'h140;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : fixed_wr_single_small_txn


//------------------------------------------------------------------------------
// Seq 9: 
//
// Incremental Write with Large Offset
// This sequence generates an incremental write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Offset:           Large
//             Number of Beats:  8
//------------------------------------------------------------------------------

class incr_wr_large_offset_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(incr_wr_large_offset_txn)

  axi_seq_item req;

  function new(string name = "incr_wr_large_offset_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_wr_large_offset_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == INCR;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 9;
      req.addr = 32'h8000;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : incr_wr_large_offset_txn



//------------------------------------------------------------------------------
// Seq 10: 
//
// Fixed Write with Alternating Beats
// This sequence generates a fixed write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  8
//             Alternating Pattern
//------------------------------------------------------------------------------

class fixed_wr_alt_beat_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(fixed_wr_alt_beat_txn)

  axi_seq_item req;

  function new(string name = "fixed_wr_alt_beat_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("fixed_wr_alt_beat_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == FIXED;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 11;
      req.addr = 32'h1A0;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : fixed_wr_alt_beat_txn


//------------------------------------------------------------------------------
// Seq 11: 
//
// Wrap Write with Non-Aligned Address
// This sequence generates a wrap write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  4
//             Address:          Non-Aligned
//------------------------------------------------------------------------------

class wrap_wr_non_aligned_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(wrap_wr_non_aligned_txn)

  axi_seq_item req;

  function new(string name = "wrap_wr_non_aligned_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_wr_non_aligned_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == WRAP;
              size == 4;
              data.size == 4;
              addr[1:0] != 2'b00; // Non-aligned address
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 5;
      req.addr = 32'h1C2;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : wrap_wr_non_aligned_txn


//------------------------------------------------------------------------------
// Seq 12: 
//
// Incremental Write with Random Address
// This sequence generates an incremental write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  4
//             Address:          Random
//------------------------------------------------------------------------------

class incr_wr_rand_addr_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(incr_wr_rand_addr_txn)

  axi_seq_item req;

  function new(string name = "incr_wr_rand_addr_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_wr_rand_addr_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == INCR;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 7;
      req.addr = $urandom_range(32'h1000, 32'h2000);
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : incr_wr_rand_addr_txn


//------------------------------------------------------------------------------
// Seq 13: 
//
// Wrap Write with Full Data Coverage
// This sequence generates a wrap write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  8
//------------------------------------------------------------------------------

class wrap_wr_full_data_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(wrap_wr_full_data_txn)

  axi_seq_item req;

  function new(string name = "wrap_wr_full_data_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_wr_full_data_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == WRAP;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 8;
      req.addr = 32'h300;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : wrap_wr_full_data_txn


//------------------------------------------------------------------------------
// Seq 14: 
//
// Fixed Write with Data Increment
// This sequence generates a fixed write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------

// class fixed_wr_seq_data_inc_txn extends axi_wr_addr_sequence;
//   `uvm_object_utils(fixed_wr_seq_data_inc_txn)

//   axi_seq_item req;

//   function new(string name = "fixed_wr_seq_data_inc_txn");
//     super.new(name);
//   endfunction

//   task body();
//     begin
//       wait_for_grant();
//       req = axi_seq_item::type_id::create("fixed_wr_seq_data_inc_req");
//       if (!req.randomize() with {
//               access == WRITE_TRAN;
//               burst == FIXED;
//               size == 4;
//               data.size == 4;
//           }) begin
//           `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
//       end
//       req.id = 10;
//       req.addr = 32'h400;
//       send_request(req);
//       wait_for_item_done();
//     end
//   endtask
// endclass : fixed_wr_seq_data_inc_txn


//------------------------------------------------------------------------------
// Seq 15: 
//
// Incremental Write with Variable Beat Count
// This sequence generates an incremental write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  Random (2-8)
//------------------------------------------------------------------------------

class incr_wr_var_beat_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(incr_wr_var_beat_txn)

  axi_seq_item req;

  function new(string name = "incr_wr_var_beat_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("incr_wr_var_beat_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == INCR;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 12;
      req.addr = 32'h500;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : incr_wr_var_beat_txn


//------------------------------------------------------------------------------
// Seq 16: 
//
// Wrap Write with Misaligned Address
// This sequence generates a wrap write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            WRAP
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  4
//             Address:          Misaligned
//------------------------------------------------------------------------------

class wrap_wr_misaligned_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(wrap_wr_misaligned_txn)

  axi_seq_item req;

  function new(string name = "wrap_wr_misaligned_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("wrap_wr_misaligned_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == WRAP;
              size == 4;
              data.size == 4;
              addr[1:0] == 2'b01; // Misaligned address
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 14;
      req.addr = 32'h5A1;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : wrap_wr_misaligned_txn


//------------------------------------------------------------------------------
// Seq 17: 
//
// Fixed Write with Alternating ID
// This sequence generates a fixed write Address transaction on the AXI Write Address Channel.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  4
//             ID:               Alternating
//------------------------------------------------------------------------------

class fixed_wr_alt_id_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(fixed_wr_alt_id_txn)

  axi_seq_item req;

  function new(string name = "fixed_wr_alt_id_txn");
    super.new(name);
  endfunction

  task body();
    begin
      wait_for_grant();
      req = axi_seq_item::type_id::create("fixed_wr_alt_id_req");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == FIXED;
              size == 4;
              data.size == 4;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = ($urandom() % 2) ? 6 : 9; // Alternating IDs
      req.addr = 32'h5F0;
      send_request(req);
      wait_for_item_done();
    end
  endtask
endclass : fixed_wr_alt_id_txn

//------------------------------------------------------------------------------
// Seq 18: 
//
// Single Beat Write with Multiple Transactions
// This sequence generates single beat write Address transactions on the AXI Write Address Channel.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: Write
//             Data Size:        4 bytes
//             Number of Beats:  1
//             Number of Transactions: Multiple
//------------------------------------------------------------------------------

class wr_single_beat_multi_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(wr_single_beat_multi_txn)

  axi_seq_item req;

  function new(string name = "wr_single_beat_multi_txn");
    super.new(name);
  endfunction

  task body();
    begin
      repeat (5) begin // Multiple transactions
        wait_for_grant();
        req = axi_seq_item::type_id::create("wr_single_beat_multi_req");
        if (!req.randomize() with {
                access == WRITE_TRAN;
                burst == FIXED;
                size == 4;
                data.size == 4;
            }) begin
            `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = $urandom_range(0, 15);
        req.addr = $urandom_range(32'h600, 32'h700);
        send_request(req);
        wait_for_item_done();
      end
    end
  endtask
endclass : wr_single_beat_multi_txn
































//------------------------------------------------------------------------------
// Seq 2:
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
// class incr_rd_addr_txn_len1 extends axi_rd_addr_sequence;
//   `uvm_object_utils(incr_rd_addr_txn_len1)

//   axi_seq_item req;

//   function new(string name = "incr_rd_addr_txn_len1");
//       super.new(name);
//   endfunction

//   task body();
//       wait_for_grant();
//       req = axi_seq_item::type_id::create("incr_rd_addr_req");
//       if (!req.randomize() with {
//               access == READ_TRAN;
//               burst == INCR;
//               size == 4;
//               data.size == 4;
//           }) begin
//           `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
//       end
//       req.id = 1;
//       req.addr = 32'h10;
//       send_request(req);
//       wait_for_item_done();
//   endtask
// endclass : incr_rd_addr_txn_len1

















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
class fixed_wr_seq_data_inc_txn extends axi_wr_addr_sequence;
  `uvm_object_utils(fixed_wr_seq_data_inc_txn)

  axi_seq_item req;

  function new(string name = "fixed_wr_seq_data_inc_txn");
      super.new(name);
  endfunction

  task body();
      for (int i = 1; i <= 4; i++) begin
          wait_for_grant();
          req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_data_inc_req_%0d", i));
          if (!req.randomize() with {
                  access == WRITE_TRAN;
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
endclass : fixed_wr_seq_data_inc_txn



`endif