
/*************************************************************************
   > File Name:   tb_top.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


`ifndef axi_interface
`define axi_interface

  interface axi_interface (input ACLK, input ARESETn);
    // Read Address Channel
    logic [3:0]                   ARID;
    logic [31:0]                  ARADDR;
    logic [7:0]                   ARLEN;
    logic [2:0]                   ARSIZE;
    logic [1:0]                   ARBURST;
    logic [1:0]                   ARLOCK;
    logic                         ARVALID;
    logic                         ARREADY;
  
    // Read Data Channel
    logic [3:0]                   RID;
    logic [31:0]                  RDATA;
    logic [1:0]                   RRESP;
    logic                         RLAST;
    logic                         RVALID;
    logic                         RREADY;
  
    // Write Address Channel
    logic [3:0]                   AWID;
    logic [31:0]                  AWADDR;
    logic [7:0]                   AWLEN;
    logic [2:0]                   AWSIZE;
    logic [1:0]                   AWBURST;
    logic [1:0]                   AWLOCK;
    logic                         AWVALID;
    logic                         AWREADY;
  
    // Write Data Channel
    logic [3:0]                   WID;
    logic [31:0]                  WDATA;
    logic [3:0]                   WSTRB;
    logic                         WLAST;
    logic                         WVALID;
    logic                         WREADY;
  
    // Write Response Channel
    logic [3:0]                   BID;
    logic [1:0]                   BRESP;
    logic                         BVALID;
    logic                         BREADY;
  endinterface

  `endif