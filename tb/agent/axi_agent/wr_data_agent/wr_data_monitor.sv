/*************************************************************************
   > File Name:   wr_data_monitor.sv
   > Description: AXI write data channel monitor for capturing transactions
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef WR_DATA_MONITOR
`define WR_DATA_MONITOR

class wr_data_monitor extends uvm_monitor;
    `uvm_component_utils(wr_data_monitor)

    // Virtual interface for AXI signals
    virtual axi_interface axi_vif;

    // Analysis port to send captured transactions
    uvm_analysis_port #(axi_seq_item) wr_data_ap;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build phase to initialize analysis port
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        wr_data_ap = new("wr_data_ap", this);
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

    //----------------------------------------------------------------------------- 
    // Task: main_phase
    // Description: Continuously monitors write data channel
    //-----------------------------------------------------------------------------
    task main_phase(uvm_phase phase);
        forever begin
            monitor_wr_data();
        end
    endtask

    //----------------------------------------------------------------------------- 
    // Task: monitor_wr_data
    // Description: Captures write data transactions and sends them via analysis port
    //-----------------------------------------------------------------------------
    task monitor_wr_data();
        axi_seq_item temp_data_item;
        bit [7:0] mon_data[$]; // Dynamic array for monitored data

        // Wait for valid write data transaction
        @(posedge axi_vif.ACLK);
        wait(axi_vif.WVALID);
        temp_data_item = axi_seq_item::type_id::create("write_data_monitor");
        temp_data_item.id = axi_vif.WID;

        // Capture write data beats
        mon_data = {};
        while (!axi_vif.WLAST) begin
            for (int byte_lane = 0; byte_lane < 4; byte_lane++) begin
                if (axi_vif.WSTRB[byte_lane]) begin
                    for (int bit_index = 0; bit_index < 8; bit_index++) begin
                        mon_data.push_back(axi_vif.WDATA[(byte_lane * 8) + bit_index]);
                    end
                end
            end
            wait(axi_vif.WREADY);
            @(posedge axi_vif.ACLK);
        end

        // Collect last beat
        wait(axi_vif.WVALID && axi_vif.WLAST);
        for (int byte_lane = 0; byte_lane < 4; byte_lane++) begin
            if (axi_vif.WSTRB[byte_lane]) begin
                for (int bit_index = 0; bit_index < 8; bit_index++) begin
                    mon_data.push_back(axi_vif.WDATA[(byte_lane * 8) + bit_index]);
                end
            end
        end
        temp_data_item.data = mon_data;
        
        @(posedge axi_vif.ACLK);
        wr_data_ap.write(temp_data_item);
    endtask
endclass

`endif
