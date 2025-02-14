/*************************************************************************
   > File Name:   rd_data_driver.sv
   > Description: This class implements a read data driver for an AXI protocol
                  interface. It drives data and control signals based on received 
                  sequence items and manages the AXI handshake.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef RD_DATA_DRIVER
`define RD_DATA_DRIVER

class rd_data_driver extends uvm_driver #(axi_seq_item);

  `uvm_component_utils(rd_data_driver)
  virtual axi_interface axi_vif;         // Virtual interface for AXI signals

  // Constructor
  function new(string name = "rd_data_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //-----------------------------------------------------------------------------
  // Build Phase
  //-----------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_name(), "Build phase completed", UVM_LOW)
  endfunction

  //-----------------------------------------------------------------------------
  // Connect Phase
  //-----------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
    `uvm_error(get_name(), "Failed to connect axi_vif interface")
  endfunction
 
  //-----------------------------------------------------------------------------
  // Reset Phase
  //-----------------------------------------------------------------------------
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    axi_vif.reset_axi();  // Reset the Axi signals to defualt
   `uvm_info(get_name(), "Reset phase: Signals reset to default", UVM_LOW)
    phase.drop_objection(this);
  endtask : reset_phase
 
  //-----------------------------------------------------------------------------
  // Post Reset Phase
  //-----------------------------------------------------------------------------
  task post_reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    axi_vif.post_reset_axi();   // Wait for reset conditions to over
    `uvm_info(get_name(),$sformatf("Reset Condition Over"), UVM_LOW)
    phase.drop_objection(this);
  endtask : post_reset_phase

  //-----------------------------------------------------------------------------
  // Main Phase
  //-----------------------------------------------------------------------------
  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "Main Phase Started", UVM_LOW)
    forever begin
        drive_read_data();
    end
    `uvm_info(get_name(), $sformatf("Main Phase Ended"), UVM_LOW)
  endtask

  //-----------------------------------------------------------------------------
  // Task drive_read_data
  //-----------------------------------------------------------------------------
  task drive_read_data();
    seq_item_port.get_next_item(req);

    if (req.access == READ_TRAN) begin
      `uvm_info(get_name(), "Observing Read Data transaction", UVM_LOW)
      axi_vif.RREADY <= req.rready;
      wait(axi_vif.RVALID);
    end
    @(posedge axi_vif.ACLK);
    seq_item_port.item_done();
    req.print();
  endtask

endclass

`endif

