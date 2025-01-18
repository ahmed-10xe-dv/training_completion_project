/*************************************************************************
   > File Name:   func_coverage.sv
   > Description: This file implements the functional coverage class 
                  for AXI transactions, including write address, 
                  read address, and write response coverage groups. 
                  It extends the UVM component and uses analysis 
                  ports to capture AXI transactions and sample coverage.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef FUNC_COVERAGE
`define FUNC_COVERAGE

// Analysis port declarations for AXI coverage
`uvm_analysis_imp_decl(_axi_wr_addr_cov)
`uvm_analysis_imp_decl(_axi_rd_addr_cov)
`uvm_analysis_imp_decl(_axi_wr_rsp_cov)

// Class definition for functional coverage
class func_coverage extends uvm_component;

    // Register the component with UVM factory
    `uvm_component_utils(func_coverage)

    // Analysis ports for AXI transactions
    uvm_analysis_imp_axi_wr_addr_cov #(axi_seq_item, func_coverage) axi_wr_addr_imp_cov;
    uvm_analysis_imp_axi_rd_addr_cov #(axi_seq_item, func_coverage) axi_rd_addr_imp_cov;
    uvm_analysis_imp_axi_wr_rsp_cov #(axi_seq_item, func_coverage) axi_wr_rsp_imp_cov;

    // Transaction items for coverage sampling
    axi_seq_item axi_wr_addr_item;
    axi_seq_item axi_rd_addr_item;
    axi_seq_item axi_wr_rsp_item;

    // Address alignment flag
    bit aligned_addr;

    // AXI Read Address Coverage Group
    covergroup cg_axi_rd_addr;
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
        cp_len : coverpoint axi_rd_addr_item.burst_length {
            bins bin1       = {1};
            bins bin2_15    = {[2:15]};
            bins bin16      = {16};
            bins bin17_255  = {[17:255]};
            bins bin256     = {256};
        }
        cp_size: coverpoint axi_rd_addr_item.size {
            bins byte_size = {0};
            bins hw_size = {1};
            bins w_size = {2};
        }
        cp_response: coverpoint axi_rd_addr_item.response {
            bins okay = {OKAY};
            ignore_bins exokay = {EXOKAY};
            bins slverr = {SLVERR};
            ignore_bins decerr = {DECERR};
        }
        cp_align_unalign: coverpoint aligned_addr {
            bins addr_aligned = {1};
            bins addr_unaligned = {0};
        }
    endgroup

    // AXI Write Address Coverage Group
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
        cp_len : coverpoint axi_wr_addr_item.burst_length {
            bins bin1       = {1};
            bins bin2_15    = {[2:15]};
            bins bin16      = {16};
            bins bin17_255  = {[17:255]};
            bins bin256     = {256};
        }
        cp_size: coverpoint axi_wr_addr_item.size {
            bins byte_size = {0};
            bins hw_size = {1};
            bins w_size = {2};
        }
        cp_align_unalign: coverpoint aligned_addr {
            bins addr_aligned = {1};
            bins addr_unaligned = {0};
        }
    endgroup

    // AXI Write Response Coverage Group
    covergroup cg_axi_wr_rsp;
        cp_response: coverpoint axi_wr_rsp_item.response {
            bins okay = {OKAY};
            ignore_bins exokay = {EXOKAY};
            bins slverr = {SLVERR};
            ignore_bins decerr = {DECERR};
        }
    endgroup

    // Constructor
    function new(string name = "func_coverage", uvm_component parent = null);
        super.new(name, parent);
        cg_axi_rd_addr = new();
        cg_axi_wr_addr = new();
        cg_axi_wr_rsp = new();
    endfunction

    // Build Phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        axi_wr_addr_imp_cov = new("axi_wr_addr_imp_cov", this);
        axi_rd_addr_imp_cov = new("axi_rd_addr_imp_cov", this);
        axi_wr_rsp_imp_cov  = new("axi_wr_rsp_imp_cov", this);

        axi_wr_addr_item = axi_seq_item::type_id::create("axi_wr_addr_item");
        axi_rd_addr_item = axi_seq_item::type_id::create("axi_rd_addr_item");
        axi_wr_rsp_item  = axi_seq_item::type_id::create("axi_wr_rsp_item");
    endfunction

    // Write Method for AXI Write Address Coverage
    virtual function void write_axi_wr_addr_cov(axi_seq_item axi_wr_addr_item);
        `uvm_info(get_type_name(), $sformatf("Received transaction on write_axi_wr_addr Analysis Port"), UVM_LOW)
        aligned_addr = (axi_wr_addr_item.addr % 4 == 0) ? 1 : 0;
        cg_axi_wr_addr.sample();
    endfunction

    // Write Method for AXI Read Address Coverage
    virtual function void write_axi_rd_addr_cov(axi_seq_item axi_rd_addr_item);
        `uvm_info(get_type_name(), $sformatf("Received transaction on write_axi_rd_addr Analysis Port"), UVM_LOW)
        aligned_addr = (axi_rd_addr_item.addr % 4 == 0) ? 1 : 0;
        cg_axi_rd_addr.sample();
    endfunction

    // Write Method for AXI Write Response Coverage
    virtual function void write_axi_wr_rsp_cov(axi_seq_item axi_wr_rsp_item);
        `uvm_info(get_type_name(), $sformatf("Received transaction on write_axi_wr_rsp Analysis Port"), UVM_LOW)
        cg_axi_wr_rsp.sample();
    endfunction
endclass

`endif // FUNC_COVERAGE
