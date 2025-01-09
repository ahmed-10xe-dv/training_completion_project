/*************************************************************************
   > File Name:   rd_addr_monitor.sv
   > Description: Monitors AXI read address channel transactions.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef RD_ADDR_MONITOR
`define RD_ADDR_MONITOR

class rd_addr_monitor extends uvm_monitor;
    `uvm_component_utils(rd_addr_monitor)

    virtual axi_interface axi_vif;
    uvm_analysis_port #(axi_seq_item) rd_addr_ap;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        rd_addr_ap = new("rd_addr_ap", this);
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
            monitor_rd_addr();
        end
    endtask

    task monitor_rd_addr();
        axi_seq_item temp_rd_addr_item;

        temp_rd_addr_item         = axi_seq_item::type_id::create("read_addr_monitor");
        temp_rd_addr_item.addr    = axi_vif.ARADDR;
        temp_rd_addr_item.id      = axi_vif.ARID;
        temp_rd_addr_item.size    = axi_vif.ARSIZE;
        temp_rd_addr_item.access  = READ_TRAN;

        case (axi_vif.ARBURST)
            2'b00: temp_rd_addr_item.burst = FIXED;
            2'b01: temp_rd_addr_item.burst = INCR;
            2'b10: temp_rd_addr_item.burst = WRAP;
        endcase

        // Write the monitored item to analysis port
        if(axi_vif.ARVALID && axi_vif.ARREADY && axi_vif.ARSIZE) begin
            rd_addr_ap.write(temp_rd_addr_item);
            temp_rd_addr_item.print();
            `uvm_info(get_full_name(), "Completed Monitoring AXI_READ_ADDR_monitor transactions", UVM_LOW)
        end
        @(posedge axi_vif.ACLK);

    endtask
endclass

`endif
