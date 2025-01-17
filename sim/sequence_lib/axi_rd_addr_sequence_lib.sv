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

class fix_rd_addr_txn_beat1 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_txn_beat1) // Register with the UVM factory
  
    axi_seq_item req; // Sequence item for the Read transaction
  
    // Constructor
    function new(string name = "fix_rd_addr_txn_beat1");
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
                   ar_valid == 1;
                   data.size == 4;
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            // Assign transaction details
            req.id = 7;
            req.addr = 32'h805;
            
            // Send request and wait for completion
            send_request(req);
            wait_for_item_done();

            wait_for_grant();
            req.ar_valid = 0;
            send_request(req);
            wait_for_item_done();
    
    end
  
    endtask
  endclass : fix_rd_addr_txn_beat1


//------------------------------------------------------------------------------
// Seq 2:
//
// FIXED Burst with length 2
// This sequence generates a FIXED burst read Address transaction with 2 beats.
// It contains:
//             Burst:            FIXED
//             Data Lane Width:  4 bytes
//             Transaction Type: read
//             Data Size:        4 bytes
//             Number of Beats:  1 per transaction
//------------------------------------------------------------------------------
class fix_rd_addr_txn_beat2 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_txn_beat2)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_txn_beat2");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 1; i <= 2; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req_%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 4;
                   ar_valid == 1;
                   data.size == 4; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = 4 + i;
            req.addr = 32'h100 + (i * 4);
            send_request(req);
            wait_for_item_done();
        end
        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_txn_beat2
  
  //------------------------------------------------------------------------------
  // Seq 3:
  //
  // FIXED Burst with transactions 16
  // This sequence generates a FIXED burst read Address transaction with 16 beats.
  // It contains:
  //             Burst:            FIXED
  //             Data Lane Width:  4 bytes
  //             Transaction Type: read
  //             Data Size:        4 bytes
  //             Number of Beats:  1 per transaction
  //------------------------------------------------------------------------------
  class fix_rd_addr_txn_beat16 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_txn_beat16)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_txn_beat16");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 0; i <= 15; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 4;
                   ar_valid == 1;
                   data.size == 4; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = i;
            req.addr = 32'hDEAD + (i * 4);
            send_request(req);
            wait_for_item_done();
        end

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_txn_beat16
  
  
  //------------------------------------------------------------------------------
  // Seq 4:
  //
  // FIXED Burst with transactions greater than 16
  // This sequence generates a FIXED burst read Address transaction with more than 16 beats.
  // It contains:
  //             Burst:            FIXED
  //             Data Lane Width:  4 bytes
  //             Transaction Type: read
  //             Data Size:        4 bytes
  //             Number of Beats:  1 per transaction
  //------------------------------------------------------------------------------
  class fix_rd_addr_txn_beat19 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_txn_beat19)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_txn_beat19");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 0; i <= 18; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 4;
                   ar_valid == 1;
                   data.size == 4; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = i;
            req.addr = 32'hfacc + (i * 4);
            send_request(req);
            wait_for_item_done();
        end

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_txn_beat19
  
  //------------------------------------------------------------------------------
  // Seq 5:
  //
  // FIXED Burst narrow transfer with transactions 15
  // This sequence generates a FIXED burst read Address Narrow transaction with 15x1 beats.
  // It contains:
  //             Burst:            FIXED
  //             Data Lane Width:  1 byte
  //             Transaction Type: read
  //             Data Size:        1 bytes
  //             Number of Beats:  1 per transaction
  //------------------------------------------------------------------------------
  class fix_rd_addr_nrw1_txn_beat15 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_nrw1_txn_beat15)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_nrw1_txn_beat15");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 0; i <= 15; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 1;
                   ar_valid == 1;
                   data.size == 1; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = i;
            req.addr = 32'ha67cb4 + (i * 4);
            send_request(req);
            wait_for_item_done();
        end

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_nrw1_txn_beat15
  
  //------------------------------------------------------------------------------
  // Seq 6:
  //
  // FIXED Burst narrow transfer with transactions 15
  // This sequence generates a FIXED burst read Address Narrow transaction with 15x4 beats.
  // It contains:
  //             Burst:            FIXED
  //             Data Lane Width:  1 byte
  //             Transaction Type: read
  //             Data Size:        4 bytes
  //             Number of Beats:  4 per transaction
  //------------------------------------------------------------------------------
  class fix_rd_addr_nrw1_txn_beat15x4 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_nrw1_txn_beat15x4)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_nrw1_txn_beat15x4");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 0; i <= 15; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 1;
                   ar_valid == 1;
                   data.size == 4; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = i;
            req.addr = 32'h04 + (i * 4);
            send_request(req);
            wait_for_item_done();
        end

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_nrw1_txn_beat15x4
  
  
  
  //------------------------------------------------------------------------------
  // Seq 7:
  //
  // FIXED Burst narrow transfer with transactions 15
  // This sequence generates a FIXED burst read Address Narrow transaction with 15x1 beats.
  // It contains:
  //             Burst:            FIXED
  //             Data Lane Width:  2 byte
  //             Transaction Type: read
  //             Data Size:        2 bytes
  //             Number of Beats:  1 per transaction
  //------------------------------------------------------------------------------
  class fix_rd_addr_nrw2_txn_beat15 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_nrw2_txn_beat15)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_nrw2_txn_beat15");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 0; i <= 15; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 2;
                   ar_valid == 1;
                   data.size == 2; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = i;
            req.addr = 32'h74 + (i * 4);
            send_request(req);
            wait_for_item_done();
        end

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_nrw2_txn_beat15
  
  //------------------------------------------------------------------------------
  // Seq 8:
  //
  // FIXED Burst narrow transfer with transactions 15
  // This sequence generates a FIXED burst read Address Narrow transaction with 15x2 beats.
  // It contains:
  //             Burst:            FIXED
  //             Data Lane Width:  2 byte
  //             Transaction Type: read
  //             Data Size:        4 bytes
  //             Number of Beats:  2 per transaction
  //------------------------------------------------------------------------------
  class fix_rd_addr_nrw2_txn_beat15x2 extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_nrw2_txn_beat15x2)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_nrw2_txn_beat15x2");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 0; i <= 15; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 2;
                   ar_valid == 1;
                   data.size == 4; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = i;
            req.addr = 32'h70 + (i * 4);
            send_request(req);
            wait_for_item_done();
        end

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_nrw2_txn_beat15x2
  
  
  //------------------------------------------------------------------------------
  // Seq 9:
  //
  // FIXED Burst with length 2
  // This sequence generates a FIXED burst read Address transaction with 2 beats.
  // It contains:
  //             Burst:            FIXED
  //             Data Lane Width:  4 bytes
  //             Transaction Type: read
  //             Data Size:        4 bytes
  //             Number of Beats:  1 per transaction
  //------------------------------------------------------------------------------
  class fix_rd_addr_txn_beat2_unaligned extends axi_rd_addr_sequence;
    `uvm_object_utils(fix_rd_addr_txn_beat2_unaligned)
  
    axi_seq_item req;
  
    function new(string name = "fix_rd_addr_txn_beat2_unaligned");
        super.new(name);
    endfunction
  
    task body();
        for (int i = 1; i <= 2; i++) begin
            wait_for_grant();
            req = axi_seq_item::type_id::create($sformatf("fixed_rd_seq_req%0d", i));
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 4;
                    ar_valid == 1;
                    data.size == 4; 
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            req.id = 4 + i;
            req.addr = 32'h102 + (i * 4);
            send_request(req);
            wait_for_item_done();
        end
        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : fix_rd_addr_txn_beat2_unaligned


//------------------------------------------------------------------------------
// Seq 10:
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
              ar_valid == 1;
              data.size == 4;
          }) begin
          `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 1;
      req.addr = 32'h10;
      send_request(req);
      wait_for_item_done();

      wait_for_grant();
      req.ar_valid = 0;
      send_request(req);
      wait_for_item_done();

  endtask
