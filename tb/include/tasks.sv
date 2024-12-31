    // // Parameters for burst types
    // parameter single = 3'b000;
    // parameter incr   = 3'b001;
    // parameter wrap4  = 3'b010;
    // parameter incr4  = 3'b011;
    // parameter wrap8  = 3'b100;
    // parameter incr8  = 3'b101;
    // parameter wrap16 = 3'b110;
    // parameter incr16 = 3'b111;

    //     // Task to get address
    //     task get_address(output bit [31:0] addr);
    //         wait(ahb_vif.HREADY);
    //         addr = ahb_vif.HADDR;
    //     endtask



//     /*************************************************************************
//    > File Name:   ahb_driver.sv
//    > Description: This file implements the AHB driver class, which extends 
//                   the UVM driver to handle AHB transactions based on sequence items.
//    > Author:      Ahmed Raza
//    > Modified:    Ahmed Raza
//    > Mail:        ahmed.raza@10xengineers.ai
//    ---------------------------------------------------------------
//    Copyright   (c)2024 10xEngineers
//    ---------------------------------------------------------------
// ************************************************************************/

// `ifndef AHB_DRIVER
// `define AHB_DRIVER

// `define DRIV_IF ahb_vif.driver_cb
// `define MON_IF  ahb_vif.monitor_cb

// class ahb_driver extends uvm_driver #(ahb_seq_item);

//   `uvm_component_utils(ahb_driver)

//   ahb_seq_item seq;                     // Sequence item for AHB transactions
//   bit [7:0] wr_array[4095:0];              // Data array for transactions
//   bit [7:0] rd_array[4095:0];              // Data array for transactions

//   virtual ahb_interface ahb_vif;        // Virtual interface for AHB protocol

//   // Constructor
//   function new(string name = "ahb_driver", uvm_component parent = null);
//     super.new(name, parent);
//   endfunction : new

//   //-----------------------------------------------------------------------------
//   // Build Phase
//   //-----------------------------------------------------------------------------
//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     seq = ahb_seq_item::type_id::create("RESPONSE_HANDLER", this);
//     `uvm_info(get_full_name(), "BUILD PHASE @ Driver", UVM_LOW)
//   endfunction : build_phase

//   //-----------------------------------------------------------------------------
//   // Connect Phase
//   //-----------------------------------------------------------------------------
//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     if (!uvm_config_db#(virtual ahb_interface)::get(this, "*", "ahb_vif", ahb_vif))
//       `uvm_error("Config Error", "Configuration Failed @ Connect Phase in AHB Driver")
//   endfunction : connect_phase

//   //-----------------------------------------------------------------------------
//   // Reset Phase
//   //-----------------------------------------------------------------------------
//   task reset_phase(uvm_phase phase);
//     phase.raise_objection(this);
//     @(posedge ahb_vif.HCLK);
//     wait(!ahb_vif.HRESETn);

//     // Reset AXI interface signals to default
//     ahb_vif.HRESP  <= 'b0;
//     ahb_vif.HRDATA <= 'b0;
//     ahb_vif.HREADY <= 1'b1;

//     `uvm_info(get_name(), "Reset phase: Signals reset to default", UVM_LOW)
//     phase.drop_objection(this);
//   endtask : reset_phase

//   //-----------------------------------------------------------------------------
//   // Post Reset Phase
//   //-----------------------------------------------------------------------------
//   task post_reset_phase(uvm_phase phase);
//     phase.raise_objection(this);
//     @(posedge ahb_vif.HCLK);
//     wait(ahb_vif.HRESETn);
//     @(posedge ahb_vif.HCLK);
//     `uvm_info(get_name(),$sformatf("Reset Condition Over"), UVM_LOW)
//     phase.drop_objection(this);
//   endtask : post_reset_phase

//   //-----------------------------------------------------------------------------
//   // Main Phase
//   //-----------------------------------------------------------------------------
//   task main_phase(uvm_phase phase);
//     `uvm_info(get_full_name(), "Main Phase Started", UVM_LOW)
//     forever begin
//       drive();
//     end
//     `uvm_info(get_name(), "Main Phase Ended", UVM_LOW)
//   endtask : main_phase

//   //-----------------------------------------------------------------------------
//   // Task: drive
//   //-----------------------------------------------------------------------------
//   task drive();
//     seq_item_port.get_next_item(req);
    
//     ahb_vif.HREADY <= 1'b1;
//     @(posedge ahb_vif.HCLK);

//     // if (ahb_vif.HWRITE) begin
//       `uvm_info(get_full_name(), "Entering AHB Driver Write Data Task", UVM_LOW)

//       foreach (wr_array[m]) begin  //Initialize Array
//         wr_array[m] = 32'hffffffff;
//       end

//       wait(ahb_vif.HTRANS);
//       while (!ahb_vif.HTRANS[1]) begin     //Handle IDLE and BUSY transfer
//         if (ahb_vif.HTRANS == 2'b01) begin // Busy state
//           @(posedge ahb_vif.HCLK);
//           `uvm_info(get_full_name(), "AHB Driver Write - Slave Busy", UVM_LOW)
//           continue;
//         end
//       end
  
