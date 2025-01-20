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

  //------------------------------------------------------------------------------
  // Constructor: new
  // Default constructor with an optional name parameter.
  //------------------------------------------------------------------------------
  function new(string name = "ahb_sequence");
    super.new(name);
  endfunction

  //------------------------------------------------------------------------------
  // Task: body
  // Slave Sequence Method Implemented
  //------------------------------------------------------------------------------
  task body();
    req = ahb_seq_item::type_id::create("req");
    rsp = ahb_seq_item::type_id::create("rsp");

    forever begin
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



/////////////////////////////////////////////////////////////////////////////
// AHB ERROR SEQUENCE
/////////////////////////////////////////////////////////////////////////////

class ahb_error_seq extends ahb_sequence;
  `uvm_object_utils(ahb_error_seq)

  //------------------------------------------------------------------------------
  // Constructor: new
  // Default constructor with an optional name parameter.
  //------------------------------------------------------------------------------
  function new(string name = "ahb_error_seq");
    super.new(name);
  endfunction


  //------------------------------------------------------------------------------
  // Task: body
  // Slave Sequence Method Implemented
  //------------------------------------------------------------------------------
  task body();

    req = ahb_seq_item::type_id::create("req");
    rsp = ahb_seq_item::type_id::create("rsp");

    forever begin
      start_item(req);  
      finish_item(req);

        // Perform write or read operation based on DUT response
        if (req.ACCESS_o == write) begin
            `uvm_info("AHB Write Transaction", 
            $sformatf("Writing to address %0h: data %0h", req.HADDR_o, 
            req.HWDATA_o), UVM_LOW)
            req.RESP_i <= ERROR;
        end
        else begin
            `uvm_info("AHB Read Transaction",
            $sformatf("Reading from address %0h", req.HADDR_o), UVM_LOW)

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
endclass : ahb_error_seq

/////////////////////////////////////////////////////////////////////////////
// AHB SEQUENCE WITH SLAVE NOT READY
/////////////////////////////////////////////////////////////////////////////

class ahb_slv_not_ready_seq extends ahb_sequence;
  `uvm_object_utils(ahb_slv_not_ready_seq)

  //------------------------------------------------------------------------------
  // Constructor: new
  // Default constructor with an optional name parameter.
  //------------------------------------------------------------------------------
  function new(string name = "ahb_slv_not_ready_seq");
    super.new(name);
  endfunction


  //------------------------------------------------------------------------------
  // Task: body
  // Slave Sequence Method Implemented
  //------------------------------------------------------------------------------
  task body();
    `uvm_do_with(req,{HREADY_i ==0;})
    repeat(20) begin
      `uvm_do_with(req,{HREADY_i ==0;})
    end

    req = ahb_seq_item::type_id::create("req");
    rsp = ahb_seq_item::type_id::create("rsp");

    begin
      repeat(2) begin
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

                  req.HRDATA_i = $urandom();
                  `uvm_info("DATA_SEQ", $sformatf("Read from address %0h Data is:%0h ",
                  req.HADDR_o, req.HRDATA_i), UVM_LOW)
              end
              req.HREADY_i <= 1'b1;

              start_item(rsp);
              rsp.copy(req);
              rsp.print();
              finish_item(rsp);
      end
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

                  req.HRDATA_i = $urandom();
                  `uvm_info("DATA_SEQ", $sformatf("Read from address %0h Data is:%0h ",
                  req.HADDR_o, req.HRDATA_i), UVM_LOW)
              end
              req.HREADY_i <= 1'b0;

              start_item(rsp);
              rsp.copy(req);
              rsp.print();
              finish_item(rsp);
    end
  endtask
endclass : ahb_slv_not_ready_seq


`endif // AHB_SEQ
