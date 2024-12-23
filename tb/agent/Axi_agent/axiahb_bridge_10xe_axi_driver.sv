/*************************************************************************
   > File Name:   ahb_seq_item.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI_DRIVER
`define AXI_DRIVER

class axi_driver extends uvm_driver #(axi_seq_item);

  `uvm_component_utils(axi_driver)

  virtual axi_interface axi_vif;
  axi_seq_item addr_queue[$];
  axi_seq_item addr_item;

  function new(string name = "axi_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_full_name(), "BUILD @driver", UVM_LOW)
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
      `uvm_error(get_full_name(), "Interface Connection Failed")
    else
      `uvm_info(get_full_name(), "Interface Connection Success", UVM_LOW)
  endfunction
 

  task drive_write_addr();
    forever begin
      wait(axi_vif.ARESETn);
      @(posedge axi_vif.ACLK);
      if (addr_queue.size > 0) begin
        addr_item = addr_queue.pop_back();

        axi_vif.AWVALID <= 1'b1;
        axi_vif.AWBURST <= addr_item.burst;
        axi_vif.AWADDR  <= addr_item.aligned_addr;
        axi_vif.AWID    <= addr_item.id;
        axi_vif.AWSIZE  <= addr_item.awsize_val;
        axi_vif.AWLEN   <= addr_item.burst_length;

        // wait(axi_vif.AWREADY);
        @(posedge axi_vif.ACLK);
        axi_vif.AWVALID <= 1'b0;

      end
    end
  endtask

  task fetch_data();
    forever begin
      seq_item_port.get_next_item(req);
      req.print();
      if (req.access == WRITE_TRAN) addr_queue.push_front(req);
      seq_item_port.item_done();
    `uvm_info(get_full_name(), "Item Recevied and Done", UVM_LOW)
    end
  endtask

  task check_reset();
    forever begin
      @(posedge axi_vif.ACLK);
      if (!axi_vif.ARESETn) axi_vif.AWVALID <= 1'b0;
    end
    wait(axi_vif.ARESETn);
  endtask


  task run_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "Run Phase Started", UVM_LOW)
    fork
      fetch_data();
      check_reset();
      drive_write_addr();
    join
  endtask

endclass

`endif
