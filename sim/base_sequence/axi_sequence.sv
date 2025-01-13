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
              // wait_for_grant();
              // // Create and randomize sequence item
              // req = axi_seq_item::type_id::create("Write_request");
              // if (!req.randomize() with {
              //         access == WRITE_TRAN;
              //         burst == FIXED;
              //         size == 4;
              //         data.size == 4;
              //     }) begin
              //     `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
              // end
              // // Assign transaction details
              // req.id = 4;
              // req.addr = 32'hc;
              
              // // Send request and wait for completion
              // send_request(req);
              // wait_for_item_done();
              // req.print();
      end


      begin
              wait_for_grant();
              // Create and randomize sequence item
              req = axi_seq_item::type_id::create("Read_request");
              if (!req.randomize() with {
                      access == READ_TRAN;
                      burst == INCR;
                      size == 4;
                      data.size == 16;
                  }) begin
                  `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
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

`endif