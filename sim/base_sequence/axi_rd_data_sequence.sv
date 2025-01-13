/*************************************************************************
   > File Name:   axi_rd_data_sequence.sv
   > Description: The axi_rd_data_sequence class is a UVM sequence that generates and sends 
                  AXI READ Data transaction, to the driver for simulation. It ensures randomized 
                  and controlled AXI protocol operations for verification scenarios.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_READ_DATA_SEQUENCE
`define AXI_READ_DATA_SEQUENCE

class axi_rd_data_sequence extends uvm_sequence #(axi_seq_item);
  `uvm_object_utils(axi_rd_data_sequence)

  // Constructor
  function new(string name = "axi_rd_data_sequence");
      super.new(name);
  endfunction

  // Task: Body
  task body();
      begin
              wait_for_grant();
              // Create and randomize sequence item
              req = axi_seq_item::type_id::create("Read_Data_Request");
              if (!req.randomize() with {
                      access == READ_TRAN;
                      rready == 1;
                  }) begin
                  `uvm_error(get_name(), "REQ Randomization Failed @axi_rd_data_sequence")
              end
              // Send request and wait for completion
              send_request(req);
              wait_for_item_done();
      end

  endtask // body

endclass // axi_rd_data_sequence

`endif