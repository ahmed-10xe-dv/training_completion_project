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
        temp_data_item = axi_seq_item::type_id::create("AXI_write_data_monitor");

        // Wait for valid write data transaction

        wait(axi_vif.WVALID);
        do begin
            int beat =0;
            `uvm_info(get_full_name(), "Monitoring AXI_write_data_monitor transactions", UVM_LOW)
            temp_data_item.id = axi_vif.WID;
            temp_data_item.write_data[beat] = axi_vif.WDATA;
            temp_data_item.write_strobe[beat] = axi_vif.WSTRB;
            beat++;
            wait(axi_vif.WREADY);
            
            wr_data_ap.write(temp_data_item);
            temp_data_item.print();
            @(posedge axi_vif.ACLK);
            `uvm_info(get_full_name(), "Completed Monitoring AXI_write_data_monitor transactions", UVM_LOW)
        end
        while (!axi_vif.WLAST);


        // `uvm_info("AXI Write Data Transaction", 
        // $sformatf("Writing to address %0h: DATA %0h", temp_data_item.WDATA, 
        // temp_data_item.WSTRB), UVM_LOW)

    endtask
endclass

`endif