//       `uvm_info(get_full_name(), "AHB Driver Write - Valid Transfer Detected", UVM_LOW)
//       for (int i = 0; i < 2**ahb_vif.HSIZE; ++i) begin
//         for (int j = 0; j < 8; ++j) begin
//           wr_array[ahb_vif.HADDR][j] = ahb_vif.HWDATA[(i * 8) + j];
//         end
//       end
  
//       `uvm_info(get_full_name(), "AHB Driver Write - Write Completed", UVM_LOW)
//     // end

//     // else begin
//     //   `uvm_info(get_full_name(), "Entering AHB Driver Read Data Task", UVM_LOW)
//     //   foreach (req.data[m]) begin  //Initialize Array
//     //     rd_array[m] = req.data[m];
//     //   end
  
//     //   wait(ahb_vif.HTRANS);
//     //   while (!ahb_vif.HTRANS[1]) begin     //Handle IDLE and BUSY transfer
//     //     if (ahb_vif.HTRANS == 2'b01) begin // Busy state
//     //       @(posedge ahb_vif.HCLK);
//     //       `uvm_info(get_full_name(), "AHB Driver READ - Slave Busy", UVM_LOW)
//     //       continue;
//     //     end
//     //   end
  
//     //   `uvm_info(get_full_name(), "AHB Driver Read - Valid Transfer Detected", UVM_LOW)
//     //   for (int i = 0; i < 2**ahb_vif.HSIZE; ++i) begin
//     //     for (int j = 0; j < 8; ++j) begin
//     //       ahb_vif.HRDATA[(i * 8) + j] <= rd_array[ahb_vif.HADDR][j];
//     //     end
//     //   end
  
//     //   `uvm_info(get_full_name(), "AHB Driver Read - Read Completed", UVM_LOW)
//     // end

//     ahb_vif.HRESP  <= req.resp;   // Collect Response
//     ahb_vif.HREADY <= 1'b0;      // Extend transfer if necessary
//     @(posedge ahb_vif.HCLK);
//     ahb_vif.HREADY <= 1'b1;
    
//     seq_item_port.item_done();
//   endtask : drive

// endclass : ahb_driver

// `endif



