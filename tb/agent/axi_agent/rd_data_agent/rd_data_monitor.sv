/*************************************************************************
   > File Name:   rd_data_monitor.sv
   > Description: Monitors AXI read data channel transactions.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef RD_DATA_MONITOR
`define RD_DATA_MONITOR

class rd_data_monitor extends uvm_monitor;
    `uvm_component_utils(rd_data_monitor)

    virtual axi_interface axi_vif;
    uvm_analysis_port #(axi_seq_item) rd_data_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rd_data_ap = new("rd_data_ap", this);
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
    //----------------------------------------------------------------------------- 
    task main_phase(uvm_phase phase);
        forever begin
            monitor_rd_data();
        end
    endtask

    task monitor_rd_data();
        axi_seq_item temp_rd_data_item;
        bit [7:0] mon_data[$];

        @(posedge axi_vif.ACLK);
        wait(axi_vif.RVALID);
        temp_rd_data_item         = axi_seq_item::type_id::create("read_data_monitor");
        temp_rd_data_item.id      = axi_vif.RID;
        mon_data                  = {};

        while (!axi_vif.RLAST) begin
            for (int byte_lane = 0; byte_lane < 4; byte_lane++) begin
                for (int bit_index = 0; bit_index < 8; bit_index++) begin
                    mon_data.push_back(axi_vif.RDATA[(byte_lane * 8) + bit_index]);
                end
            end
            wait(axi_vif.RREADY);
            @(posedge axi_vif.ACLK);
        end

        // Collect last beat
        wait(axi_vif.RVALID && axi_vif.RLAST);
        for (int byte_lane = 0; byte_lane < 4; byte_lane++) begin
            for (int bit_index = 0; bit_index < 8; bit_index++) begin
                mon_data.push_back(axi_vif.RDATA[(byte_lane * 8) + bit_index]);
            end
        end

        temp_rd_data_item.data = mon_data;

        case (axi_vif.RRESP)
            2'b00: temp_rd_data_item.response = OKAY;
            2'b01: temp_rd_data_item.response = EXOKAY;
            2'b10: temp_rd_data_item.response = SLVERR;
            2'b11: temp_rd_data_item.response = DECERR;
        endcase

        temp_rd_data_item.access = READ_TRAN;
        // wait(axi_vif.RREADY);
        // @(posedge axi_vif.ACLK);
        rd_data_ap.write(temp_rd_data_item);
    endtask
endclass

`endif
