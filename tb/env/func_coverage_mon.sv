/*************************************************************************
   > File Name:   func_coverage_mon.sv
   > Description: This file implements the AHB driver class, which extends 
                  the UVM driver to handle AHB transactions based on sequence items.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef FUNC_COVERAGE_MON
`define FUNC_COVERAGE_MON

`uvm_analysis_imp_decl(_axi_wr_addr_cov)
`uvm_analysis_imp_decl(_axi_rd_addr_cov)
`uvm_analysis_imp_decl(_axi_wr_data_cov)
`uvm_analysis_imp_decl(_axi_rd_data_cov)
`uvm_analysis_imp_decl(_axi_wr_rsp_cov)
`uvm_analysis_imp_decl(_ahb_data_cov)

class func_coverage_mon extends uvm_component;

    `uvm_component_utils(func_coverage_mon)

    uvm_analysis_imp_axi_wr_addr_cov #(axi_seq_item, func_coverage_mon) axi_wr_addr_imp_cov;
    uvm_analysis_imp_axi_rd_addr_cov #(axi_seq_item, func_coverage_mon) axi_rd_addr_imp_cov;
    uvm_analysis_imp_axi_wr_data_cov #(axi_seq_item, func_coverage_mon) axi_wr_data_imp_cov;
    uvm_analysis_imp_axi_rd_data_cov #(axi_seq_item, func_coverage_mon) axi_rd_data_imp_cov;
    uvm_analysis_imp_axi_wr_rsp_cov #(axi_seq_item, func_coverage_mon) axi_wr_rsp_imp_cov;
    uvm_analysis_imp_ahb_data_cov #(ahb_seq_item, func_coverage_mon) ahb_data_imp_cov;

    axi_seq_item axi_wr_addr_q[$];
    axi_seq_item axi_wr_data_q[$];
    axi_seq_item axi_wr_rsp_q[$];
    axi_seq_item axi_rd_addr_q[$];
    axi_seq_item axi_rd_data_q[$];
    ahb_seq_item ahb_data_q[$];

    // Transaction items for comparison
    axi_seq_item axi_wr_addr_item;
    axi_seq_item axi_wr_data_item;
    axi_seq_item axi_rd_addr_item;
    axi_seq_item axi_rd_data_item;
    axi_seq_item axi_wr_rsp_item;
    ahb_seq_item ahb_data_item;


    // Data and address variables
    bit aligned_addr;


    // AXI Read Addr Covergroup
    covergroup cg_axi_rd_addr;
        cp_access: coverpoint axi_rd_addr_item.access {
            bins read = {READ_TRAN};
            bins write = {WRITE_TRAN};
        }
        cp_burst: coverpoint axi_rd_addr_item.burst {
            bins fixed = {FIXED};
            bins incr = {INCR};
            bins wrap = {WRAP};
        }
        cp_addr: coverpoint axi_rd_addr_item.addr {
            bins addr_1KB = {[0:1023]};
            bins addr_2KB = {[1024:2047]};
            bins addr_3KB = {[2048:3071]};
            bins addr_4KB = {[3072:4095]};
        }
        cp_data_size: coverpoint axi_rd_addr_item.data.size {
            bins data_below400 = {[0:400]};
            bins data_below800 = {[401:800]};
            bins data_below1KB = {[801:1024]};
        }
        cp_size: coverpoint axi_rd_addr_item.size {
            bins size_s1 = {1};
            bins size_s2 = {2};
            bins size_s4 = {4};
        }

        cp_ac_X_br: cross cp_access, cp_burst, cp_addr;


        cp_response: coverpoint axi_rd_addr_item.response {
            bins okay =   {OKAY};
            bins exokay = {EXOKAY};
            bins slverr = {SLVERR};
            bins decerr = {DECERR};
        }

        cp_align_unalign: coverpoint aligned_addr {
            bins addr_aligned = {1};
            bins addr_unaligned = {0};
        }
    endgroup


    // AXI write address Covergroup
    covergroup cg_axi_wr_addr;

        cp_burst: coverpoint axi_wr_addr_item.burst {
            bins fixed = {FIXED};
            bins incr = {INCR};
            bins wrap = {WRAP};
        }
        cp_addr: coverpoint axi_wr_addr_item.addr {
            bins addr_1KB = {[0:1023]};
            bins addr_2KB = {[1024:2047]};
            bins addr_3KB = {[2048:3071]};
            bins addr_4KB = {[3072:4095]};
        }
        cp_data_size: coverpoint axi_wr_addr_item.data.size {
            bins data_below400 = {[0:400]};
            bins data_below800 = {[401:800]};
            bins data_below1KB = {[801:1024]};
        }
        cp_size: coverpoint axi_wr_addr_item.size {
            bins size_s1 = {1};
            bins size_s2 = {2};
            bins size_s4 = {4};
        }

        cp_ac_X_br: cross cp_burst, cp_addr;

        cp_align_unalign: coverpoint aligned_addr {
            bins addr_aligned = {1};
            bins addr_unaligned = {0};
        }
    endgroup


    // AXI Covergroup
    covergroup cg_axi_wr_rsp;
        
        cp_response: coverpoint axi_wr_rsp_item.response {
            bins okay =   {OKAY};
            bins exokay = {EXOKAY};
            bins slverr = {SLVERR};
            bins decerr = {DECERR};
        }
    endgroup



    // AHB Covergroup
    covergroup cg_ahb;
        cp_access: coverpoint ahb_data_item.ACCESS_o {
            bins write = {1};
            bins read = {0};
        }
        cp_burst: coverpoint ahb_data_item.HBURST_o {
            bins single     = {0};
            bins undef_incr = {1};
            bins wrap_4     = {2};
            bins incr_4     = {3};
            bins wrap_8     = {4};
            bins incr_8     = {5};
            bins wrap_16    = {6};
            bins incr_16    = {7};
        }
        cp_size: coverpoint ahb_data_item.HSIZE_o {
            bins s_byte      = {0};
            bins s_half_word = {1};
            bins s_word      = {2};
        }
        cp_trans: coverpoint ahb_data_item.HTRANS_o {
            bins idle    = {0};
            bins busy    = {1};
            bins non_seq = {2};
            bins seq     = {3};
        }

        cp_BxTxA: cross cp_burst, cp_trans, cp_access;

        cp_addr: coverpoint ahb_data_item.HADDR_o {
            bins addr_low    = {[0:255]};
            bins addr_medium = {[256:511]};
            bins addr_big    = {[512:1023]};
        }
    endgroup

    // Constructor
    function new(string name = "func_coverage_mon", uvm_component parent = null);
        super.new(name, parent);
        cg_axi_rd_addr = new();
        cg_axi_wr_addr = new();
        cg_axi_wr_rsp = new();
        cg_ahb = new();
    endfunction

    // Build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_wr_addr_imp_cov = new("axi_wr_addr_imp_cov", this);
        axi_rd_addr_imp_cov = new("axi_rd_addr_imp_cov", this);
        axi_wr_data_imp_cov = new("axi_wr_data_imp_cov", this);
        axi_rd_data_imp_cov = new("axi_rd_data_imp_cov", this);
        axi_wr_rsp_imp_cov  = new("axi_wr_rsp_imp_cov", this);
        ahb_data_imp_cov    = new("ahb_data_imp_cov", this);

        axi_wr_addr_item    = axi_seq_item::type_id::create("axi_wr_addr_item");
        axi_wr_data_item    = axi_seq_item::type_id::create("axi_wr_data_item");
        axi_rd_addr_item    = axi_seq_item::type_id::create("axi_rd_addr_item");
        axi_rd_data_item    = axi_seq_item::type_id::create("axi_rd_data_item");
        axi_wr_rsp_item     = axi_seq_item::type_id::create("axi_wr_rsp_item");
        ahb_data_item       = ahb_seq_item::type_id::create("ahb_data_item");
    endfunction

    virtual function void write_axi_wr_addr_cov(axi_seq_item axi_wr_addr_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_wr_addr Analysis Imp Port"),UVM_LOW)
        axi_wr_addr_q.push_back(axi_wr_addr_item);
        wr_addr_cov_sample();
    endfunction

    virtual function void write_axi_rd_addr_cov(axi_seq_item axi_rd_addr_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_rd_addr Analysis Imp Port"),UVM_LOW)
        axi_rd_addr_q.push_back(axi_rd_addr_item);
        rd_addr_cov_sample();
    endfunction

    virtual function void write_axi_wr_data_cov(axi_seq_item axi_wr_data_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_wr_data Analysis Imp Port"),UVM_LOW)
        axi_wr_data_q.push_back(axi_wr_data_item);
    endfunction

    virtual function void write_axi_rd_data_cov(axi_seq_item axi_rd_data_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_rd_data Analysis Imp Port"),UVM_LOW)
        axi_rd_data_q.push_back(axi_rd_data_item);
    endfunction

    virtual function void write_axi_wr_rsp_cov(axi_seq_item axi_wr_rsp_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_wr_rsp Analysis Imp Port"),UVM_LOW)
        axi_wr_rsp_q.push_back(axi_wr_rsp_item);
        wr_rsp_cov_sample();
    endfunction

    virtual function void write_ahb_data_cov(ahb_seq_item ahb_data_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_ahb_data Analysis Imp Port"),UVM_LOW)
        ahb_data_q.push_back(ahb_data_item);
        ahb_cov_sample();
    endfunction



    function void rd_addr_cov_sample();
        if (axi_rd_addr_q.size()) begin
            axi_rd_addr_item = axi_rd_addr_q.pop_front();
            cg_axi_rd_addr.sample();
        end
    endfunction

    function void wr_addr_cov_sample();
        if (axi_wr_addr_q.size()) begin
            axi_wr_addr_item = axi_wr_addr_q.pop_front();
            cg_axi_wr_addr.sample();
        end
    endfunction

    function void wr_rsp_cov_sample();
        if (axi_wr_rsp_q.size()) begin
            axi_wr_rsp_item = axi_wr_rsp_q.pop_front();
            cg_axi_wr_rsp.sample();
        end
    endfunction

    function void ahb_cov_sample();
        if (ahb_data_q.size()) begin
            ahb_data_item = ahb_data_q.pop_front();
            cg_ahb.sample();
        end
    endfunction

endclass

`endif
