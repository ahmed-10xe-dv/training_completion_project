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

  //Task for reset
  task reset_axi();

    @(posedge ACLK);
    wait(!ARESETn);

    // Reset AXI interface signals to default
    ARADDR    <= 'b0;
    ARID      <= 'b0;
    ARLEN     <= 'b0;
    ARSIZE    <= 'b0;
    ARBURST   <= 'b0;
    ARLOCK    <= `RD_ADDR_LOCK;
    ARVALID   <= 1'b0;
    ARCACHE   <= `RD_ADDR_CACHE;
    ARPROT    <= `RD_ADDR_PROT;
    RDATA     <= 'b0;
    RID       <= 'b0;
    RLAST     <= 'b0;
    RVALID    <= 1'b0;
    RREADY    <= 1'b0;
    RRESP     <= 1'b0;
    AWADDR    <= 'b0;
    AWID      <= 'b0;
    AWLEN     <= 'b0;
    AWSIZE    <= 'b0;
    AWBURST   <= 'b0;
    AWLOCK    <= `WR_ADDR_LOCK;
    AWVALID   <= 1'b0;
    AWCACHE   <= `WR_ADDR_CACHE;
    AWPROT    <= `WR_ADDR_PROT;
    WSTRB     <= 'b0;
    WDATA     <= 'b0;
    WID       <= 'b0;
    WLAST     <= 'b0;
    WVALID    <= 1'b0;
    BREADY    <= 1'b0;

  endtask : reset_axi

  //Task for post_reset
  task post_reset_axi();
    wait(ARESETn);
    @(posedge ACLK);
  endtask : post_reset_axi

  /////////////////////////////////////////////////////////////////////////////
  // Coverage Group for Read Address Channel
  /////////////////////////////////////////////////////////////////////////////
  logic aligned_addr; // Address alignment flag

  // Covergroup to monitor read address channel
  covergroup cg_axi_rd_addr @(posedge ACLK);
      // Burst type
      cp_burst: coverpoint ARBURST {
          bins fixed = {0};
          bins incr = {1};
          bins wrap = {2};
      }

      // Address
      cp_addr: coverpoint ARADDR {
          bins addr_1KB = {[0:1023]};
          bins addr_2KB = {[1024:2047]};
          bins addr_3KB = {[2048:3071]};
          bins addr_4KB = {[3072:4095]};
      }

      // Burst length
      cp_len: coverpoint ARLEN {
          bins bin1       = {0};
          bins bin2_15    = {[1:14]};
          bins bin16      = {15};
          bins bin17_255  = {[16:255]};
          bins bin256     = {255};
      }

      // Burst size
      cp_size: coverpoint ARSIZE {
          bins byte_size = {0};
          bins hw_size   = {1};
          bins w_size    = {2};
      }

      // Response
      cp_response: coverpoint RRESP {
          bins okay           = {0};
          ignore_bins exokay  = {1};
          bins slverr         = {2};
          ignore_bins decerr  = {3};
      }

      // Address alignment
      cp_align_unalign: coverpoint aligned_addr {
          bins addr_aligned   = {1};
          bins addr_unaligned = {0};
      }

      // Burst type and size cross
      cp_burst_size: cross cp_size, cp_burst;

      // Burst type and length cross with valid combinations
      cross_burst_len: cross cp_burst, cp_len {
          // Valid combinations for FIXED burst type
          ignore_bins fixed_invalid = binsof(cp_burst) intersect {0} &&
                                      !(binsof(cp_len) intersect {[0:15]});

          // Valid combinations for INCR burst type
          ignore_bins incr_invalid = binsof(cp_burst) intersect {1} &&
                                     !(binsof(cp_len) intersect {[0:255]});

          // Valid combinations for WRAP burst type
          ignore_bins wrap_invalid = binsof(cp_burst) intersect {2} &&
                                     !(binsof(cp_len) intersect {1, 3, 7, 15});
      }
  endgroup

    /////////////////////////////////////////////////////////////////////////////
    // Write Address Coverage Group
    /////////////////////////////////////////////////////////////////////////////
    covergroup cg_axi_wr_addr @(posedge ACLK);
        // Burst type
        cp_burst: coverpoint AWBURST {
          bins fixed = {0};
          bins incr = {1};
          bins wrap = {2};
        }
  
        // Address
        cp_addr: coverpoint AWADDR {
            bins addr_1KB = {[0:1023]};
            bins addr_2KB = {[1024:2047]};
            bins addr_3KB = {[2048:3071]};
            bins addr_4KB = {[3072:4095]};
        }
  
        // Burst length
        cp_len: coverpoint AWLEN {
          bins bin1       = {0};
          bins bin2_15    = {[1:14]};
          bins bin16      = {15};
          bins bin17_255  = {[16:255]};
          bins bin256     = {255};
        }
  
        // Burst size
        cp_size: coverpoint AWSIZE {
            bins byte_size = {0};
            bins hw_size   = {1};
            bins w_size    = {2};
        }
  
        // Address alignment
        cp_align_unalign: coverpoint aligned_addr {
            bins addr_aligned   = {1};
            bins addr_unaligned = {0};
        }
  
        // Burst type and size cross
        cp_burst_size: cross cp_size, cp_burst;

          // Burst type and length cross with valid combinations
      cross_burst_len: cross cp_burst, cp_len {
        // Valid combinations for FIXED burst type
        ignore_bins fixed_invalid = binsof(cp_burst) intersect {0} &&
                                    !(binsof(cp_len) intersect {[0:15]});

        // Valid combinations for INCR burst type
        ignore_bins incr_invalid = binsof(cp_burst) intersect {1} &&
                                   !(binsof(cp_len) intersect {[0:255]});

        // Valid combinations for WRAP burst type
        ignore_bins wrap_invalid = binsof(cp_burst) intersect {2} &&
                                   !(binsof(cp_len) intersect {1, 3, 7, 15});
    }
    endgroup
  
    /////////////////////////////////////////////////////////////////////////////
    // Write Response Coverage Group
    /////////////////////////////////////////////////////////////////////////////
    covergroup cg_axi_wr_rsp @(posedge ACLK);
        // Write response
        cp_response: coverpoint BRESP {
          bins okay           = {0};
          ignore_bins exokay  = {1};
          bins slverr         = {2};
          ignore_bins decerr  = {3};
        }
    endgroup
  
    /////////////////////////////////////////////////////////////////////////////
    // Coverage Sampling Logic
    /////////////////////////////////////////////////////////////////////////////
    
    /////////////////////////////////////////////////////////////////////////////
    // Declare Covergroup Instances
    /////////////////////////////////////////////////////////////////////////////
    cg_axi_wr_addr cg_axi_wr_addr_inst;
    cg_axi_wr_rsp cg_axi_wr_rsp_inst;
    cg_axi_rd_addr cg_axi_rd_addr_inst;

    /////////////////////////////////////////////////////////////////////////////
    // Initialize the Covergroups
    /////////////////////////////////////////////////////////////////////////////
    initial begin
        cg_axi_wr_addr_inst = new(); // Instantiate write address coverage group

        // Sample write address coverage on AWVALID and AWREADY
        forever @(posedge ACLK) begin
            if (AWVALID && AWREADY) begin
                // Compute alignment flag
                aligned_addr = (AWADDR % (1 << AWSIZE)) == 0;

                // Trigger coverage sampling
                cg_axi_wr_addr_inst.sample();
            end
        end
    end

    initial begin
        cg_axi_wr_rsp_inst = new(); // Instantiate write response coverage group

        // Sample write response coverage on BVALID and BREADY
        forever @(posedge ACLK) begin
            if (BVALID && BREADY) begin
                cg_axi_wr_rsp_inst.sample();
            end
        end
    end

  initial begin
      cg_axi_rd_addr_inst = new(); // Instantiate read address coverage group

      // Sample read address coverage on RVALID and RREADY
      forever @(posedge ACLK) begin
          if (RVALID && RREADY) begin
              // Compute alignment flag
              aligned_addr = (ARADDR % (1 << ARSIZE)) == 0;

              // Trigger coverage sampling
              cg_axi_rd_addr_inst.sample();
          end
      end
  end


  /////////////////////////////////////////////////////////////////////////////
  //  axi_protocol_assertions
  // Description: AXI protocol property definitions and assertions.
  /////////////////////////////////////////////////////////////////////////////

  /*
  * RESERVED_BURST: Ensures AWBURST does not have a reserved value (2'b11)
  * when AWVALID is asserted and the reset is active.
  */
  property RESERVED_BURST;
    @(posedge ACLK) (AWVALID && ARESETn |-> (AWBURST != 2'b11));
  endproperty : RESERVED_BURST
  axi_burst_reserved_bit: assert property (RESERVED_BURST)
    else `uvm_error("RESERVED_BURST", "AWBURST has a reserved value (2'b11)!")
 
  /*
  * arvalid_arready_handshake: Checks ARVALID and ARREADY handshake protocol.
  * Ensures ARVALID remains asserted for one clock cycle if ARREADY is not active.
  */
  property arvalid_arready_handshake;
    @(posedge ACLK) disable iff (!ARESETn)
      ARVALID && !ARREADY |-> ##1 ARVALID;
  endproperty : arvalid_arready_handshake
  assert property (arvalid_arready_handshake)
    else `uvm_error("ARVALID_HANDSHAKE", "ARVALID handshake protocol violated!")

  /*
  * rvalid_rready_handshake: Checks RVALID and RREADY handshake protocol.
  * Ensures RVALID remains asserted for one clock cycle if RREADY is not active.
  */
  property rvalid_rready_handshake;
    @(posedge ACLK) disable iff (!ARESETn)
      RVALID && !RREADY |-> ##1 RVALID;
  endproperty : rvalid_rready_handshake
  assert property (rvalid_rready_handshake)
    else `uvm_error("RVALID_HANDSHAKE", "RVALID handshake protocol violated!")

  /*
  * awvalid_awready_handshake: Checks AWVALID and AWREADY handshake protocol.
  * Ensures AWVALID remains asserted for one clock cycle if AWREADY is not active.
  */
  property awvalid_awready_handshake;
    @(posedge ACLK) disable iff (!ARESETn)
      AWVALID && !AWREADY |-> ##1 AWVALID;
  endproperty : awvalid_awready_handshake
  assert property (awvalid_awready_handshake)
    else `uvm_error("AWVALID_HANDSHAKE", "AWVALID handshake protocol violated!")

  /*
  * wvalid_wready_handshake: Checks WVALID and WREADY handshake protocol.
  * Ensures WVALID remains asserted for one clock cycle if WREADY is not active.
  */
  property wvalid_wready_handshake;
    @(posedge ACLK) disable iff (!ARESETn)
      WVALID && !WREADY |-> ##1 WVALID;
  endproperty : wvalid_wready_handshake
  assert property (wvalid_wready_handshake)
    else `uvm_error("WVALID_HANDSHAKE", "WVALID handshake protocol violated!")

  /*
  * bvalid_bready_handshake: Checks BVALID and BREADY handshake protocol.
  * Ensures BVALID remains asserted for one clock cycle if BREADY is not active.
  */
  property bvalid_bready_handshake;
    @(posedge ACLK) disable iff (!ARESETn)
      BVALID && !BREADY |-> ##1 BVALID;
  endproperty : bvalid_bready_handshake
  assert property (bvalid_bready_handshake)
    else `uvm_error("BVALID_HANDSHAKE", "BVALID handshake protocol violated!")

  /////////////////////////////////////////////////////////////////////////////
  // Assertion: Check WREADY after AWVALID and AWREADY within 1 to 16 cycles
  // Description: Ensures that once AWVALID and AWREADY are asserted together,
  //              WREADY must be asserted within 1 to 16 cycles.
  /////////////////////////////////////////////////////////////////////////////
  property p_aw_wready_timeout;
    @(posedge ACLK) disable iff (!ARESETn)
    (AWVALID && AWREADY) |-> ##[1:16] WREADY;
  endproperty
  assert property (p_aw_wready_timeout)
  else begin
    `uvm_error("AXI_PROTOCOL", "TIMEOUT ERROR: WREADY not asserted within 1 to 16 cycles after AWVALID and AWREADY.")
  end

  /////////////////////////////////////////////////////////////////////////////
  // Assertion: Check RVALID after ARVALID and ARREADY within 1 to 16 cycles
  // Description: Ensures that once ARVALID and ARREADY are asserted together,
  //              RVALID must be asserted within 1 to 16 cycles.
  /////////////////////////////////////////////////////////////////////////////
  property p_ar_rvalid_timeout;
    @(posedge ACLK) disable iff (!ARESETn)
    (ARVALID && ARREADY) |-> ##[1:16] RVALID;
  endproperty
  assert property (p_ar_rvalid_timeout)
    else begin
      `uvm_error("AXI_PROTOCOL", "TIMEOUT ERROR: RVALID not asserted within 1 to 16 cycles after ARVALID and ARREADY.")
    end

endinterface

`endif // AXI_INTERFACE
