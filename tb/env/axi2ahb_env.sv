/*************************************************************************
   > File Name:   axi2ahb_env.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef AXI2AHB_ENV
`define AXI2AHB_ENV

class axi2ahb_env extends uvm_env;
    `uvm_component_utils(axi2ahb_env)

    wr_addr_agent wr_addr_agnt;
    rd_addr_agent rd_addr_agnt;
    wr_data_agent wr_data_agnt;
    rd_data_agent rd_data_agnt;
    ahb_agent ahb_agnt;
    axi2ahb_scoreboard scoreboard;

    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // Build Phase: Creates AXI agent
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "BUILD Phase of Env", UVM_LOW);
        wr_addr_agnt = wr_addr_agent::type_id::create("wr_addr_agnt", this);
        rd_addr_agnt = rd_addr_agent::type_id::create("rd_addr_agnt", this);
        wr_data_agnt = wr_data_agent::type_id::create("wr_data_agnt", this);
        rd_data_agnt = rd_data_agent::type_id::create("rd_data_agnt", this);
        ahb_agnt     = ahb_agent::type_id::create("ahb_agnt", this);
        scoreboard   = axi2ahb_scoreboard::type_id::create("scoreboard", this);

    endfunction

    // Connect Phase: Connects AXI channel's monitor analysis ports to scoreboard
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name(), "CONNECT", UVM_LOW);
        //Axi Monitors 
        wr_addr_agnt.wr_addr_mon.wr_addr_ap.connect(scoreboard.axi_wr_addr_fifo.analysis_export);
        rd_addr_agnt.rd_addr_mon.rd_addr_ap.connect(scoreboard.axi_rd_addr_fifo.analysis_export);
        wr_data_agnt.wr_data_mon.wr_data_ap.connect(scoreboard.axi_wr_data_fifo.analysis_export);
        rd_data_agnt.rd_data_mon.rd_data_ap.connect(scoreboard.axi_rd_data_fifo.analysis_export);

        //AHB Monitor
        ahb_agnt.ahb_mon.ahb_ap.connect(scoreboard.ahb_data_fifo.analysis_export);

    endfunction

endclass

`endif