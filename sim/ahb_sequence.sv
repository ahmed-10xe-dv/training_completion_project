// /*************************************************************************
//    > File Name:   ahb_sequence.sv
//    > Description: This class extends uvm_sequence to generate AHB sequence items.
//    > Author:      Ahmed Raza
//    > Modified:    Ahmed Raza
//    > Mail:        ahmed.raza@10xengineers.ai
//    ---------------------------------------------------------------
//    Copyright   (c)2024 10xEngineers
//    ---------------------------------------------------------------
// ************************************************************************/


`ifndef AHB_SEQUENCE
`define AHB_SEQUENCE

class ahb_sequence extends uvm_sequence #(ahb_seq_item);
  `uvm_object_utils(ahb_sequence)

  // Sequence item handle
  ahb_seq_item req;

  //------------------------------------------------------------------------------
  // Constructor: new
  // Default constructor with an optional name parameter.
  //------------------------------------------------------------------------------
  function new(string name = "ahb_sequence");
    super.new(name);
  endfunction

  //------------------------------------------------------------------------------
  // Task: body
  // Generates and sends sequence items in a loop.
  //------------------------------------------------------------------------------
  task body();
    // repeat (4) begin
      wait_for_grant();
      req = ahb_seq_item::type_id::create("Write Request");
      if (!req.randomize() with {
        access == write;
        resp == okay;
        }) begin
      `uvm_error(get_full_name(), "REQ Randomization Failed @axi_sequence")
      end
      
      send_request(req);
      req.print();
      wait_for_item_done();
    // end
  endtask
endclass : ahb_sequence

`endif // AHB_SEQ