endclass : incr_rd_addr_txn_len1


//------------------------------------------------------------------------------
// Seq 11:
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
              ar_valid == 1;
              data.size == 8; // 2 beats * 4 bytes each
          }) begin
          `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
      end
      req.id = 1;
      req.addr = 32'h30;
      send_request(req);
      wait_for_item_done();

      wait_for_grant();
      req.ar_valid = 0;
      send_request(req);
      wait_for_item_done();

  endtask
endclass : incr_rd_addr_txn_len2

  
  
  //------------------------------------------------------------------------------
  // Seq 12:
  //
  // INCR Read Address Transaction With Length 4
  // This sequence generates an INCR burst Read Address transaction of len 4 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  4 bytes
  //             Transaction Type: Read
  //             Data Size:        16 bytes
  //             Number of Beats:  4
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_len4 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_len4)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_len4");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                ar_valid == 1;
                data.size == 16;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 6;
        req.addr = 32'h34;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_len4
  
  
  //------------------------------------------------------------------------------
  // Seq 13:
  //
  // INCR Read Address Transaction With Length 8
  // This sequence generates an INCR burst Read Address transaction of len 8 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  4 bytes
  //             Transaction Type: Read
  //             Data Size:        32 bytes
  //             Number of Beats:  8
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_len8 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_len8)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_len8");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                data.size == 32;
                ar_valid==1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 6;
        req.addr = 32'h64;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_len8
  
  
  //------------------------------------------------------------------------------
  // Seq 14:
  //
  // INCR Read Address Transaction With Length 16
  // This sequence generates an INCR burst Read Address transaction of len 16 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  4 bytes
  //             Transaction Type: Read
  //             Data Size:        64 bytes
  //             Number of Beats:  16
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_len16 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_len16)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_len16");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                ar_valid == 1;
                data.size == 64;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 7;
        req.addr = 32'h74;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_len16
  
  
  //------------------------------------------------------------------------------
  // Seq 15:
  //
  // INCR Read Address Transaction With Length 50
  // This sequence generates an INCR burst Read Address transaction of len 50 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  4 bytes
  //             Transaction Type: Read
  //             Data Size:        198 bytes
  //             Number of Beats:  50
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_len50 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_len50)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_len50");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                ar_valid == 1;
                data.size == 198;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 6;
        req.addr = 32'h620;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_len50
  
  
  //------------------------------------------------------------------------------
  // Seq 16:
  //
  // INCR Read Address Transaction With Length 13
  // This sequence generates an INCR burst Read Address transaction of len 13 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  4 bytes
  //             Transaction Type: Read
  //             Data Size:        49 bytes
  //             Number of Beats:  13
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_len13 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_len13)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_len13");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                ar_valid == 1;
                data.size == 49;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 9;
        req.addr = 32'h224;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_len13
  
  
  
  //------------------------------------------------------------------------------
  // Seq 17:
  //
  // INCR Read Address Transaction With Length 5
  // This sequence generates an INCR burst Read Address transaction of len 5 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  4 bytes
  //             Transaction Type: Read
  //             Data Size:        19 bytes
  //             Number of Beats:  5
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_len5 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_len5)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_len5");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                ar_valid == 1;
                data.size == 19;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 15;
        req.addr = 32'h90;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_len5
  
  //------------------------------------------------------------------------------
  // Seq 18:
  //
  // INCR Read Address Narrow Transaction With Length 256
  // This sequence generates an INCR burst Read Address transaction of len 256 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  1 bytes
  //             Transaction Type: Read
  //             Data Size:        256 bytes
  //             Number of Beats:  256
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_len256 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_len256)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_len256");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                ar_valid == 1;
                data.size == 1024;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 10;
        req.addr = 32'h7ff0;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_len256
  
  //------------------------------------------------------------------------------
  // Seq 19:
  //
  // INCR Read Address Narrow Transaction With Length 4
  // This sequence generates an INCR burst Read Address transaction of len 4 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  1 bytes
  //             Transaction Type: Read
  //             Data Size:        4 bytes
  //             Number of Beats:  4
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_nrw1 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_nrw1)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_nrw1");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 1;
                ar_valid == 1;
                data.size == 4;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 1;
        req.addr = 32'h19;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_nrw1
  
  
  //------------------------------------------------------------------------------
  // Seq 20:
  //
  // INCR Read Address Transaction With Length 256
  // This sequence generates an INCR burst Read Address transaction of len 256 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  4 bytes
  //             Transaction Type: Read
  //             Data Size:        1024 bytes
  //             Number of Beats:  256
  //------------------------------------------------------------------------------
  class incr_rd_addr_nrw1_txn_len256 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_nrw1_txn_len256)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_nrw1_txn_len256");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 1;
                ar_valid == 1;
                data.size == 256;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 4;
        req.addr = 32'hDEAD1234;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_nrw1_txn_len256
  
  
  //------------------------------------------------------------------------------
  // Seq 21:
  //
  // INCR Read Address Narrow Transaction With Length 8
  // This sequence generates an INCR burst Read Address transaction of len 8 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  2 bytes
  //             Transaction Type: Read
  //             Data Size:        15 bytes
  //             Number of Beats:  8
  //------------------------------------------------------------------------------
  class incr_rd_addr_nrw2_txn_len8 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_nrw2_txn_len8)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_nrw2_txn_len8");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 2;
                ar_valid == 1;
                data.size == 15;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 8;
        req.addr = 32'h10000049;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_nrw2_txn_len8
  
  
  //------------------------------------------------------------------------------
// Seq 22: 
//
// Incremental read with Mixed Data Sizes
// This sequence generates an incremental read Address transaction on the AXI read Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  1 to 4 bytes
//             Transaction Type: read
//             Data Size:        Mixed
//             Number of Beats:  6
//------------------------------------------------------------------------------

class incr_rd_mixed_size_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_mixed_size_txn)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_mixed_size_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_mixed_size_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                ar_valid == 1;
                size inside {1, 2, 4};
                data.size inside {1, 2, 4};
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 6;
        req.addr = 32'hcaf4;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : incr_rd_mixed_size_txn
  
  
  
  //------------------------------------------------------------------------------
  // Seq 23:
  //
  // INCR Read Address Narrow Transaction With Length 2
  // This sequence generates an INCR burst Read Address transaction of len 2 on the AXI Read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  2 bytes
  //             Transaction Type: Read
  //             Data Size:        4 bytes
  //             Number of Beats:  2
  //------------------------------------------------------------------------------
  class incr_rd_addr_txn_nrw2 extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_nrw2)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_nrw2");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 2;
                ar_valid == 1;
                data.size == 4;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 6;
        req.addr = 32'hBABC;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_nrw2
  

  
//------------------------------------------------------------------------------
// Seq 24:
//
// INCR Read Address Transaction that crosses 1KB boundary on AHB side With Length 2
// This sequence generates an INCR burst Read Address transaction of len 2 on the AXI Read Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: Read
//             Data Size:        16 bytes
//             Number of Beats:  4
//------------------------------------------------------------------------------
class incr_rd_addr_txn_1kb_cross extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_txn_1kb_cross)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_txn_1kb_cross");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                data.size == 16;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 9;
        req.addr = 32'h7F8;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_txn_1kb_cross



//------------------------------------------------------------------------------
// Seq 25:
//
// INCR read Address Transaction With Length 2 and unaligned address
// This sequence generates an INCR burst read Address transaction of len 2 on the AXI read Address Channel.
// It contains:
//             Burst:            INCR
//             Data Lane Width:  4 bytes
//             Transaction Type: read
//             Data Size:        8 bytes
//             Number of Beats:  2
//------------------------------------------------------------------------------
class incr_rd_addr_unaligned_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_unaligned_txn)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_unaligned_txn");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 4;
                data.size == 8;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 4;
        req.addr = 32'h42;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_unaligned_txn
  
  
  //------------------------------------------------------------------------------
  // Seq 26:
  //
  // INCR read Address Narrow Transaction With Length 2 and unaligned address
  // This sequence generates an INCR burst read Address transaction of len 2 on the AXI read Address Channel.
  // It contains:
  //             Burst:            INCR
  //             Data Lane Width:  2 bytes
  //             Transaction Type: read
  //             Data Size:        8 bytes
  //             Number of Beats:  4
  //------------------------------------------------------------------------------
  class incr_rd_addr_nrw_unaligned_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(incr_rd_addr_nrw_unaligned_txn)
  
    axi_seq_item req;
  
    function new(string name = "incr_rd_addr_nrw_unaligned_txn");
        super.new(name);
    endfunction
  
    task body();
        wait_for_grant();
        req = axi_seq_item::type_id::create("incr_rd_addr_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == INCR;
                size == 2;
                data.size == 8;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 9;
        req.addr = 32'hFF1;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

    endtask
  endclass : incr_rd_addr_nrw_unaligned_txn
  
  
  //------------------------------------------------------------------------------
  // Seq 27: 
  //
  // WRAP2 read with Data Width 4
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  4 bytes
  //             Transaction Type: read
  //             Data Size:        8 bytes
  //             Number of Beats:  2
  //------------------------------------------------------------------------------
  
  class wrp2_rd_addr_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp2_rd_addr_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp2_rd_addr_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("WRAP_rd_full_data_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 4;
                data.size == 8;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 6;
        req.addr = 32'h99a00;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : wrp2_rd_addr_txn
  
  
  
  //------------------------------------------------------------------------------
  // Seq 28: 
  //
  // WRAP2 read with Data Width 4
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  4 bytes
  //             Transaction Type: read
  //             Data Size:        16 bytes
  //             Number of Beats:  4
  //------------------------------------------------------------------------------
  
  class wrp4_rd_addr_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp4_rd_addr_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp4_rd_addr_txn");
      super.new(name);
    endfunction
    
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("WRAP_rd_full_data_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 4;
                data.size == 16;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 4;
        req.addr = 32'h35800;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
endclass : wrp4_rd_addr_txn
  
  
    //------------------------------------------------------------------------------
  // Seq 29: 
  //
  // WRAP8 read with Data Width 4
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  4 byte
  //             Transaction Type: read
  //             Data Size:        32 bytes
  //             Number of Beats:  8
  //------------------------------------------------------------------------------
  
  class wrp8_rd_addr_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp8_rd_addr_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp8_rd_addr_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("wrp8_rd_addr_txn_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 4;        // Data lane width: 4 byte
                data.size == 32;   // Total transaction size: 8 bytes
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 1;
        req.addr = 32'h8ba600;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : wrp8_rd_addr_txn
  
  
  //------------------------------------------------------------------------------
  // Seq 30: 
  //
  // WRAP16 read with Data Width 4
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  4 bytes
  //             Transaction Type: read
  //             Data Size:        64 bytes
  //             Number of Beats:  16
  //------------------------------------------------------------------------------
  
  class wrp16_rd_addr_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp16_rd_addr_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp16_rd_addr_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("wrp16_rd_addr_txn_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 4;        // Data lane width: 4 bytes
                data.size == 64;  // Total transaction size: 64 bytes
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 15;
        req.addr = 32'h3482a0;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : wrp16_rd_addr_txn
  
  
  //------------------------------------------------------------------------------
  // Seq 31: 
  //
  // WRAP2 read with Data Width 1
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  1 byte
  //             Transaction Type: read
  //             Data Size:        2 bytes
  //             Number of Beats:  2
  //------------------------------------------------------------------------------
  
  class wrp2_rd_addr_nrw1_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp2_rd_addr_nrw1_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp2_rd_addr_nrw1_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("wrp2_rd_addr_nrw1_txn_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 1;
                data.size == 2;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 14;
        req.addr = 32'h3876b0;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : wrp2_rd_addr_nrw1_txn
  
  
  
  //------------------------------------------------------------------------------
  // Seq 32: 
  //
  // WRAP2 read with Data Width 2
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  2 bytes
  //             Transaction Type: read
  //             Data Size:        8 bytes
  //             Number of Beats:  4
  //------------------------------------------------------------------------------
  
  class wrp4_rd_addr_nrw2_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp4_rd_addr_nrw2_txn)
  
    axi_seq_item req;
    function new(string name = "wrp4_rd_addr_nrw2_txn");
      super.new(name);
    endfunction
    
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("WRAP_rd_full_data_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 2;
                data.size == 8;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 13;
        req.addr = 32'hcba890;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
endclass : wrp4_rd_addr_nrw2_txn
  
  
  //------------------------------------------------------------------------------
  // Seq 33: 
  //
  // WRAP8 read with Data Width 2
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  2 byte
  //             Transaction Type: read
  //             Data Size:        16 bytes
  //             Number of Beats:  8
  //------------------------------------------------------------------------------
  
  class wrp8_rd_addr_nrw2_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp8_rd_addr_nrw2_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp8_rd_addr_nrw2_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("wrp8_rd_addr_nrw2_txn_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 2;        // Data lane width: 2 byte
                data.size == 16;   // Total transaction size: 16 bytes
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 12;
        req.addr = 32'h5670c;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : wrp8_rd_addr_nrw2_txn
  
  
  //------------------------------------------------------------------------------
  // Seq 34: 
  //
  // WRAP16 read with Data Width 1
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  1 byte
  //             Transaction Type: read
  //             Data Size:        64 bytes
  //             Number of Beats:  16
  //------------------------------------------------------------------------------
  
  class wrp16_rd_addr_nrw1_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp16_rd_addr_nrw1_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp16_rd_addr_nrw1_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("wrp16_rd_addr_nrw1_txn_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 1;        // Data lane width: 1 byte
                data.size == 16;  // Total transaction size: 16 bytes
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 10;
        req.addr = 32'h7542300;
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : wrp16_rd_addr_nrw1_txn
  
  
  
  
  //------------------------------------------------------------------------------
  // Seq 35: 
  //
  // WRAP read with Misaligned Address
  // This sequence generates a WRAP read Address transaction on the AXI read Address Channel.
  // It contains:
  //             Burst:            WRAP
  //             Data Lane Width:  4 bytes
  //             Transaction Type: read
  //             Data Size:        16 bytes
  //             Number of Beats:  4
  //             Address:          Misaligned
  //------------------------------------------------------------------------------
  
  class wrp4_rd_addr_misaligned_txn extends axi_rd_addr_sequence;
    `uvm_object_utils(wrp4_rd_addr_misaligned_txn)
  
    axi_seq_item req;
  
    function new(string name = "wrp4_rd_addr_misaligned_txn");
      super.new(name);
    endfunction
  
    task body();
      begin
        wait_for_grant();
        req = axi_seq_item::type_id::create("WRAP_rd_misaligned_req");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == WRAP;
                size == 4;
                data.size == 16;
                ar_valid == 1;
            }) begin
            `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
        end
        req.id = 9;
        req.addr = 32'h5bbA1;  // Misaligned address
        send_request(req);
        wait_for_item_done();

        wait_for_grant();
        req.ar_valid = 0;
        send_request(req);
        wait_for_item_done();

      end
    endtask
  endclass : wrp4_rd_addr_misaligned_txn
`endif