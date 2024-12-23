/*************************************************************************
   > File Name:   axi_monitor.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI_MONITOR
`define AXI_MONITOR

class axi_monitor extends uvm_monitor;
    `uvm_component_utils(axi_monitor)
  
    // AXI Interface and temporary write address item
    virtual axi_interface axi_vif;
    axi_seq_item temp_w;
    axi_seq_item wr_addr_comb[$];
  
    // Analysis Port for write address items
    uvm_analysis_port #(axi_seq_item) axi_write_analysis_port;
  
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction
  
    // Build Phase: Initializes analysis port
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), ":: Build Phase @ AXI Monitor::", UVM_LOW);
        axi_write_analysis_port = new("axi_write_analysis_port", this);
    endfunction
  
    // Connect Phase: Establishes connection to AXI interface
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name(), ":: Connect Phase @ AXI Monitor::", UVM_LOW);
        if (!uvm_config_db#(virtual axi_interface)::get(this, "*", "axi_vif", axi_vif)) begin
            `uvm_error(get_full_name(), ":: Failed to Connect AXI INTF @ AXI Monitor::");
        end
    endfunction
  
    // Task to Monitor Write Address Channel
    task mon_write_addr_channel();
        forever begin
            @(posedge axi_vif.ACLK);
            wait(axi_vif.AWVALID);
             `uvm_info(get_full_name(), ":: Debug in Monitor::", UVM_LOW);

            // Create and populate the write address item
            temp_w = axi_seq_item::type_id::create("write_addr_monitor");
            temp_w.addr   = axi_vif.AWADDR;
            temp_w.id     = axi_vif.AWID;
            temp_w.size   = axi_vif.AWSIZE;
            temp_w.access = WRITE_TRAN;

            // Set burst type based on AWBURST
            case (axi_vif.AWBURST)
                2'b00: temp_w.burst = FIXED;
                2'b01: temp_w.burst = INCR;
                2'b10: temp_w.burst = WRAP;
            endcase

            // wait(axi_vif.AWREADY);
            @(posedge axi_vif.ACLK);
            wr_addr_comb.push_front(temp_w);
        end
    endtask
  
    // Run Phase: Starts monitoring the AXI write address channel
    task run_phase(uvm_phase phase);
        `uvm_info(get_full_name(), ":: Run Phase @ AXI Monitor::", UVM_LOW);
        // fork
            mon_write_addr_channel();
            `uvm_info(get_full_name(), ":: Values in Monitor::", UVM_LOW);
            temp_w.print();

        // join
    endtask
endclass : axi_monitor

`endif
