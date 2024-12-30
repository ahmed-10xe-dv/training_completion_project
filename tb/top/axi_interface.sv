/*************************************************************************
   > File Name:   axi_interface.sv
   > Description: AXI Interface definition for use in verification
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI_INTERFACE
`define AXI_INTERFACE

interface axi_interface #(
  parameter ID_WIDTH     = 4,              // ID width for AXI transactions
  parameter ADDR_WIDTH   = 32,             // Address width for AXI transactions
  parameter DATA_WIDTH   = 32,             // Data width for AXI transactions
  parameter STRB_WIDTH   = DATA_WIDTH / 8, // Write strobe width
  parameter LEN_WIDTH    = 8               // Burst length width
)(
  input logic ACLK,       // Clock signal
  input logic ARESETn     // Active-low reset signal
);

  /////////////////////////////////////////////////////////////////////////////
  // Read Address Channel Signals
  /////////////////////////////////////////////////////////////////////////////
  logic [ID_WIDTH-1:0]     ARID;       // Read transaction ID
  logic [ADDR_WIDTH-1:0]   ARADDR;     // Read address
  logic [LEN_WIDTH-1:0]    ARLEN;      // Burst length
  logic [2:0]              ARSIZE;     // Burst size
  logic [1:0]              ARBURST;    // Burst type
  logic [1:0]              ARLOCK;     // Lock signal
  logic                    ARVALID;    // Address valid
  logic                    ARREADY;    // Address ready
  logic [3:0]              ARCACHE;    // For Cache
  logic [2:0]              ARPROT;     // For Protection
  

  /////////////////////////////////////////////////////////////////////////////
  // Read Data Channel Signals
  /////////////////////////////////////////////////////////////////////////////
  logic [ID_WIDTH-1:0]     RID;        // Read transaction ID
  logic [DATA_WIDTH-1:0]   RDATA;      // Read data
  logic [1:0]              RRESP;      // Read response
  logic                    RLAST;      // Last transfer in burst
  logic                    RVALID;     // Read data valid
  logic                    RREADY;     // Read data ready

  /////////////////////////////////////////////////////////////////////////////
  // Write Address Channel Signals
  /////////////////////////////////////////////////////////////////////////////
  logic [ID_WIDTH-1:0]     AWID;       // Write transaction ID
  logic [ADDR_WIDTH-1:0]   AWADDR;     // Write address
  logic [LEN_WIDTH-1:0]    AWLEN;      // Burst length
  logic [2:0]              AWSIZE;     // Burst size
  logic [1:0]              AWBURST;    // Burst type
  logic [1:0]              AWLOCK;     // Lock signal
  logic                    AWVALID;    // Address valid
  logic                    AWREADY;    // Address ready
  logic [3:0]              AWCACHE;    // For Cache
  logic [2:0]              AWPROT;     // For Protection



  

  /////////////////////////////////////////////////////////////////////////////
  // Write Data Channel Signals
  /////////////////////////////////////////////////////////////////////////////
  logic [ID_WIDTH-1:0]     WID;        // Write Data transaction ID
  logic [DATA_WIDTH-1:0]   WDATA;      // Write data
  logic [STRB_WIDTH-1:0]   WSTRB;      // Write strobe
  logic                    WLAST;      // Last transfer in burst
  logic                    WVALID;     // Write data valid
  logic                    WREADY;     // Write data ready

  /////////////////////////////////////////////////////////////////////////////
  // Write Response Channel Signals
  /////////////////////////////////////////////////////////////////////////////
  logic [ID_WIDTH-1:0]     BID;        // Write response ID
  logic [1:0]              BRESP;      // Write response
  logic                    BVALID;     // Write response valid
  logic                    BREADY;     // Write response ready



  clocking driver_cb @(posedge ACLK);
    default input #1 output #1;
  
    // Write Address Channel
    output                     AWID;
    output                     AWADDR;
    output                     AWLEN;
    output                     AWSIZE;
    output                     AWBURST;
    output                     AWLOCK;
    output                     AWVALID;
    input                      AWREADY;
   
    // Write Data Channel
    output                      WID;
    output                      WDATA;
    output                      WSTRB;
    output                      WLAST;
    output                      WVALID;
    input                       WREADY;
  
    // Write Response Channel
    input                      BID;
    input                      BRESP;
    input                      BVALID;
    output                     BREADY;
  
    // Read Address Channel
    output                      ARID;
    output                      ARADDR;
    output                      ARLEN;
    output                      ARSIZE;
    output                      ARBURST;
    output                      ARLOCK;
    output                      ARVALID;
    input                       ARREADY;
  
    // Read Data Channel
    input                         RID;
    input                         RDATA;
    input                         RRESP;
    input                         RLAST;
    input                         RVALID;
    output                        RREADY;
    
  endclocking



  clocking monitor_cb @(posedge ACLK);
    default input #1 output #1;
  
    // Write Address Channel
    input                     AWID;
    input                     AWADDR;
    input                     AWLEN;
    input                     AWSIZE;
    input                     AWBURST;
    input                     AWLOCK;
    input                     AWVALID;
    input                     AWREADY;
  
    // Write Data Channel
    input                      WID;
    input                      WDATA;
    input                      WSTRB;
    input                      WLAST;
    input                      WVALID;
    input                      WREADY;
  
    // Write Response Channel
    input                      BID;
    input                      BRESP;
    input                      BVALID;
    input                      BREADY;
  
    // Read Address Channel
    input                      ARID;
    input                      ARADDR;
    input                      ARLEN;
    input                      ARSIZE;
    input                      ARBURST;
    input                      ARLOCK;
    input                      ARVALID;
    input                      ARREADY;
  
    // Read Data Channel
    input                        RID;
    input                        RDATA;
    input                        RRESP;
    input                        RLAST;
    input                        RVALID;
    input                        RREADY;
  endclocking


endinterface





`endif // AXI_INTERFACE
