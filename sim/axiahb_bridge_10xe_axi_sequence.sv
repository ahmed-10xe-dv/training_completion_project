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
          for (int i = 1; i < 5; i++) begin
              // Wait for sequence item grant
              wait_for_grant();
              $display("REQUEST GRANTED FOR WRITE TRANSACTION");

              // Create and randomize sequence item
              req = axi_seq_item::type_id::create("write_request");
              if (!req.randomize() with {
                      access == WRITE_TRAN;
                      burst == FIXED;
                      size == 4;
                      data.size == 512;
                  }) begin
                  `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
              end
              // Assign transaction details
              req.id = i;
              req.addr = (i) * 16;
              
              // Send request and wait for completion
              send_request(req);
              wait_for_item_done();
          end

        //   begin
        //     repeat (2) begin
        //       get_response(rsp);
        //       rsp.print();
        //     end
        //   end


        //   for (int i = 1; i < 15; i++) begin
        //     wait_for_grant();
        //     $display("REQUEST GRANTED FOR READ TRANSACTION");
        //     req = axi_seq_item::type_id::create("read request");
        //     if(!req.randomize() with {access == READ_TRAN; burst == INCR; size == 4; data.size == 32;})
        //       `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
        //     req.id = i;
        //     req.addr = (i - 1) * 16;
        //     send_request(req);
        //     wait_for_item_done();
        //   end


      end
  endtask // body

endclass // axi_sequence

`endif