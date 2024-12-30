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

    // Parameters for burst types
    parameter single = 3'b000;
    parameter incr   = 3'b001;
    parameter wrap4  = 3'b010;
    parameter incr4  = 3'b011;
    parameter wrap8  = 3'b100;
    parameter incr8  = 3'b101;
    parameter wrap16 = 3'b110;
    parameter incr16 = 3'b111;

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
    endfunction

    //-----------------------------------------------------------------------------
    // Function: connect_phase
    //-----------------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        if (!uvm_config_db#(virtual ahb_interface)::get(this, "*", "ahb_vif", ahb_vif)) begin
            `uvm_error("Connect Phase", "Configuration failed for ahb_monitor")
        end
    endfunction

    //-----------------------------------------------------------------------------
    // Function: end_of_elaboration_phase
    //-----------------------------------------------------------------------------
    function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "End of elaboration phase completed.", UVM_LOW)
    endfunction

    //-----------------------------------------------------------------------------
    // Task: main_phase
    //-----------------------------------------------------------------------------
    // task main_phase(uvm_phase phase);
    //     forever begin
    //         monitor();
    //     end
    // endtask

    //-----------------------------------------------------------------------------
    // Task: monitor
    //-----------------------------------------------------------------------------
    task monitor();
        bit resp;
        wait(ahb_vif.HTRANS)
        if (ahb_vif.HTRANS[1]) begin
            ahb_mon_item = ahb_seq_item::type_id::create("ahb_mon_item", this);
            wait(ahb_vif.HREADY);
            ahb_mon_item.addr = ahb_vif.HADDR;
            case (ahb_vif.HBURST)
                single:         capture_data(0,  ahb_mon_item.data,  resp);
                incr4, wrap4:   capture_data(4,  ahb_mon_item.data,  resp);
                incr8, wrap8:   capture_data(8,  ahb_mon_item.data,  resp);
                incr16, wrap16: capture_data(16, ahb_mon_item.data,  resp);
            endcase
            ahb_mon_item.resp = (resp == 1) ? ERROR : okay;
            if (ahb_vif.HWRITE) begin
                ahb_mon_item.access = write;
                ahb_ap.write(ahb_mon_item);
            end
            else begin
                ahb_mon_item.access = read;
                ahb_ap.write(ahb_mon_item);
            end
        end
    endtask

    //*************************************************************************
    // Task: capture_data
    // Description: Captures AHB transaction data and stores it in `data_array`. 
    //              It also retrieves the response signal (`HRESP`) at the end.
    // Parameters:
    //   - int transaction_count: Number of transactions to capture.
    //   - output bit [7:0] data_array[$]: Dynamic array to store transaction data.
    //   - output bit response: Captured response signal from the interface.
    //*************************************************************************

    task capture_data(
        int transaction_count,            
        output bit [7:0] data_array[$],   
        output bit response_ahb             
    );
        int transaction_index = 0;

        while (transaction_index < transaction_count) begin
            for (int byte_index = 0; byte_index < (1 << ahb_vif.HSIZE); byte_index++) begin
                data_array[transaction_index] = ahb_vif.HWRITE 
                    ? ahb_vif.HWDATA[(byte_index * 8) +: 8] // Write data
                    : ahb_vif.HRDATA[(byte_index * 8) +: 8]; // Read data
            end

            transaction_index++;
            @(posedge ahb_vif.HCLK);
        end
        response_ahb = ahb_vif.HRESP;
    endtask

endclass

`endif
