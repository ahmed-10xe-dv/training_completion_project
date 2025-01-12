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

  // Sequence item handle and Memory Handle
  ahb_seq_item req;
  ahb_seq_item rsp;
  // int Transactions_Count;
  // mem_model_pkg::mem_model#(bus_params_pkg::BUS_AW, bus_params_pkg::BUS_DW, bus_params_pkg::BUS_DBW) mem;
  // string scope_name = "";


  //------------------------------------------------------------------------------
  // Constructor: new
  // Default constructor with an optional name parameter.
  //------------------------------------------------------------------------------
  function new(string name = "ahb_sequence");
    super.new(name);
    // mem = mem_model_pkg::mem_model#(bus_params_pkg::BUS_AW, bus_params_pkg::BUS_DW, bus_params_pkg::BUS_DBW)::type_id::create("mem");
  endfunction


  //------------------------------------------------------------------------------
  // Task: body
  // Slave Sequence Method Implemented
  //------------------------------------------------------------------------------
  task body();

    // configurations m_config;
 
    // if( scope_name == "" ) begin
    //   scope_name = get_full_name(); // this is { sequencer.get_full_name() , get_name() }
    // end
 
    // if( !uvm_config_db #( int )::get( null , scope_name , "Transactions_Count" , Transactions_Count ) ) begin
    //   `uvm_error(get_name(), 
    //   $sformatf("Got no Configuration at this path: %s", scope_name))
    // end

    req = ahb_seq_item::type_id::create("req");
    rsp = ahb_seq_item::type_id::create("rsp");

    // repeat (Transactions_Count + 1) begin
      forever begin
      // Send a dummy request
      // req = ahb_seq_item::type_id::create("req");
      // rsp = ahb_seq_item::type_id::create("rsp");

      start_item(req);  
      finish_item(req);

        // Perform write or read operation based on DUT response
        if (req.ACCESS_o == write) begin
            `uvm_info("AHB Write Transaction", 
            $sformatf("Writing to address %0h: data %0h", req.HADDR_o, 
            req.HWDATA_o), UVM_LOW)
            req.RESP_i <= okay;
        end
        else begin
            `uvm_info("AHB Read Transaction",
            $sformatf("Reading from address %0h", req.HADDR_o), UVM_LOW)

            // case (req.HSIZE_o)
            //   0: req.HRDATA_i = $urandom() & 8'hFF;           // (1 byte)
            //   1: req.HRDATA_i = $urandom() & 16'hFFFF;       // (2 bytes)
            //   2: req.HRDATA_i = $urandom() & 32'hFFFFFFFF;  // (4 bytes)
            //   default:req.HRDATA_i = $urandom();           //random value
            // endcase
            
            req.HRDATA_i = $urandom();
            `uvm_info("DATA_SEQ", $sformatf("Read from address %0h Data is:%0h ",
            req.HADDR_o, req.HRDATA_i), UVM_LOW)
        end
        req.HREADY_i <= 1'b1;
        
      // Start new sequence to drive the values to the DUT
      start_item(rsp);
      rsp.copy(req);
      rsp.print();
      finish_item(rsp);
    end
     
  endtask
endclass : ahb_sequence

`endif // AHB_SEQ
