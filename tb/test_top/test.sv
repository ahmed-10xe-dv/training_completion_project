/*************************************************************************
   > File Name:   axi2ahb_test.sv
   > Description: This file implements the AXI to AHB testbench, which 
                  initializes the environment and sequences to verify the
                  AXI to AHB bridge functionality.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI2AHB_TEST
`define AXI2AHB_TEST

class axi2ahb_test extends uvm_test;
    `uvm_component_utils(axi2ahb_test)

    // Environment and sequence handles
    axi2ahb_env     env;                     // Environment handle
    virtual axi_interface axi_vif;           // Virtual interface for AXI signals
    virtual ahb_interface ahb_vif;           // Virtual interface for AXI signals
    configurations  cnfg;                    // Configurations
    // Command-line processor and variables
    uvm_cmdline_processor cmd_proc;
    string   value_as_string;
    int       Trans_Count;


    axi_wr_addr_sequence  wr_addr_seq;  // AXI Write Address Sequence
    axi_rd_addr_sequence  rd_addr_seq;  // AXI Read Address Sequence
    axi_wr_data_sequence  wr_data_seq;  // AXI Write Data Sequence
    axi_rd_data_sequence  rd_data_seq;  // AXI Read Data Sequence
    axi_wr_rsp_sequence   wr_rsp_seq;   // AXI Write Response Sequence
    ahb_sequence          ahb_seq;      // AHB Sequence
    ahb_error_seq         ahb_err_seq;   // AHB Sequence with error response
    ahb_slv_not_ready_seq ahb_slverr_seq;  // AHB Sequence with HREADY deasserted first and then asserted


    // Read Sequences
    fix_rd_addr_txn_beat1               fix_rd_beat1_h;                 
    fix_rd_addr_txn_beat2               fix_rd_beat2_h;                 
    fix_rd_addr_txn_beat16              fix_rd_beat16_h;                 
    fix_rd_addr_txn_beat19              fix_rd_beat19_h;                 
    fix_rd_addr_nrw1_txn_beat15         fix_rd_nrw1_beat15_h;                 
    fix_rd_addr_nrw1_txn_beat15x4       fix_rd_nrw1_beat15x4_h;                 
    fix_rd_addr_nrw2_txn_beat15         fix_rd_nrw2_beat15_h;                 
    fix_rd_addr_nrw2_txn_beat15x2       fix_rd_nrw2_beat15x2_h;                 
    fix_rd_addr_txn_beat2_unaligned     fix_rd_unaligned_h;                 
    incr_rd_addr_txn_len1               incr_rd_len1_h;                 
    incr_rd_addr_txn_len2               incr_rd_len2_h;                 
    incr_rd_addr_txn_len4               incr_rd_len4_h;                 
    incr_rd_addr_txn_len8               incr_rd_len8_h;                 
    incr_rd_addr_txn_len16              incr_rd_len16_h;                 
    incr_rd_addr_txn_len50              incr_rd_len50_h;                 
    incr_rd_addr_txn_len13              incr_rd_len13_h;                 
    incr_rd_addr_txn_len5               incr_rd_len5_h;                 
    incr_rd_addr_txn_len256             incr_rd_len256_h;                 
    incr_rd_addr_txn_nrw1               incr_rd_nrw1_h;                 
    incr_rd_addr_nrw1_txn_len256        incr_rd_nrw1_len256_h;                 
    incr_rd_addr_nrw2_txn_len8          incr_rd_nrw2_len8_h;                 
    incr_rd_mixed_size_txn              incr_rd_mixed_h;                 
    incr_rd_addr_txn_nrw2               incr_rd_nrw2_h;                 
    incr_rd_addr_txn_1kb_cross          incr_rd_1kb_cross_h;                 
    incr_rd_addr_unaligned_txn          incr_rd_unaligned_h;                 
    incr_rd_addr_nrw_unaligned_txn      incr_rd_nrw_unaligned_h;                 
    wrp2_rd_addr_txn                    wrp2_rd_h;                 
    wrp4_rd_addr_txn                    wrp4_rd_h;                 
    wrp8_rd_addr_txn                    wrp8_rd_h;                 
    wrp16_rd_addr_txn                   wrp16_rd_h;                 
    wrp2_rd_addr_nrw1_txn               wrp2_rd_nrw1_h;                 
    wrp4_rd_addr_nrw2_txn               wrp4_rd_nrw2_h;                 
    wrp8_rd_addr_nrw2_txn               wrp8_rd_nrw2_h;                 
    wrp16_rd_addr_nrw1_txn              wrp16_rd_nrw1_h;                 
    wrp4_rd_addr_misaligned_txn         wrp4_rd_misaligned_h;                 


    // Write Addr Sequences
    fix_wr_addr_txn_beat1              fix_wr_beat1_h;         
    fix_wr_addr_txn_beat2              fix_wr_beat2_h;         
    fix_wr_addr_txn_beat16             fix_wr_beat16_h;        
    fix_wr_addr_txn_beat19             fix_wr_beat19_h;        
    fix_wr_addr_nrw1_txn_beat15        fix_wr_nrw1_beat15_h;   
    fix_wr_addr_nrw1_txn_beat15x4      fix_wr_nrw1_beat15x4_h; 
    fix_wr_addr_nrw2_txn_beat15        fix_wr_nrw2_beat15_h;   
    fix_wr_addr_nrw2_txn_beat15x2      fix_wr_nrw2_beat15x2_h; 
    fix_wr_addr_txn_beat2_unaligned    fix_wr_unaligned_h;     
    incr_wr_addr_txn_len1              incr_wr_len1_h;         
    incr_wr_addr_txn_len2              incr_wr_len2_h;         
    incr_wr_addr_txn_len4              incr_wr_len4_h;         
    incr_wr_addr_txn_len8              incr_wr_len8_h;         
    incr_wr_addr_txn_len16             incr_wr_len16_h;        
    incr_wr_addr_txn_len50             incr_wr_len50_h;        
    incr_wr_addr_txn_len13             incr_wr_len13_h;        
    incr_wr_addr_txn_len5              incr_wr_len5_h;         
    incr_wr_addr_txn_len256            incr_wr_len256_h;       
    incr_wr_addr_txn_nrw1              incr_wr_nrw1_h;         
    incr_wr_addr_nrw1_txn_len256       incr_wr_nrw1_len256_h;  
    incr_wr_addr_nrw2_txn_len8         incr_wr_nrw2_len8_h;    
    incr_wr_mixed_size_txn             incr_wr_mixed_h;        
    incr_wr_addr_txn_nrw2              incr_wr_nrw2_h;         
    incr_wr_addr_txn_1kb_cross         incr_wr_1kb_cross_h;    
    incr_wr_addr_unaligned_txn         incr_wr_unaligned_h;    
    incr_wr_addr_nrw_unaligned_txn     incr_wr_nrw_unaligned_h;
    wrp2_wr_addr_txn                   wrp2_wr_h;              
    wrp4_wr_addr_txn                   wrp4_wr_h;              
    wrp8_wr_addr_txn                   wrp8_wr_h;              
    wrp16_wr_addr_txn                  wrp16_wr_h;             
    wrp2_wr_addr_nrw1_txn              wrp2_wr_nrw1_h;         
    wrp4_wr_addr_nrw2_txn              wrp4_wr_nrw2_h;         
    wrp8_wr_addr_nrw2_txn              wrp8_wr_nrw2_h;         
    wrp16_wr_addr_nrw1_txn             wrp16_wr_nrw1_h;        
    wrp4_wr_addr_misaligned_txn        wrp4_wr_misaligned_h;  
    
    // Write Data Sequences
    fix_wr_addr_txn_beat1              fix_wr_data_beat1_h;         
    fix_wr_addr_txn_beat2              fix_wr_data_beat2_h;         
    fix_wr_addr_txn_beat16             fix_wr_data_beat16_h;        
    fix_wr_addr_txn_beat19             fix_wr_data_beat19_h;        
    fix_wr_addr_nrw1_txn_beat15        fix_wr_data_nrw1_beat15_h;   
    fix_wr_addr_nrw1_txn_beat15x4      fix_wr_data_nrw1_beat15x4_h; 
    fix_wr_addr_nrw2_txn_beat15        fix_wr_data_nrw2_beat15_h;   
    fix_wr_addr_nrw2_txn_beat15x2      fix_wr_data_nrw2_beat15x2_h; 
    fix_wr_addr_txn_beat2_unaligned    fix_wr_data_unaligned_h;     
    incr_wr_addr_txn_len1              incr_wr_data_len1_h;         
    incr_wr_addr_txn_len2              incr_wr_data_len2_h;         
    incr_wr_addr_txn_len4              incr_wr_data_len4_h;         
    incr_wr_addr_txn_len8              incr_wr_data_len8_h;         
    incr_wr_addr_txn_len16             incr_wr_data_len16_h;        
    incr_wr_addr_txn_len50             incr_wr_data_len50_h;        
    incr_wr_addr_txn_len13             incr_wr_data_len13_h;        
    incr_wr_addr_txn_len5              incr_wr_data_len5_h;         
    incr_wr_addr_txn_len256            incr_wr_data_len256_h;       
    incr_wr_addr_txn_nrw1              incr_wr_data_nrw1_h;         
    incr_wr_addr_nrw1_txn_len256       incr_wr_data_nrw1_len256_h;  
    incr_wr_addr_nrw2_txn_len8         incr_wr_data_nrw2_len8_h;    
    incr_wr_mixed_size_txn             incr_wr_data_mixed_h;        
    incr_wr_addr_txn_nrw2              incr_wr_data_nrw2_h;         
    incr_wr_addr_txn_1kb_cross         incr_wr_data_1kb_cross_h;    
    incr_wr_addr_unaligned_txn         incr_wr_data_unaligned_h;    
    incr_wr_addr_nrw_unaligned_txn     incr_wr_data_nrw_unaligned_h;
    wrp2_wr_addr_txn                   wrp2_wr_data_h;              
    wrp4_wr_addr_txn                   wrp4_wr_data_h;              
    wrp8_wr_addr_txn                   wrp8_wr_data_h;              
    wrp16_wr_addr_txn                  wrp16_wr_data_h;             
    wrp2_wr_addr_nrw1_txn              wrp2_wr_data_nrw1_h;         
    wrp4_wr_addr_nrw2_txn              wrp4_wr_data_nrw2_h;         
    wrp8_wr_addr_nrw2_txn              wrp8_wr_data_nrw2_h;         
    wrp16_wr_addr_nrw1_txn             wrp16_wr_data_nrw1_h;        
    wrp4_wr_addr_misaligned_txn        wrp4_wr_data_misaligned_h; 

    //-----------------------------------------------------------------------------  
    // Function: new
    //-----------------------------------------------------------------------------  
    function new(string name = "axi2ahb_test", uvm_component parent = null);
        super.new(name, parent);
        wr_addr_seq = axi_wr_addr_sequence::type_id::create("wr_addr_seq");
        rd_addr_seq = axi_rd_addr_sequence::type_id::create("rd_addr_seq");
        wr_data_seq = axi_wr_data_sequence::type_id::create("wr_data_seq");
        rd_data_seq = axi_rd_data_sequence::type_id::create("rd_data_seq");
        wr_rsp_seq =  axi_wr_rsp_sequence::type_id::create("wr_rsp_seq");
        ahb_seq = ahb_sequence::type_id::create("ahb_seq");
        ahb_err_seq = ahb_error_seq::type_id::create("ahb_err_seq");
        ahb_slverr_seq = ahb_slv_not_ready_seq::type_id::create("ahb_slverr_seq");

        // Instantiate read sequences
        fix_rd_beat1_h           = fix_rd_addr_txn_beat1::type_id::create("fix_rd_beat1_h");
        fix_rd_beat2_h           = fix_rd_addr_txn_beat2::type_id::create("fix_rd_beat2_h");
        fix_rd_beat16_h          = fix_rd_addr_txn_beat16::type_id::create("fix_rd_beat16_h");
        fix_rd_beat19_h          = fix_rd_addr_txn_beat19::type_id::create("fix_rd_beat19_h");
        fix_rd_nrw1_beat15_h     = fix_rd_addr_nrw1_txn_beat15::type_id::create("fix_rd_nrw1_beat15_h");
        fix_rd_nrw1_beat15x4_h   = fix_rd_addr_nrw1_txn_beat15x4::type_id::create("fix_rd_nrw1_beat15x4_h");
        fix_rd_nrw2_beat15_h     = fix_rd_addr_nrw2_txn_beat15::type_id::create("fix_rd_nrw2_beat15_h");
        fix_rd_nrw2_beat15x2_h   = fix_rd_addr_nrw2_txn_beat15x2::type_id::create("fix_rd_nrw2_beat15x2_h");
        fix_rd_unaligned_h       = fix_rd_addr_txn_beat2_unaligned::type_id::create("fix_rd_unaligned_h");
        incr_rd_len1_h           = incr_rd_addr_txn_len1::type_id::create("incr_rd_len1_h");
        incr_rd_len2_h           = incr_rd_addr_txn_len2::type_id::create("incr_rd_len2_h");
        incr_rd_len4_h           = incr_rd_addr_txn_len4::type_id::create("incr_rd_len4_h");
        incr_rd_len8_h           = incr_rd_addr_txn_len8::type_id::create("incr_rd_len8_h");
        incr_rd_len16_h          = incr_rd_addr_txn_len16::type_id::create("incr_rd_len16_h");
        incr_rd_len50_h          = incr_rd_addr_txn_len50::type_id::create("incr_rd_len50_h");
        incr_rd_len13_h          = incr_rd_addr_txn_len13::type_id::create("incr_rd_len13_h");
        incr_rd_len5_h           = incr_rd_addr_txn_len5::type_id::create("incr_rd_len5_h");
        incr_rd_len256_h         = incr_rd_addr_txn_len256::type_id::create("incr_rd_len256_h");
        incr_rd_nrw1_h           = incr_rd_addr_txn_nrw1::type_id::create("incr_rd_nrw1_h");
        incr_rd_nrw1_len256_h    = incr_rd_addr_nrw1_txn_len256::type_id::create("incr_rd_nrw1_len256_h");
        incr_rd_nrw2_len8_h      = incr_rd_addr_nrw2_txn_len8::type_id::create("incr_rd_nrw2_len8_h");
        incr_rd_mixed_h          = incr_rd_mixed_size_txn::type_id::create("incr_rd_mixed_h");
        incr_rd_nrw2_h           = incr_rd_addr_txn_nrw2::type_id::create("incr_rd_nrw2_h");
        incr_rd_1kb_cross_h      = incr_rd_addr_txn_1kb_cross::type_id::create("incr_rd_1kb_cross_h");
        incr_rd_unaligned_h      = incr_rd_addr_unaligned_txn::type_id::create("incr_rd_unaligned_h");
        incr_rd_nrw_unaligned_h  = incr_rd_addr_nrw_unaligned_txn::type_id::create("incr_rd_nrw_unaligned_h");
        wrp2_rd_h                = wrp2_rd_addr_txn::type_id::create("wrp2_rd_h");
        wrp4_rd_h                = wrp4_rd_addr_txn::type_id::create("wrp4_rd_h");
        wrp8_rd_h                = wrp8_rd_addr_txn::type_id::create("wrp8_rd_h");
        wrp16_rd_h               = wrp16_rd_addr_txn::type_id::create("wrp16_rd_h");
        wrp2_rd_nrw1_h           = wrp2_rd_addr_nrw1_txn::type_id::create("wrp2_rd_nrw1_h");
        wrp4_rd_nrw2_h           = wrp4_rd_addr_nrw2_txn::type_id::create("wrp4_rd_nrw2_h");
        wrp8_rd_nrw2_h           = wrp8_rd_addr_nrw2_txn::type_id::create("wrp8_rd_nrw2_h");
        wrp16_rd_nrw1_h          = wrp16_rd_addr_nrw1_txn::type_id::create("wrp16_rd_nrw1_h");
        wrp4_rd_misaligned_h     = wrp4_rd_addr_misaligned_txn::type_id::create("wrp4_rd_misaligned_h");

        // Write Addr Sequences
        fix_wr_beat1_h              = fix_wr_addr_txn_beat1::type_id::create("fix_wr_beat1_h");
        fix_wr_beat2_h              = fix_wr_addr_txn_beat2::type_id::create("fix_wr_beat2_h");
        fix_wr_beat16_h             = fix_wr_addr_txn_beat16::type_id::create("fix_wr_beat16_h");
        fix_wr_beat19_h             = fix_wr_addr_txn_beat19::type_id::create("fix_wr_beat19_h");
        fix_wr_nrw1_beat15_h        = fix_wr_addr_nrw1_txn_beat15::type_id::create("fix_wr_nrw1_beat15_h");
        fix_wr_nrw1_beat15x4_h      = fix_wr_addr_nrw1_txn_beat15x4::type_id::create("fix_wr_nrw1_beat15x4_h");
        fix_wr_nrw2_beat15_h        = fix_wr_addr_nrw2_txn_beat15::type_id::create("fix_wr_nrw2_beat15_h");
        fix_wr_nrw2_beat15x2_h      = fix_wr_addr_nrw2_txn_beat15x2::type_id::create("fix_wr_nrw2_beat15x2_h");
        fix_wr_unaligned_h          = fix_wr_addr_txn_beat2_unaligned::type_id::create("fix_wr_unaligned_h");
        incr_wr_len1_h              = incr_wr_addr_txn_len1::type_id::create("incr_wr_len1_h");
        incr_wr_len2_h              = incr_wr_addr_txn_len2::type_id::create("incr_wr_len2_h");
        incr_wr_len4_h              = incr_wr_addr_txn_len4::type_id::create("incr_wr_len4_h");
        incr_wr_len8_h              = incr_wr_addr_txn_len8::type_id::create("incr_wr_len8_h");
        incr_wr_len16_h             = incr_wr_addr_txn_len16::type_id::create("incr_wr_len16_h");
        incr_wr_len50_h             = incr_wr_addr_txn_len50::type_id::create("incr_wr_len50_h");
        incr_wr_len13_h             = incr_wr_addr_txn_len13::type_id::create("incr_wr_len13_h");
        incr_wr_len5_h              = incr_wr_addr_txn_len5::type_id::create("incr_wr_len5_h");
        incr_wr_len256_h            = incr_wr_addr_txn_len256::type_id::create("incr_wr_len256_h");
        incr_wr_nrw1_h              = incr_wr_addr_txn_nrw1::type_id::create("incr_wr_nrw1_h");
        incr_wr_nrw1_len256_h       = incr_wr_addr_nrw1_txn_len256::type_id::create("incr_wr_nrw1_len256_h");
        incr_wr_nrw2_len8_h         = incr_wr_addr_nrw2_txn_len8::type_id::create("incr_wr_nrw2_len8_h");
        incr_wr_mixed_h             = incr_wr_mixed_size_txn::type_id::create("incr_wr_mixed_h");
        incr_wr_nrw2_h              = incr_wr_addr_txn_nrw2::type_id::create("incr_wr_nrw2_h");
        incr_wr_1kb_cross_h         = incr_wr_addr_txn_1kb_cross::type_id::create("incr_wr_1kb_cross_h");
        incr_wr_unaligned_h         = incr_wr_addr_unaligned_txn::type_id::create("incr_wr_unaligned_h");
        incr_wr_nrw_unaligned_h     = incr_wr_addr_nrw_unaligned_txn::type_id::create("incr_wr_nrw_unaligned_h");
        wrp2_wr_h                   = wrp2_wr_addr_txn::type_id::create("wrp2_wr_h");
        wrp4_wr_h                   = wrp4_wr_addr_txn::type_id::create("wrp4_wr_h");
        wrp8_wr_h                   = wrp8_wr_addr_txn::type_id::create("wrp8_wr_h");
        wrp16_wr_h                  = wrp16_wr_addr_txn::type_id::create("wrp16_wr_h");
        wrp2_wr_nrw1_h              = wrp2_wr_addr_nrw1_txn::type_id::create("wrp2_wr_nrw1_h");
        wrp4_wr_nrw2_h              = wrp4_wr_addr_nrw2_txn::type_id::create("wrp4_wr_nrw2_h");
        wrp8_wr_nrw2_h              = wrp8_wr_addr_nrw2_txn::type_id::create("wrp8_wr_nrw2_h");
        wrp16_wr_nrw1_h             = wrp16_wr_addr_nrw1_txn::type_id::create("wrp16_wr_nrw1_h");
        wrp4_wr_misaligned_h        = wrp4_wr_addr_misaligned_txn::type_id::create("wrp4_wr_misaligned_h");


        // Write Data Sequences
        fix_wr_data_beat1_h              = fix_wr_addr_txn_beat1::type_id::create("fix_wr_data_beat1_h");
        fix_wr_data_beat2_h              = fix_wr_addr_txn_beat2::type_id::create("fix_wr_data_beat2_h");
        fix_wr_data_beat16_h             = fix_wr_addr_txn_beat16::type_id::create("fix_wr_data_beat16_h");
        fix_wr_data_beat19_h             = fix_wr_addr_txn_beat19::type_id::create("fix_wr_data_beat19_h");
        fix_wr_data_nrw1_beat15_h        = fix_wr_addr_nrw1_txn_beat15::type_id::create("fix_wr_data_nrw1_beat15_h");
        fix_wr_data_nrw1_beat15x4_h      = fix_wr_addr_nrw1_txn_beat15x4::type_id::create("fix_wr_data_nrw1_beat15x4_h");
        fix_wr_data_nrw2_beat15_h        = fix_wr_addr_nrw2_txn_beat15::type_id::create("fix_wr_data_nrw2_beat15_h");
        fix_wr_data_nrw2_beat15x2_h      = fix_wr_addr_nrw2_txn_beat15x2::type_id::create("fix_wr_data_nrw2_beat15x2_h");
        fix_wr_data_unaligned_h          = fix_wr_addr_txn_beat2_unaligned::type_id::create("fix_wr_data_unaligned_h");
        incr_wr_data_len1_h              = incr_wr_addr_txn_len1::type_id::create("incr_wr_data_len1_h");
        incr_wr_data_len2_h              = incr_wr_addr_txn_len2::type_id::create("incr_wr_data_len2_h");
        incr_wr_data_len4_h              = incr_wr_addr_txn_len4::type_id::create("incr_wr_data_len4_h");
        incr_wr_data_len8_h              = incr_wr_addr_txn_len8::type_id::create("incr_wr_data_len8_h");
        incr_wr_data_len16_h             = incr_wr_addr_txn_len16::type_id::create("incr_wr_data_len16_h");
        incr_wr_data_len50_h             = incr_wr_addr_txn_len50::type_id::create("incr_wr_data_len50_h");
        incr_wr_data_len13_h             = incr_wr_addr_txn_len13::type_id::create("incr_wr_data_len13_h");
        incr_wr_data_len5_h              = incr_wr_addr_txn_len5::type_id::create("incr_wr_data_len5_h");
        incr_wr_data_len256_h            = incr_wr_addr_txn_len256::type_id::create("incr_wr_data_len256_h");
        incr_wr_data_nrw1_h              = incr_wr_addr_txn_nrw1::type_id::create("incr_wr_data_nrw1_h");
        incr_wr_data_nrw1_len256_h       = incr_wr_addr_nrw1_txn_len256::type_id::create("incr_wr_data_nrw1_len256_h");
        incr_wr_data_nrw2_len8_h         = incr_wr_addr_nrw2_txn_len8::type_id::create("incr_wr_data_nrw2_len8_h");
        incr_wr_data_mixed_h             = incr_wr_mixed_size_txn::type_id::create("incr_wr_data_mixed_h");
        incr_wr_data_nrw2_h              = incr_wr_addr_txn_nrw2::type_id::create("incr_wr_data_nrw2_h");
        incr_wr_data_1kb_cross_h         = incr_wr_addr_txn_1kb_cross::type_id::create("incr_wr_data_1kb_cross_h");
        incr_wr_data_unaligned_h         = incr_wr_addr_unaligned_txn::type_id::create("incr_wr_data_unaligned_h");
        incr_wr_data_nrw_unaligned_h     = incr_wr_addr_nrw_unaligned_txn::type_id::create("incr_wr_data_nrw_unaligned_h");
        wrp2_wr_data_h                   = wrp2_wr_addr_txn::type_id::create("wrp2_wr_data_h");
        wrp4_wr_data_h                   = wrp4_wr_addr_txn::type_id::create("wrp4_wr_data_h");
        wrp8_wr_data_h                   = wrp8_wr_addr_txn::type_id::create("wrp8_wr_data_h");
        wrp16_wr_data_h                  = wrp16_wr_addr_txn::type_id::create("wrp16_wr_h");
        wrp2_wr_data_nrw1_h              = wrp2_wr_addr_nrw1_txn::type_id::create("wrp2_wr_data_nrw1_h");
        wrp4_wr_data_nrw2_h              = wrp4_wr_addr_nrw2_txn::type_id::create("wrp4_wr_data_nrw2_h");
        wrp8_wr_data_nrw2_h              = wrp8_wr_addr_nrw2_txn::type_id::create("wrp8_wr_data_nrw2_h");
        wrp16_wr_data_nrw1_h             = wrp16_wr_addr_nrw1_txn::type_id::create("wrp16_wr_data_nrw1_h");
        wrp4_wr_data_misaligned_h        = wrp4_wr_addr_misaligned_txn::type_id::create("wrp4_wr_data_misaligned_h");

    endfunction : new

    //-----------------------------------------------------------------------------  
    // Function: build_phase
    //-----------------------------------------------------------------------------  
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_name(), "BUILD PHASE STARTED", UVM_LOW);
        if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
            `uvm_error(get_name(), "Failed to connect axi_vif interface")
        if (!uvm_config_db#(virtual ahb_interface)::get(null, "*", "ahb_vif", ahb_vif))
            `uvm_error(get_name(), "Failed to connect ahb_vif interface")

        // Create environment Set Configuration get inst from cmdline
        env = axi2ahb_env::type_id::create("env", this);   
        uvm_config_db #(configurations)::set(this, "*", "cnfg", cnfg);
        cmd_proc = uvm_cmdline_processor::get_inst ();
    endfunction : build_phase

    //-----------------------------------------------------------------------------  
    // Function: end_of_elaboration_phase
    //-----------------------------------------------------------------------------  
    function void end_of_elaboration_phase(uvm_phase phase);
        //The argument is named VALUE and it is expected to be a string
        if (cmd_proc.get_arg_value("+VALUE=", value_as_string))begin
              //convert to int
               Trans_Count = value_as_string.atoi();
              cnfg.Trans_Count = Trans_Count;
             `uvm_info("CMD_Value", $sformatf("Trans_Count is %d", Trans_Count), UVM_LOW)
         end
         else begin
            `uvm_info("CMD_Value", "It didnt work", UVM_LOW)
         end

        uvm_top.print_topology();
    endfunction : end_of_elaboration_phase

    //-----------------------------------------------------------------------------  
    // Task: main_phase
    // Description: Executes the test sequence during the main phase.
    //-----------------------------------------------------------------------------  
    task main_phase(uvm_phase phase);
        `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
        phase.raise_objection(this, "MAIN - raise_objection");
        fork
            fork
                wr_addr_seq.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
                rd_addr_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
                wr_data_seq.start(env.axi_env.wr_data_agnt.wr_data_sqr);
                rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
                wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
            join
            begin
                ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
            end
            #100;
        join_any
        phase.drop_objection(this, "MAIN - drop_objection");
        `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
    endtask : main_phase

    // This task is used to check the valid write transaction and controls the 
    //  test termination for read
    task terminate_after_beats(input int number);
        int count = 0;
        while (count < number) begin
          @(posedge axi_vif.ACLK);
          if (axi_vif.RVALID) begin
            count++; 
          end
        end
        disable fork;
      endtask

endclass : axi2ahb_test

`endif
