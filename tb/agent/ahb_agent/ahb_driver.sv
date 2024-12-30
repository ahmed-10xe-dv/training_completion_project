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

  ahb_seq_item seq;                     // Sequence item for AHB transactions
  bit [7:0] wr_array[4095:0];              // Data array for transactions
  bit [7:0] rd_array[4095:0];              // Data array for transactions

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
    seq = ahb_seq_item::type_id::create("RESPONSE_HANDLER", this);
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
    @(posedge ahb_vif.HCLK);
    wait(!ahb_vif.HRESETn);

    // Reset AXI interface signals to default
    ahb_vif.HRESP  <= 'b0;
    ahb_vif.HRDATA <= 'b0;
    ahb_vif.HREADY <= 1'b1;

    `uvm_info(get_name(), "Reset phase: Signals reset to default", UVM_LOW)
    phase.drop_objection(this);
  endtask : reset_phase

  //-----------------------------------------------------------------------------
  // Post Reset Phase
  //-----------------------------------------------------------------------------
  task post_reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    @(posedge ahb_vif.HCLK);
    wait(ahb_vif.HRESETn);
    @(posedge ahb_vif.HCLK);
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
    seq_item_port.get_next_item(req);
    
    ahb_vif.HREADY <= 1'b1;

    if (ahb_vif.HWRITE) begin
      `uvm_info(get_full_name(), "Entering AHB Driver Write Data Task", UVM_LOW)

      foreach (wr_array[m]) begin  //Initialize Array
        wr_array[m] = 32'hffffffff;
      end

      wait(ahb_vif.HTRANS);
      while (!ahb_vif.HTRANS[1]) begin     //Handle IDLE and BUSY transfer
        if (ahb_vif.HTRANS == 2'b01) begin // Busy state
          @(posedge ahb_vif.HCLK);
          `uvm_info(get_full_name(), "AHB Driver Write - Slave Busy", UVM_LOW)
          continue;
        end
      end
  
      `uvm_info(get_full_name(), "AHB Driver Write - Valid Transfer Detected", UVM_LOW)
      for (int i = 0; i < 2**ahb_vif.HSIZE; ++i) begin
        for (int j = 0; j < 8; ++j) begin
          wr_array[ahb_vif.HADDR][j] = ahb_vif.HWDATA[(i * 8) + j];
        end
      end
  
      `uvm_info(get_full_name(), "AHB Driver Write - Write Completed", UVM_LOW)
    end

    else begin
      `uvm_info(get_full_name(), "Entering AHB Driver Read Data Task", UVM_LOW)
      foreach (req.data[m]) begin  //Initialize Array
        rd_array[m] = req.data[m];
      end
  
      wait(ahb_vif.HTRANS);
      while (!ahb_vif.HTRANS[1]) begin     //Handle IDLE and BUSY transfer
        if (ahb_vif.HTRANS == 2'b01) begin // Busy state
          @(posedge ahb_vif.HCLK);
          `uvm_info(get_full_name(), "AHB Driver READ - Slave Busy", UVM_LOW)
          continue;
        end
      end
  
      `uvm_info(get_full_name(), "AHB Driver Read - Valid Transfer Detected", UVM_LOW)
      for (int i = 0; i < 2**ahb_vif.HSIZE; ++i) begin
        for (int j = 0; j < 8; ++j) begin
          ahb_vif.HRDATA[(i * 8) + j] <= rd_array[ahb_vif.HADDR][j];
        end
      end
  
      `uvm_info(get_full_name(), "AHB Driver Read - Read Completed", UVM_LOW)
    end

    ahb_vif.HRESP  <= req.resp;   // Collect Response
    ahb_vif.HREADY <= 1'b0;      // Extend transfer if necessary
    @(posedge ahb_vif.HCLK);
    ahb_vif.HREADY <= 1'b1;
    
    seq_item_port.item_done();
  endtask : drive

endclass : ahb_driver

`endif