    /*************************************************************************
   > File Name:   ahb_driver.sv
   > Description: This file implements the AHB driver class, which extends 
                  the UVM driver to handle AHB transactions based on sequence items.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AHB_DRIVER
`define AHB_DRIVER

`define AHB_DRIV_IF ahb_vif.driver_cb

class ahb_driver extends uvm_driver #(ahb_seq_item);

  `uvm_component_utils(ahb_driver)

  ahb_seq_item req;
  ahb_seq_item rsp;

  virtual ahb_interface ahb_vif;        // Virtual interface for AHB protocol
  virtual axi_interface axi_vif;        // Virtual interface for AXI protocol


  // Constructor
  function new(string name = "ahb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //-----------------------------------------------------------------------------
  // Build Phase
  //-----------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "BUILD PHASE @ Driver", UVM_LOW)
  endfunction : build_phase

  //-----------------------------------------------------------------------------
  // Connect Phase
  //-----------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual ahb_interface)::get(this, "*", "ahb_vif", ahb_vif))
      `uvm_error("Config Error", "Configuration Failed @ Connect Phase in AHB Driver")
    if (!uvm_config_db#(virtual axi_interface)::get(this, "*", "axi_vif", axi_vif))
      `uvm_error("Config Error", "Configuration Failed @ Connect Phase in axi Driver")
  endfunction : connect_phase

  //-----------------------------------------------------------------------------
  // Reset Phase
  //-----------------------------------------------------------------------------
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
   
    ahb_vif.reset_ahb();  // Reset AHB by setting the signals to default

    `uvm_info(get_name(), "Reset phase: Signals reset to default", UVM_LOW)
    phase.drop_objection(this);
  endtask : reset_phase

  //-----------------------------------------------------------------------------
  // Post Reset Phase
  //-----------------------------------------------------------------------------
  task post_reset_phase(uvm_phase phase);
    phase.raise_objection(this);

    ahb_vif.post_reset_ahb(); // Wait for reset conditions to over

    `uvm_info(get_name(),$sformatf("Reset Condition Over"), UVM_LOW)
    phase.drop_objection(this);
  endtask : post_reset_phase

  //-----------------------------------------------------------------------------
  // Main Phase
  //-----------------------------------------------------------------------------
  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "Main Phase Started", UVM_LOW)
    forever begin
      drive();
    end
    `uvm_info(get_name(), "Main Phase Ended", UVM_LOW)
  endtask : main_phase

  //-----------------------------------------------------------------------------
  // Task: drive
  //-----------------------------------------------------------------------------
  task drive();

    @(ahb_vif.HADDR || ahb_vif.HTRANS);
    seq_item_port.get_next_item(req);
    // Assign input signals to the sequence item's fields based on AHB interface
    req.ACCESS_o   = (`AHB_DRIV_IF.HWRITE) ? write : read; // Determine access type: Read or Write
    req.HADDR_o    = `AHB_DRIV_IF.HADDR;                  // Capture address bus value
    req.HWDATA_o   = `AHB_DRIV_IF.HWDATA;                 // Capture write data bus value
    req.HSIZE_o    = `AHB_DRIV_IF.HSIZE;                  // Capture transfer size
    req.HBURST_o   = `AHB_DRIV_IF.HBURST;                 // Capture burst type
    req.HTRANS_o   = `AHB_DRIV_IF.HTRANS;                 // Capture transfer type
    seq_item_port.item_done();
    `uvm_info(get_name(), "AHB Driver Debug before printing req", UVM_LOW)
    req.print();

    @(posedge ahb_vif.HCLK);                     // Data Phase

    seq_item_port.get_next_item(rsp);
    if (!`AHB_DRIV_IF.HWRITE) begin
      `AHB_DRIV_IF.HRDATA <= rsp.HRDATA_i;              // Assign read data bus for read operation
    end

    `AHB_DRIV_IF.HREADY <= rsp.HREADY_i;              // Assign ready signal for read operation
    `AHB_DRIV_IF.HRESP <= (rsp.RESP_i == okay) ? 1'b0 : 1'b1; // Assign response status (HRESP) based on response type 
    seq_item_port.item_done();
    `uvm_info(get_name(), "AHB Driver Debug before printing rsp", UVM_LOW)
    rsp.print();
  endtask : drive

endclass : ahb_driver

`endif