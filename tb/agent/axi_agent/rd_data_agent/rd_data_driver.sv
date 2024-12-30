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
      axi_vif.RDATA      <= 'b0;
      axi_vif.RID        <= 'b0;
      axi_vif.RLAST      <= 'b0;
      axi_vif.RVALID     <= 1'b0;
      axi_vif.RREADY     <= 1'b0;
      axi_vif.RRESP      <= 1'b0;


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
        drive_read_data();
        drive_read_rsp_channel();
      join

    end
    `uvm_info(get_name(), $sformatf("Main Phase Ended"), UVM_LOW)
  endtask

  //-----------------------------------------------------------------------------
  // Task drive_read_data
  //-----------------------------------------------------------------------------
  task drive_read_data();

    // Local variables
    int byte_index = 0;  // Index for storing data in the sequence item
    int word_count = 1;  // Dynamic counter for received words

      // Retrieve the next sequence item
      seq_item_port.get_next_item(req);
      if (req.access == READ_TRAN) begin

        axi_seq_item read_item; // Sequence item to store read response data

        // Create a new sequence item for the read response
        read_item = axi_seq_item::type_id::create("read_response");
        @(posedge axi_vif.ACLK);
        axi_vif.RREADY <= 1'b1;
        
        // Wait until RLAST signal is low
        wait(!axi_vif.RLAST);

        // Loop to read data words until the RLAST signal is asserted
        while (!axi_vif.RLAST) begin
            wait(axi_vif.RVALID);
            @(posedge axi_vif.ACLK);
            read_item.data = new[word_count*4] (read_item.data);  //Reallocate Array preserving previous values

            // Capture the current data and store in the sequence item
            {read_item.data[byte_index + 3], read_item.data[byte_index + 2], 
            read_item.data[byte_index + 1], read_item.data[byte_index]} = axi_vif.RDATA;
            read_item.id = axi_vif.RID;

            byte_index += 4;
            word_count++;
        end

        // Handle the last data word
        wait(axi_vif.RVALID);
        @(posedge axi_vif.ACLK);
        read_item.data = new[word_count*4] (read_item.data);  //Reallocate Array preserving previous values
        {read_item.data[byte_index + 3], read_item.data[byte_index + 2], 
        read_item.data[byte_index + 1], read_item.data[byte_index]} = axi_vif.RDATA;
        read_item.id = axi_vif.RID;

        // Reset the byte index for the next transaction
        byte_index = 0;
        `uvm_info(get_full_name(), "Read Data transaction completed", UVM_LOW)

      end
        seq_item_port.item_done();
  endtask

  task drive_read_rsp_channel();
    @(posedge axi_vif.ACLK);
    axi_vif.RREADY <= 1'b1;
    wait(axi_vif.RVALID);
    @(posedge axi_vif.ACLK);
    axi_vif.RREADY <= 1'b0;
  endtask

endclass

`endif

