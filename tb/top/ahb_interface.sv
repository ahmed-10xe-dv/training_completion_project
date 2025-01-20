/*************************************************************************
   > File Name:   ahb_interface.sv
   > Description: Parameterized AHB Interface
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AHB_INTERFACE
`define AHB_INTERFACE

interface ahb_interface #(
  parameter ADDR_WIDTH = 32,  // Address bus width
  parameter DATA_WIDTH = 32   // Data bus width
)(
  input logic HCLK,           // AHB clock signal
  input logic HRESETn         // AHB active-low reset signal
);

  /////////////////////////////////////////////////////////////////////////////
  // AHB Slave Interfaces
  /////////////////////////////////////////////////////////////////////////////
  logic [ADDR_WIDTH-1:0]  HADDR;        // Address bus
  logic [DATA_WIDTH-1:0]  HWDATA;       // Write data bus
  logic [DATA_WIDTH-1:0]  HRDATA;       // Read data bus
  logic                   HWRITE;       // Write control signal
  logic [2:0]             HSIZE;        // Transfer size
  logic [2:0]             HBURST;       // Burst type
  logic [1:0]             HTRANS;       // Transfer type
  logic                   HREADY;       // Ready input signal to master
  logic                   HRESP;        // Response signal
  logic [3:0]             HPROT;        // Protection
  logic                   HMASTLOCK;    // Master Lock


  //-------------------------------------------------------------------------
  // Driver Clocking Block
  // This block defines the signals driven by the driver during simulation, 
  // synchronized to the rising edge of HCLK.
  //-------------------------------------------------------------------------

  clocking driver_cb @(posedge HCLK);
    default input #1 output #1;
    input                       HADDR;
    input                       HWDATA;
    input                       HWRITE;
    input                       HSIZE;
    input                       HBURST;
    input                       HTRANS;
    output                      HRDATA;
    output                      HREADY;
    output                      HRESP;
  endclocking

  //-------------------------------------------------------------------------
  // Monitor Clocking Block
  // This block captures the signals driven by the AHB master and slave. The 
  // monitor observes and records these signals for comparison and debugging.
  //-------------------------------------------------------------------------

  clocking monitor_cb @(posedge HCLK);
    default input #1 output #1;
    input                        HADDR;
    input                        HWDATA;
    input                        HWRITE;
    input                        HSIZE;
    input                        HBURST;
    input                        HTRANS;
    input                        HRDATA;
    input                        HREADY;
    input                        HRESP;
  endclocking

    //Task for reset
  task reset_ahb();
    @(posedge HCLK);
    wait(!HRESETn);

    // Reset AXI interface signals to default
    HRESP  <= 'b0;
    HRDATA <= 'b0;
    HREADY <= 1'b1;

  endtask : reset_ahb

  //Task for post_reset
  task post_reset_ahb();
    wait(HRESETn);
    @(posedge HCLK);
  endtask : post_reset_ahb


  // Assertion to ensure that when HREADY is low, HADDR, HWRITE, and HWDATA remain stable
  // until HREADY goes high again. This checks the proper functioning of the AHB protocol
  // where the address, write control, and data signals must not change during a wait state.

  property HREADY_check;
    @(posedge HCLK) 
      (HREADY == 1'b0) |=> 
        $stable( HADDR &&  HWRITE &&  HWDATA);
  endproperty

// Assertion instantiation
  HREADY_check_assert: assert property (HREADY_check)
  else begin
    // Triggering UVM error when the assertion fails
    `uvm_error("HREADY_Check", 
      "Assertion failed: HADDR, HWRITE, and HWDATA are not stable while HREADY is low.");
  end

endinterface

`endif // AHB_INTERFACE


