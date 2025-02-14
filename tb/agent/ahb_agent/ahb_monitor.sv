/*************************************************************************
   > File Name:   ahb_monitor.sv
   > Description: AHB protocol monitor for verifying write and read operations.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AHB_MONITOR
`define AHB_MONITOR

`define MON_IF ahb_vif.monitor_cb

//-----------------------------------------------------------------------------
// Class: ahb_monitor
//-----------------------------------------------------------------------------
class ahb_monitor extends uvm_monitor;
    `uvm_component_utils(ahb_monitor)

    virtual ahb_interface ahb_vif;
    ahb_seq_item ahb_mon_item;

    // Analysis port
    uvm_analysis_port #(ahb_seq_item) ahb_ap;

    //-----------------------------------------------------------------------------
    // Function: new
    //-----------------------------------------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    //-----------------------------------------------------------------------------
    // Function: build_phase
    //-----------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ahb_ap = new("ahb_ap", this);
        ahb_mon_item = ahb_seq_item::type_id::create("ahb_mon_item", this);
    endfunction

    //-----------------------------------------------------------------------------
    // Function: connect_phase
    //-----------------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (!uvm_config_db#(virtual ahb_interface)::get(this, "*", "ahb_vif", ahb_vif)) begin
            `uvm_fatal(get_name(), "Configuration failed for ahb_monitor")
        end
    endfunction

    //-----------------------------------------------------------------------------
    // Task: main_phase
    //-----------------------------------------------------------------------------
    task main_phase(uvm_phase phase);
        forever begin
            monitor();
        end
    endtask

    //-----------------------------------------------------------------------------
    // Task: monitor
    //-----------------------------------------------------------------------------
    task monitor();
            `uvm_info(get_name(), "Monitoring ahb transactions", UVM_LOW)
            // Address Phase, monitor control signals
            ahb_mon_item.HADDR_o  = ahb_vif.HADDR;
            ahb_mon_item.ACCESS_o = (ahb_vif.HWRITE == 1)? write : read;
            ahb_mon_item.RESP_i   = (ahb_vif.HRESP == 1) ? ERROR : okay;
            ahb_mon_item.HBURST_o = ahb_vif.HBURST;
            ahb_mon_item.HTRANS_o = ahb_vif.HTRANS;
            ahb_mon_item.HSIZE_o = ahb_vif.HSIZE;

            // Data Phase
            @(posedge ahb_vif.HCLK);
            ahb_mon_item.HWDATA_o = ahb_vif.HWDATA;
            ahb_mon_item.HRDATA_i = ahb_vif.HRDATA;

            if (ahb_vif.HREADY) begin
                // Write the monitored data to ahb analysis port
                ahb_ap.write(ahb_mon_item);
                ahb_mon_item.print();  // Print the monitored data
            end
            @(posedge ahb_vif.HCLK);
    endtask

endclass

`endif
