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
  ahb_seq_item rsp;
  mem_model_pkg::mem_model#(bus_params_pkg::BUS_AW, bus_params_pkg::BUS_DW, bus_params_pkg::BUS_DBW) mem;


  //------------------------------------------------------------------------------
  // Constructor: new
  // Default constructor with an optional name parameter.
  //------------------------------------------------------------------------------
  function new(string name = "ahb_sequence");
    super.new(name);
    mem = mem_model_pkg::mem_model#(bus_params_pkg::BUS_AW, bus_params_pkg::BUS_DW, bus_params_pkg::BUS_DBW)::type_id::create("mem");
  endfunction


  //------------------------------------------------------------------------------
  // Task: pre-body
  // Initializes memory
  //------------------------------------------------------------------------------
  task pre_body();
    // Populate memory with randomized data
    for (int i = 0; i < 4096; i++) begin  // Corrected loop condition
       bit [7:0] data = $urandom;        // Generate random 8-bit data
       mem.write_byte(i, data);          // Write random data to memory at address 'i'
    end
   `uvm_info(get_name(), "Memory Initialized", UVM_LOW)
  endtask


  //------------------------------------------------------------------------------
  // Task: body
  // Generates and sends sequence items in a loop.
  //------------------------------------------------------------------------------
  task body();

    req = ahb_seq_item::type_id::create("req");
    rsp = ahb_seq_item::type_id::create("rsp");

    // Have to do it in forever block
    // forever begin
    repeat (10) begin
      start_item(req);  
      finish_item(req);

      req.print();

      // if (req.HTRANS_o[1]) begin
              // Perform write or read operation based on request
        if (req.ACCESS_o == write) begin
            `uvm_info("AHB Write Transaction", 
            $sformatf("Writing to address %0h: data %0h", req.HADDR_o, 
            req.HWDATA_o), UVM_LOW)
            req.HREADY_i <= 1'b1;
            req.RESP_i <= okay;
        end
        else begin
            `uvm_info("AHB Read Transaction",
            $sformatf("Reading from address %0h", req.HADDR_o), UVM_LOW)
            req.HRDATA_i = mem.read(req.HADDR_o);
            `uvm_info("DATA_SEQ", $sformatf("Read from address %0h Data is:%0h ",
            req.HADDR_o, req.HRDATA_i), UVM_LOW)
        end
      // end 
      // else `uvm_info("AHB SEQ", $sformatf("Slave is busy or IDLE HTRANS is:%0b ", req.HTRANS_o), UVM_LOW)

      start_item(rsp);
      rsp.copy(req);
      finish_item(rsp);
    end
     
  endtask
endclass : ahb_sequence

`endif // AHB_SEQ
