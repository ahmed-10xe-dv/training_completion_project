/*************************************************************************
   > File Name:   wr_addr_monitor.sv
   > Description: AXI write address channel monitor for capturing transactions
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef WR_ADDR_MONITOR
`define WR_ADDR_MONITOR

class wr_addr_monitor extends uvm_monitor;

    `uvm_component_utils(wr_addr_monitor)

    // Virtual Interface Declaration
    virtual axi_interface axi_vif;

    // Analysis Port Declaration
    uvm_analysis_port #(axi_seq_item) wr_addr_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    //-------------------------------------------------------------------------
    // Function: build_phase
    //-------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_addr_ap = new("wr_addr_ap", this);
    endfunction

    //-----------------------------------------------------------------------------
    // Function: connect_phase
    //-----------------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (!uvm_config_db#(virtual axi_interface)::get(this, "*", "axi_vif", axi_vif)) begin
            `uvm_error("Connect Phase", "Configuration failed for axi_monitor")
        end
    endfunction


    //-------------------------------------------------------------------------
    // Task: main_phase
    // Purpose: Main phase of simulation to monitor transactions
    //-------------------------------------------------------------------------
    task main_phase(uvm_phase phase);
        forever begin
            monitor_wr_addr();
        end
    endtask

    //-------------------------------------------------------------------------
    // Task: monitor_wr_addr
    // Purpose: Monitors write address channel signals
    //-------------------------------------------------------------------------
    task monitor_wr_addr();
        axi_seq_item temp_wr_addr_item;

        // Wait for valid write address signal

        // Create a new sequence item
        temp_wr_addr_item        = axi_seq_item::type_id::create("write_addr_monitor");
        temp_wr_addr_item.addr   = axi_vif.AWADDR;
        temp_wr_addr_item.id     = axi_vif.AWID;
        temp_wr_addr_item.size   = axi_vif.AWSIZE;
        temp_wr_addr_item.access = WRITE_TRAN;

        // Decode burst type
        case (axi_vif.AWBURST)
            2'b00: temp_wr_addr_item.burst = FIXED;
            2'b01: temp_wr_addr_item.burst = INCR;
            2'b10: temp_wr_addr_item.burst = WRAP;
        endcase

        // Write the monitored item to analysis port
        if(axi_vif.AWVALID && axi_vif.AWREADY && axi_vif.AWSIZE) begin
            wr_addr_ap.write(temp_wr_addr_item);
            temp_wr_addr_item.print();
                `uvm_info(get_name(), "Completed Monitoring AXI_write_data_monitor transactions", UVM_LOW)
        end
        @(posedge axi_vif.ACLK);
    endtask

endclass

`endif