/*************************************************************************
   > File Name:   tb_top.sv
   > Description: Tesstbench top module for AXI to AHB Bridge Verification
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


// `ifndef TB_TOP
// `define TB_TOP

`timescale 1ns/1ps

`include "uvm_macros.svh"
import uvm_pkg::*;


`include "../include/bus_params_pkg.sv"
`include "../include/mem_model_pkg.sv"
// import mem_model_pkg::*;
`include "../include/dv_macros.svh"
`include "../include/mem_model.sv"


//Interfaces and Defines
// `include "../include/defines.svh"
`include "axi_interface.sv"
`include "ahb_interface.sv"

//Sequences and Sequence Items
`include "../../sim/axi_seq_item.sv"
`include "../../sim/axi_sequence.sv"
`include "../../sim/ahb_seq_item.sv"
`include "../../sim/ahb_sequence.sv"

//Write Address Agent
`include "../agent/axi_agent/wr_addr_agent/wr_addr_sequencer.sv"
`include "../agent/axi_agent/wr_addr_agent/wr_addr_driver.sv"
`include "../agent/axi_agent/wr_addr_agent/wr_addr_monitor.sv"
`include "../agent/axi_agent/wr_addr_agent/wr_addr_agent.sv"

//Read Address Agent
`include "../agent/axi_agent/rd_addr_agent/rd_addr_sequencer.sv"
`include "../agent/axi_agent/rd_addr_agent/rd_addr_driver.sv"
`include "../agent/axi_agent/rd_addr_agent/rd_addr_monitor.sv"
`include "../agent/axi_agent/rd_addr_agent/rd_addr_agent.sv"

//Write Data Agent
`include "../agent/axi_agent/wr_data_agent/wr_data_sequencer.sv"
`include "../agent/axi_agent/wr_data_agent/wr_data_driver.sv"
`include "../agent/axi_agent/wr_data_agent/wr_data_monitor.sv"
`include "../agent/axi_agent/wr_data_agent/wr_data_agent.sv"

//Read Data Agent
`include "../agent/axi_agent/rd_data_agent/rd_data_sequencer.sv"
`include "../agent/axi_agent/rd_data_agent/rd_data_driver.sv"
`include "../agent/axi_agent/rd_data_agent/rd_data_monitor.sv"
`include "../agent/axi_agent/rd_data_agent/rd_data_agent.sv"

//AHB Agent
`include "../agent/ahb_agent/ahb_sequencer.sv"
`include "../agent/ahb_agent/ahb_driver.sv"
`include "../agent/ahb_agent/ahb_monitor.sv"
`include "../agent/ahb_agent/ahb_agent.sv"

// Multi-Seq
`include "../multiseq/multi_sequencer.sv"
`include "../multiseq/multi_seq.sv"

//Axi2Ahb Environment and test
`include "../env/axi2ahb_scoreboard.sv"
`include "../env/axi2ahb_env.sv"
`include "../test_top/test.sv"


module tb_top;

  ////////////////////////////////////////////////////////////////////////////////
  // Reset and Clock Generation
  ////////////////////////////////////////////////////////////////////////////////
    
  bit clk;
  bit reset;
  
  initial begin
    reset = 1'b0;
    #100;
    reset = 1'b1;
    // #500;
    // reset = 1'b0;
    // #100;
    // reset = 1'b1;
  end

  initial begin
    clk = 1'b0;
    forever #10 clk = ~clk;
  end

  ////////////////////////////////////////////////////////////////////////////////
  // Interface Instance
  ////////////////////////////////////////////////////////////////////////////////

  axi_interface axi_if (.ACLK(clk), .ARESETn(reset));
  ahb_interface ahb_if (.HCLK(clk), .HRESETn(reset));

  ////////////////////////////////////////////////////////////////////////////////
  // DUT Instantiation
  ////////////////////////////////////////////////////////////////////////////////
  
  axi_ahblite_bridge_0 axi_ahb_bridge (
    .s_axi_aclk            (clk),
    .s_axi_aresetn         (reset),
    .s_axi_awid            (axi_if.AWID),
    .s_axi_awlen           (axi_if.AWLEN),
    .s_axi_awsize          (axi_if.AWSIZE),
    .s_axi_awburst         (axi_if.AWBURST),
    .s_axi_awcache         (axi_if.AWCACHE),    
    .s_axi_awaddr          (axi_if.AWADDR),
    .s_axi_awprot          (axi_if.AWPROT),               
    .s_axi_awvalid         (axi_if.AWVALID),
    .s_axi_awready         (axi_if.AWREADY),
    .s_axi_awlock          (axi_if.AWLOCK),              
    .s_axi_wdata           (axi_if.WDATA),
    .s_axi_wstrb           (axi_if.WSTRB),
    .s_axi_wlast           (axi_if.WLAST),
    .s_axi_wvalid          (axi_if.WVALID),
    .s_axi_wready          (axi_if.WREADY),
    .s_axi_bid             (axi_if.BID),
    .s_axi_bresp           (axi_if.BRESP),
    .s_axi_bvalid          (axi_if.BVALID),
    .s_axi_bready          (axi_if.BREADY),
    .s_axi_arid            (axi_if.ARID),
    .s_axi_araddr          (axi_if.ARADDR),
    .s_axi_arprot          (axi_if.ARPROT),                                   
    .s_axi_arcache         (axi_if.ARCACHE),            
    .s_axi_arvalid         (axi_if.ARVALID),
    .s_axi_arlen           (axi_if.ARLEN),
    .s_axi_arsize          (axi_if.ARSIZE),
    .s_axi_arburst         (axi_if.ARBURST),
    .s_axi_arlock          (axi_if.ARLOCK),  
    .s_axi_arready         (axi_if.ARREADY),
    .s_axi_rid             (axi_if.RID),
    .s_axi_rdata           (axi_if.RDATA),
    .s_axi_rresp           (axi_if.RRESP),
    .s_axi_rvalid          (axi_if.RVALID),
    .s_axi_rlast           (axi_if.RLAST),
    .s_axi_rready          (axi_if.RREADY),
    .m_ahb_haddr           (ahb_if.HADDR),
    .m_ahb_hwrite          (ahb_if.HWRITE),
    .m_ahb_hsize           (ahb_if.HSIZE),
    .m_ahb_hburst          (ahb_if.HBURST),
    .m_ahb_hprot           (ahb_if.HPROT),                   
    .m_ahb_htrans          (ahb_if.HTRANS),
    .m_ahb_hmastlock       (ahb_if.HMASTLOCK),               
    .m_ahb_hwdata          (ahb_if.HWDATA),
    .m_ahb_hready          (ahb_if.HREADY),
    .m_ahb_hrdata          (ahb_if.HRDATA),
    .m_ahb_hresp           (ahb_if.HRESP)
  );

  //////////////////////////////////////////////////////////////////////////////
  // // UVM Phases Execution
  //////////////////////////////////////////////////////////////////////////////
  initial begin
    run_test("axi2ahb_test");
  end

  ////////////////////////////////////////////////////////////////////////////////
  // Configuration Database Setup
  ////////////////////////////////////////////////////////////////////////////////
  initial begin
    uvm_config_db#(virtual axi_interface)::set(null, "*", "axi_vif", axi_if);
    uvm_config_db#(virtual ahb_interface)::set(null, "*", "ahb_vif", ahb_if);
  end

  initial begin
    $dumpfile("bridge_waveform.vcd");
    $dumpvars;
  end

endmodule

// `endif