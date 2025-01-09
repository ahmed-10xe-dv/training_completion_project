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

     //----------------------------------------------------------------------------- 
    // Task: monitor_rd_data
    // Description: Captures Read data transactions and sends them via analysis port
    //-----------------------------------------------------------------------------
    task monitor_rd_data();
        axi_seq_item temp_rd_data_item;
        temp_rd_data_item         = axi_seq_item::type_id::create("read_data_monitor");

        // do begin
            // int beat =0;
            `uvm_info(get_full_name(), "Monitoring AXI_Read_data_monitor transactions", UVM_LOW)
            temp_rd_data_item.id = axi_vif.RID;
            temp_rd_data_item.write_data[0] = axi_vif.RDATA;
            temp_rd_data_item.access = READ_TRAN;

            if(axi_vif.RVALID && axi_vif.RREADY) begin
                rd_data_ap.write(temp_rd_data_item);
                temp_rd_data_item.print();
                `uvm_info(get_full_name(), "Completed AXI_Read_data_monitor transactions", UVM_LOW)
            end
            @(posedge axi_vif.ACLK);
    endtask
endclass

`endif
