/*************************************************************************
   > File Name:   axi_rd_addr_sequence.sv
   > Description: The axi_rd_addr_sequence class is a UVM sequence that generates and sends AXI READ transactions, 
                  to the driver for simulation. It ensures randomized 
                  and controlled AXI protocol operations for verification scenarios.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_RD_ADDR_SEQUENCE
`define AXI_RD_ADDR_SEQUENCE

class axi_rd_addr_sequence extends uvm_sequence #(axi_seq_item);
  `uvm_object_utils(axi_rd_addr_sequence)

  // Constructor
  function new(string name = "axi_rd_addr_sequence");
      super.new(name);
  endfunction

  // Task: Body
  task body();
      begin
        for (int i = 0; i < 5 ; i++ ) begin
            wait_for_grant();
            `uvm_info(get_name(), "Running Base Test ", UVM_LOW)
            
            // Create and randomize sequence item
            req = axi_seq_item::type_id::create("basic_rd_addr_req");
            if (!req.randomize() with {
                    access == READ_TRAN;
                    burst == FIXED;
                    size == 4;
                    data.size == 4;
                }) begin
                `uvm_error(get_name(), "REQ Randomization Failed @axi_sequence")
            end
            // Assign transaction details
            req.id = i+1;
            req.addr = (i+4)*16;
            
            // Send request and wait for completion
            send_request(req);
            wait_for_item_done();
          end
      end

  endtask // body

endclass // axi_rd_addr_sequence

`endif