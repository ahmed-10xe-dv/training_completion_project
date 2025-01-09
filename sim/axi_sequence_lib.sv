/*************************************************************************
   > File Name:   axi_sequence_lib.sv
   > Description: These are the sequences extended from base axi sequence
                  to test different cases
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


//------------------------------------------------------------------------------
// Basic Write Transaction
// This sequence generates a fixed write transaction on the AXI bus.
//------------------------------------------------------------------------------
class basic_write_txn extends axi_sequence;
    `uvm_object_utils(basic_write_txn) // Register with the UVM factory
  
    axi_seq_item req; // Sequence item for the write transaction
  
    // Constructor
    function new(string name = "basic_write_txn");
      super.new(name);
    endfunction
  
    // Main sequence body
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
            req.addr = 32'h10;
            
            // Send request and wait for completion
            send_request(req);
            wait_for_item_done();
    end
  
    endtask
  endclass : basic_write_txn
  
  
  //------------------------------------------------------------------------------
  // Basic Read Transaction
  // This sequence generates a fixed Read transaction on the AXI bus.
  //------------------------------------------------------------------------------
  class basic_read_txn extends axi_sequence;
    `uvm_object_utils(basic_read_txn) // Register with the UVM factory
  
    axi_seq_item req; // Sequence item for the Read transaction
  
    // Constructor
    function new(string name = "basic_read_txn");
      super.new(name);
    endfunction
  
    // Main sequence body
    task body();
            wait_for_grant();
            // Create and randomize sequence item
            req = axi_seq_item::type_id::create("Read_request");
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == INCR;
                    size == 4;
                    data.size == 16;
                }) begin
                `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
            end
            // Assign transaction details
            req.id = 6;
            req.addr = 32'h10;
            
            // Send request and wait for completion
            send_request(req);
            wait_for_item_done();
    endtask 
  endclass : basic_read_txn
  

  //------------------------------------------------------------------------------
  // Basic read write Transaction
  // This sequence generates a fixed read write transaction on the AXI bus.
  //------------------------------------------------------------------------------
  class basic_rd_wr_txn extends axi_sequence;
    `uvm_object_utils(basic_rd_wr_txn) // Register with the UVM factory
  
    axi_seq_item req; // Sequence item for the transaction
  
    // Constructor
    function new(string name = "basic_rd_wr_txn");
      super.new(name);
    endfunction
  
    // Main sequence body
    task body();
      begin
        wait_for_grant();
        // Create and randomize sequence item
        req = axi_seq_item::type_id::create("Read_request");
        if (!req.randomize() with {
                access == READ_TRAN;
                burst == FIXED;
                size == 4;
                data.size == 8;
            }) begin
            `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
        end
        // Assign transaction details
        req.id = 6;
        req.addr = 32'h15;
        
        // Send request and wait for completion
        send_request(req);
        wait_for_item_done();
      end

      begin
        wait_for_grant();
        // Create and randomize sequence item
        req = axi_seq_item::type_id::create("basic_rd_wr_txn");
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
endclass : basic_rd_wr_txn


//------------------------------------------------------------------------------
// Basic Inc Write Transaction
// This sequence generates a INc write transaction of size 16 bytes on the AXI bus.
//------------------------------------------------------------------------------
class basic_inc_write_txn extends axi_sequence;
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
// Basic Inc Read Transaction
// This sequence generates INCR read transaction on the AXI bus.
//------------------------------------------------------------------------------
class basic_inc_read_txn extends axi_sequence;
  `uvm_object_utils(basic_inc_read_txn) // Register with the UVM factory

  axi_seq_item req; // Sequence item for the write transaction

  // Constructor
  function new(string name = "basic_inc_read_txn");
    super.new(name);
  endfunction

  // Main sequence body
  task body();
    begin
          wait_for_grant();
          // Create and randomize sequence item
          req = axi_seq_item::type_id::create("basic_inc_read_request");
          if (!req.randomize() with {
                  access == READ_TRAN;
                  burst == INCR;
                  size == 4;
                  data.size == 16;
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
endclass : basic_inc_read_txn



//------------------------------------------------------------------------------
// Basic Inc Read Transaction
// This sequence generates INCR read transaction on the AXI bus.
//------------------------------------------------------------------------------
class basic_fixed_wr_txn extends axi_sequence;
  `uvm_object_utils(basic_fixed_wr_txn) // Register with the UVM factory

  axi_seq_item req; // Sequence item for the write transaction

  // Constructor
  function new(string name = "basic_fixed_wr_txn");
    super.new(name);
  endfunction

  // Main sequence body
  task body();
    begin
      for (int i = 0 ; i < 10 ; i++ ) begin
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
        req.id = i;
        req.addr = i*16;
        
        // Send request and wait for completion
        send_request(req);
        wait_for_item_done();
        
    end
  end

  endtask
endclass : basic_fixed_wr_txn


//------------------------------------------------------------------------------
// Basic Inc Read Transaction
// This sequence generates INCR read transaction on the AXI bus.
//------------------------------------------------------------------------------
class boundary_cross_txn extends axi_sequence;
  `uvm_object_utils(boundary_cross_txn) // Register with the UVM factory

  axi_seq_item req; // Sequence item for the write transaction

  // Constructor
  function new(string name = "boundary_cross_txn");
    super.new(name);
  endfunction

  // Main sequence body
  task body();
    begin
      wait_for_grant();
      // Create and randomize sequence item
      req = axi_seq_item::type_id::create("Write_request");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == INCR;
              size == 8;
              data.size == 32;
          }) begin
          `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      // Assign transaction details
      req.id = 4;
      req.addr = 32'h7f0;
      
      // Send request and wait for completion
      send_request(req);
      wait_for_item_done();

end


  endtask
endclass : boundary_cross_txn


//------------------------------------------------------------------------------
// Basic Inc Read Transaction
// This sequence generates INCR read transaction on the AXI bus.
//------------------------------------------------------------------------------
class basic_wrap4_wr_txn extends axi_sequence;
  `uvm_object_utils(basic_wrap4_wr_txn) // Register with the UVM factory

  axi_seq_item req; // Sequence item for the write transaction

  // Constructor
  function new(string name = "basic_wrap4_wr_txn");
    super.new(name);
  endfunction

  // Main sequence body
  task body();
    begin
      wait_for_grant();
      // Create and randomize sequence item
      req = axi_seq_item::type_id::create("Write_request");
      if (!req.randomize() with {
              access == WRITE_TRAN;
              burst == WRAP;
              size == 4;
              data.size == 16;
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

  endtask
endclass : basic_wrap4_wr_txn


//------------------------------------------------------------------------------
// Basic Inc Read Transaction
// This sequence generates INCR read transaction on the AXI bus.
//------------------------------------------------------------------------------
class basic_fixed_wr_txn_with_holes extends axi_sequence;
  `uvm_object_utils(basic_fixed_wr_txn_with_holes) // Register with the UVM factory

  axi_seq_item req; // Sequence item for the write transaction

  // Constructor
  function new(string name = "basic_fixed_wr_txn_with_holes");
    super.new(name);
  endfunction

  // Main sequence body
  task body();
    begin
      for (int i = 0 ; i < 10 ; i++ ) begin
        wait_for_grant();
        // Create and randomize sequence item
        req = axi_seq_item::type_id::create("Write_request");
        if (!req.randomize() with {
                access == WRITE_TRAN;
                burst == FIXED;
                size == 4;
                data.size == 10;
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
endclass : basic_fixed_wr_txn_with_holes




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