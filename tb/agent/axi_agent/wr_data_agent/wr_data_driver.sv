/*************************************************************************
   > File Name:   wr_data_driver.sv
   > Description: This class implements a write data driver for an AXI protocol
                  interface. It drives data and control signals based on received 
                  sequence items and manages the AXI handshake.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef WR_DATA_DRIVER
`define WR_DATA_DRIVER

class wr_data_driver extends uvm_driver #(axi_seq_item);

  `uvm_component_utils(wr_data_driver)
  virtual axi_interface axi_vif;         // Virtual interface for AXI signals

  // Constructor
  function new(string name = "wr_data_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //-----------------------------------------------------------------------------
  // Build Phase
  //-----------------------------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "Build phase completed", UVM_LOW)
  endfunction

  //-----------------------------------------------------------------------------
  // Connect Phase
  //-----------------------------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
    `uvm_error(get_full_name(), "Failed to connect axi_vif interface")
  endfunction
 
  //-----------------------------------------------------------------------------
  // Reset Phase
  //-----------------------------------------------------------------------------
  task reset_phase(uvm_phase phase);
    phase.raise_objection(this);
      @(posedge axi_vif.ACLK);
      wait(!axi_vif.ARESETn);

      // Reset AXI interface signals to default
      axi_vif.WSTRB      <= 'b0;
      axi_vif.WDATA      <= 'b0;
      axi_vif.WID        <= 'b0;
      axi_vif.WLAST      <= 'b0;
      axi_vif.WVALID     <= 1'b0;
      axi_vif.BREADY     <= 1'b0;


   `uvm_info(get_name(), "Reset phase: Signals reset to default", UVM_LOW)
    phase.drop_objection(this);
  endtask : reset_phase
 
  //-----------------------------------------------------------------------------
  // Post Reset Phase
  //-----------------------------------------------------------------------------
  task post_reset_phase(uvm_phase phase);
    phase.raise_objection(this);
    wait(axi_vif.ARESETn);
    @(posedge axi_vif.ACLK);
    `uvm_info(get_name(),$sformatf("Reset Condition Over"), UVM_LOW)
    phase.drop_objection(this);
  endtask : post_reset_phase

  //-----------------------------------------------------------------------------
  // Main Phase
  //-----------------------------------------------------------------------------
  task main_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Main Phase Started", UVM_LOW)
    forever begin

      fork
        drive_write_data();
        drive_write_rsp_channel();
      join

    end
    `uvm_info(get_name(), $sformatf("Main Phase Ended"), UVM_LOW)
  endtask

  //-----------------------------------------------------------------------------
  // Task drive_write_data
  //-----------------------------------------------------------------------------
  task drive_write_data();

    // Retrieve the next sequence item
    seq_item_port.get_next_item(req);
    if (req.access == WRITE_TRAN) begin
      `uvm_info(get_full_name(), "Driving write Data transaction", UVM_LOW)
        req.print();


    // @(posedge axi_vif.ACLK);

      for (int beat = 0; beat < req.burst_length ; beat++) begin
        axi_vif.WID     <= req.id;
        axi_vif.WDATA   <= req.write_data[beat];
        axi_vif.WSTRB   <= req.write_strobe[beat];
        axi_vif.WLAST   <= (beat == req.burst_length - 1)? 1'b1: 1'b0;

        axi_vif.WVALID <= 1'b1;
        wait(axi_vif.WREADY);
        @(posedge axi_vif.ACLK);
        axi_vif.WVALID <= 1'b0;
      end
    `uvm_info(get_full_name(), "Write Data transaction completed", UVM_LOW)
    end

    seq_item_port.item_done();
  endtask

  task drive_write_rsp_channel();
    @(posedge axi_vif.ACLK);
    axi_vif.BREADY <= 1'b1;
    wait(axi_vif.BVALID);
    @(posedge axi_vif.ACLK);
    axi_vif.BREADY <= 1'b0;
  endtask

endclass

`endif
