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

`define DRIV_IF ahb_vif.driver_cb
`define MON_IF  ahb_vif.monitor_cb

class ahb_driver extends uvm_driver #(ahb_seq_item);

  `uvm_component_utils(ahb_driver)

  ahb_seq_item req;
  ahb_seq_item rsp;

  virtual ahb_interface ahb_vif;        // Virtual interface for AHB protocol

  // Constructor
  function new(string name = "ahb_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //-----------------------------------------------------------------------------
  // Build Phase
  //-----------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "BUILD PHASE @ Driver", UVM_LOW)
  endfunction : build_phase

  //-----------------------------------------------------------------------------
  // Connect Phase
  //-----------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual ahb_interface)::get(this, "*", "ahb_vif", ahb_vif))
      `uvm_error("Config Error", "Configuration Failed @ Connect Phase in AHB Driver")
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
    `uvm_info(get_full_name(), "Main Phase Started", UVM_LOW)
    forever begin
      drive();
    end
    `uvm_info(get_name(), "Main Phase Ended", UVM_LOW)
  endtask : main_phase

  //-----------------------------------------------------------------------------
  // Task: drive
  //-----------------------------------------------------------------------------
  task drive();

    @(ahb_vif.HADDR);
    // Retrieve the next sequence item from the sequencer
    seq_item_port.get_next_item(req);
    // @(posedge ahb_vif.HCLK);
    // Assign input signals to the sequence item's fields based on AHB interface
    req.ACCESS_o   = (`DRIV_IF.HWRITE) ? write : read; // Determine access type: Read or Write
    req.HADDR_o    = `DRIV_IF.HADDR;                  // Capture address bus value
    req.HWDATA_o   = `DRIV_IF.HWDATA;                 // Capture write data bus value
    req.HSIZE_o    = `DRIV_IF.HSIZE;                  // Capture transfer size
    req.HBURST_o   = `DRIV_IF.HBURST;                 // Capture burst type
    req.HTRANS_o   = `DRIV_IF.HTRANS;                 // Capture transfer type
    seq_item_port.item_done();
    `uvm_info(get_name(), "AHB Driver Debug before printing req", UVM_LOW)
    req.print();

    @(posedge ahb_vif.HCLK);

    seq_item_port.get_next_item(rsp);
    if (!ahb_vif.HWRITE) begin
      ahb_vif.HRDATA <= rsp.HRDATA_i;              // Assign read data bus for read operation
      // ahb_vif.HREADY <= rsp.HREADY_i;              // Assign ready signal for read operation
    end
    // else begin
    //     ahb_vif.HREADY <= rsp.HREADY_i;              // Assign ready signal for read operation
    // end

    ahb_vif.HREADY <= rsp.HREADY_i;              // Assign ready signal for read operation
    // Assign response status (HRESP) based on response type (okay or error)
    ahb_vif.HRESP <= (rsp.RESP_i == okay) ? 1'b0 : 1'b1;
    // @(posedge ahb_vif.HCLK);
    seq_item_port.item_done();
    `uvm_info(get_name(), "AHB Driver Debug before printing rsp", UVM_LOW)
    rsp.print();

  endtask : drive

endclass : ahb_driver

`endif