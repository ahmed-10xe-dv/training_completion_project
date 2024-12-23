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


`ifndef AHB_INTF
`define AHB_INTF

interface ahb_interface (input HCLK, HRESETn);
//-------------------------------------------------------------------------
  // AHB Slave Interfaces
  // These signals are received by the AHB slave from the AHB master. The 
  // master initiates communication by driving these signals.
  //-------------------------------------------------------------------------

  logic      [          31:0] HADDR;       // Address bus
  logic      [          31:0] HWDATA;      // Write data bus
  logic      [          31:0] HRDATA;      // Read data bus
  logic                       HWRITE;      // Write control signal
  logic      [           2:0] HSIZE;       // Transfer size
  logic      [           2:0] HBURST;      // Burst type
  logic      [           1:0] HTRANS;      // Transfer type
  logic                       HREADY;      // Ready input signal to master
  logic                       HRESP;       // Response signal

  endinterface
  `endif

//   

