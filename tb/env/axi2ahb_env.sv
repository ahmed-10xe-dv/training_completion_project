/*************************************************************************
   > File Name:   axi2ahb_env.sv
   > Description: Environment class for the AXI-to-AHB verification setup. 
                  Manages agents, scoreboard, and connections.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI2AHB_ENV
`define AXI2AHB_ENV

//-----------------------------------------------------------------------------
// AXI2AHB Environment Class
//-----------------------------------------------------------------------------
class axi2ahb_env extends uvm_env;

    `uvm_component_utils(axi2ahb_env)

    //-------------------------------------------------------------------------
    // Member Variables
    //-------------------------------------------------------------------------
    axi_environmet axi_env;
    ahb_environment ahb_env;
    axi2ahb_scoreboard scoreboard;        // Scoreboard
    func_coverage_mon func_coverage;      // Coverage Monitor


    //-------------------------------------------------------------------------
    // Constructor
    //-------------------------------------------------------------------------
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    //-------------------------------------------------------------------------
    // Build Phase
    // Creates AXI agents, AHB agent, and the scoreboard
    //-------------------------------------------------------------------------
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "BUILD Phase of Env", UVM_LOW);

        // Create Env
        axi_env = axi_environmet::type_id::create("axi_env", this);
        ahb_env      = ahb_environment::type_id::create("ahb_env", this);
        // Create Virtual Sequencer
        // vseqr        = virtual_sequencer::type_id::create("vseqr", this);
        // Create Scoreboard and Cov mon
        scoreboard   = axi2ahb_scoreboard::type_id::create("scoreboard", this);
        func_coverage   = func_coverage_mon::type_id::create("func_coverage", this);

    endfunction

    //-------------------------------------------------------------------------
    // Connect Phase
    // Connects AXI channel's monitor analysis ports to the scoreboard
    //-------------------------------------------------------------------------
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), "CONNECT Phase of Env", UVM_LOW);

        // vseqr.wr_addr_sqr  =  axi_env.wr_addr_agnt.wr_addr_sqr;
        // vseqr.rd_addr_sqr  =  axi_env.rd_addr_agnt.rd_addr_sqr;
        // vseqr.wr_data_sqr  =  axi_env.wr_data_agnt.wr_data_sqr;
        // vseqr.rd_data_sqr  =  axi_env.rd_data_agnt.rd_data_sqr;
        // vseqr.wr_rsp_sqr   =  axi_env.wr_rsp_agnt.wr_rsp_sqr;
        // vseqr.ahb_sqr      =  ahb_env.ahb_agnt.ahb_sqr;

        // Connect AXI Monitors to Scoreboard
        axi_env.wr_addr_agnt.wr_addr_mon.wr_addr_ap.connect(scoreboard.axi_wr_addr_imp);
        axi_env.rd_addr_agnt.rd_addr_mon.rd_addr_ap.connect(scoreboard.axi_rd_addr_imp);
        axi_env.wr_data_agnt.wr_data_mon.wr_data_ap.connect(scoreboard.axi_wr_data_imp);
        axi_env.rd_data_agnt.rd_data_mon.rd_data_ap.connect(scoreboard.axi_rd_data_imp);
        axi_env.wr_rsp_agnt.wr_rsp_mon.wr_rsp_ap.connect(scoreboard.axi_wr_rsp_imp);
        // Connect AHB Monitor to Scoreboard
        ahb_env.ahb_agnt.ahb_mon.ahb_ap.connect(scoreboard.ahb_data_imp);

        // Connect AXI Monitors to Functional Coverage
        axi_env.wr_addr_agnt.wr_addr_mon.wr_addr_ap_cov.connect(func_coverage.axi_wr_addr_imp_cov);
        axi_env.rd_addr_agnt.rd_addr_mon.rd_addr_ap_cov.connect(func_coverage.axi_rd_addr_imp_cov);
        axi_env.wr_data_agnt.wr_data_mon.wr_data_ap_cov.connect(func_coverage.axi_wr_data_imp_cov);
        axi_env.rd_data_agnt.rd_data_mon.rd_data_ap_cov.connect(func_coverage.axi_rd_data_imp_cov);
        axi_env.wr_rsp_agnt.wr_rsp_mon.wr_rsp_ap_cov.connect(func_coverage.axi_wr_rsp_imp_cov);
        // Connect AHB Monitor to Functional coverage
        ahb_env.ahb_agnt.ahb_mon.ahb_ap_cov.connect(func_coverage.ahb_data_imp_cov);

    endfunction

endclass

`endif
