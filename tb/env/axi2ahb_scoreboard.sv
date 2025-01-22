/*************************************************************************
   > File Name:   axi2ahb_scoreboard.sv
   > Description: Scoreboard implementation for AXI to AHB protocol bridge.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI2AHB_SCOREBOARD
`define AXI2AHB_SCOREBOARD


`uvm_analysis_imp_decl(_axi_wr_addr)
`uvm_analysis_imp_decl(_axi_rd_addr)
`uvm_analysis_imp_decl(_axi_wr_data)
`uvm_analysis_imp_decl(_axi_rd_data)
`uvm_analysis_imp_decl(_axi_wr_rsp)
`uvm_analysis_imp_decl(_ahb_data)

class axi2ahb_scoreboard extends uvm_component;

    // Registering the scoreboard component with UVM factory
    `uvm_component_utils(axi2ahb_scoreboard)

    // TLM analysis FIFOs for data transfer
    uvm_analysis_imp_axi_wr_addr #(axi_seq_item, axi2ahb_scoreboard) axi_wr_addr_imp;
    uvm_analysis_imp_axi_rd_addr #(axi_seq_item, axi2ahb_scoreboard) axi_rd_addr_imp;
    uvm_analysis_imp_axi_wr_data #(axi_seq_item, axi2ahb_scoreboard) axi_wr_data_imp;
    uvm_analysis_imp_axi_rd_data #(axi_seq_item, axi2ahb_scoreboard) axi_rd_data_imp;
    uvm_analysis_imp_axi_wr_rsp #(axi_seq_item, axi2ahb_scoreboard) axi_wr_rsp_imp;
    uvm_analysis_imp_ahb_data #(ahb_seq_item, axi2ahb_scoreboard) ahb_data_imp;

    axi_seq_item axi_wr_addr_q[$];
    axi_seq_item axi_wr_data_q[$];
    axi_seq_item axi_wr_rsp_q[$];
    axi_seq_item axi_rd_addr_q[$];
    axi_seq_item axi_rd_data_q[$];
    ahb_seq_item ahb_data_q[$];
    logic [31:0] axi_addr_queue[$];
    logic [31:0] temp_addr;  


    // Transaction items for comparison
    axi_seq_item axi_wr_addr_item;
    axi_seq_item axi_wr_data_item;
    axi_seq_item axi_rd_addr_item;
    axi_seq_item axi_rd_data_item;
    axi_seq_item axi_wr_rsp_item;
    ahb_seq_item ahb_data_item;

    /*************************************************************************
     * Constructor: Initialize the scoreboard component.
     *************************************************************************/
    function new(string name = "axi2ahb_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    /*************************************************************************
     * Build Phase: Create and initialize FIFOs.
     *************************************************************************/
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        axi_wr_addr_imp = new("axi_wr_addr_imp", this);
        axi_rd_addr_imp = new("axi_rd_addr_imp", this);
        axi_wr_data_imp = new("axi_wr_data_imp", this);
        axi_rd_data_imp = new("axi_rd_data_imp", this);
        axi_wr_rsp_imp  = new("axi_wr_rsp_imp", this);
        ahb_data_imp    = new("ahb_data_imp", this);

        axi_wr_addr_item        = axi_seq_item::type_id::create("axi_wr_addr_item");
        axi_wr_data_item        = axi_seq_item::type_id::create("axi_wr_data_item");
        axi_rd_addr_item        = axi_seq_item::type_id::create("axi_rd_addr_item");
        axi_rd_data_item        = axi_seq_item::type_id::create("axi_rd_data_item");
        axi_wr_rsp_item         = axi_seq_item::type_id::create("axi_wr_rsp_item");
        ahb_data_item           = ahb_seq_item::type_id::create("ahb_data_item");
    endfunction


    virtual function void write_axi_wr_addr(axi_seq_item axi_wr_addr_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_wr_addr Analysis Imp Port"),UVM_LOW)
        axi_wr_addr_q.push_back(axi_wr_addr_item);
    endfunction

    virtual function void write_axi_rd_addr(axi_seq_item axi_rd_addr_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_rd_addr Analysis Imp Port"),UVM_LOW)
        axi_rd_addr_q.push_back(axi_rd_addr_item);
    endfunction

    virtual function void write_axi_wr_data(axi_seq_item axi_wr_data_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_wr_data Analysis Imp Port"),UVM_LOW)
        axi_wr_data_q.push_back(axi_wr_data_item);
    endfunction

    virtual function void write_axi_rd_data(axi_seq_item axi_rd_data_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_rd_data Analysis Imp Port"),UVM_LOW)
        axi_rd_data_q.push_back(axi_rd_data_item);
        compare_read_txns();
    endfunction

    virtual function void write_axi_wr_rsp(axi_seq_item axi_wr_rsp_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_wr_rsp Analysis Imp Port"),UVM_LOW)
        axi_wr_rsp_q.push_back(axi_wr_rsp_item);
    endfunction

    virtual function void write_ahb_data(ahb_seq_item ahb_data_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_ahb_data Analysis Imp Port"),UVM_LOW)
        ahb_data_q.push_back(ahb_data_item);
        compare_write_txns();
    endfunction

    /*************************************************************************
    * Compare Write and Read Data Transfer: AXI to AHB Write and Read Transaction Comparison
    *************************************************************************/
    // function void compare_write_txns();

    //         if ((/*axi_wr_addr_q.size() && */ (axi_wr_data_q.size()) && (ahb_data_q.size()))) begin
    //             axi_wr_addr_item = axi_wr_addr_q.pop_front();
    //             axi_wr_data_item = axi_wr_data_q.pop_front();
    //             ahb_data_item    = ahb_data_q.pop_front();
            
    //             // Check for valid write transactions
    //             if (/* axi_wr_addr_item.access == WRITE_TRAN &&*/ axi_wr_data_item.access == WRITE_TRAN ) begin
    //                     // Retrieve data from the AHB FIFO
    //                     if (ahb_data_item.ACCESS_o == write /*&& (ahb_data_item.HADDR_o == axi_wr_addr_item.addr)*/ ) begin
    //                         //Compare AXI and AHB write data
    //                         if (ahb_data_item.HWDATA_o == axi_wr_data_item.write_data[0]) begin
    //                             `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
    //                             `uvm_info(get_name(), "---    WRITE TRANSACTION PASSED    ---", UVM_NONE)
    //                             `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
    //                             `uvm_info("BRIDGE_WRITE_TXN_PASS", $sformatf("AXI Write Data : %h, AHB Write Data : %h", axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o), UVM_LOW)
    //                         end else begin
    //                             `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
    //                             `uvm_info(get_name(), "---   WRITE TRANSACTION FAILED     ---", UVM_NONE)
    //                             `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
    //                             `uvm_error("BRIDGE_WRITE_TXN_FAIL", $sformatf("AXI Write Data : %h, AHB Write Data : %h", axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o))
    //                         end
                            
    //                     end
    //             end
    //         end  
    // endfunction

    function void compare_write_txns();
        if (((axi_wr_data_q.size()))) begin
                ahb_data_item    = ahb_data_q.pop_front();
                axi_wr_data_item = axi_wr_data_q.pop_front();
                if (((axi_wr_addr_q.size()))) begin
                    axi_wr_addr_item = axi_wr_addr_q.pop_front();
                    calculate_and_store_axi_addrs(axi_wr_addr_item, axi_addr_queue);
                end    
                if (ahb_data_item.HTRANS_o[1]) begin
                    
                // Check for valid write transactions
                if (axi_wr_data_item.access == WRITE_TRAN ) begin
                    // if (axi_wr_data_item.burst == FIXED) begin
                    //     temp_addr = axi_wr_data_item.addr;
                    // end
                    // else begin
                        temp_addr = axi_addr_queue.pop_front();
                    // end
                        if (ahb_data_item.ACCESS_o == write && (ahb_data_item.HADDR_o == temp_addr )) begin
                            //Compare AXI and AHB write data
                            if (ahb_data_item.HWDATA_o == axi_wr_data_item.write_data[0]) begin
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_info(get_name(), "---    WRITE TRANSACTION PASSED    ---", UVM_NONE)
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_info("BRIDGE_WRITE_TXN_PASS", $sformatf("AXI Write Data : %h, AHB Write Data : %h", axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o), UVM_LOW)
                                `uvm_info(get_name(), $sformatf("AXI Addr : %h, AHB Addr : %h",temp_addr, ahb_data_item.HADDR_o), UVM_LOW)
                            end else begin
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_info(get_name(), "---   WRITE TRANSACTION FAILED     ---", UVM_NONE)
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_error("BRIDGE_WRITE_TXN_FAIL", $sformatf("AXI Write Data : %h, AHB Write Data : %h", axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o))
                            end
                            
                        end
                        else begin
                            `uvm_info(get_name(), $sformatf("Addr Mismatch AXI Addr : %h, AHB Addr : %h",temp_addr, ahb_data_item.HADDR_o), UVM_LOW)
                        end
                end
                end

            // end  
        end
    endfunction


    function void compare_read_txns();

        $display("Scoreboard for Started read ");

        if ((axi_rd_data_q.size()) && (ahb_data_q.size())) begin
            // ahb_data_item    = (ahb_data_q.size() == 1) ? ahb_data_q.pop_front(): ahb_data_q.pop_back();  //  Sometimes ahb_gets the same data twice 
            // to make sure it always have one item in queue, we're doing that
                $display("In Read Compare Loop");
                axi_rd_addr_item = axi_rd_addr_q.pop_front();
                axi_rd_data_item = axi_rd_data_q.pop_front();
                ahb_data_item    = ahb_data_q.pop_front();

                // Check for valid write transactions
                if (/* axi_rd_addr_item.access == READ_TRAN &&*/ axi_rd_data_item.access == READ_TRAN ) begin
                        // Retrieve data from the AHB FIFO
                        if (ahb_data_item.ACCESS_o == read) begin
                            //Compare AXI and AHB Read data
                            if (ahb_data_item.HRDATA_i == axi_rd_data_item.write_data[0]) begin
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_info(get_name(), "---     READ TRANSACTION PASSED    ---", UVM_NONE)
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_info("BRIDGE_READ_TXN_PASS", $sformatf("AXI Read Data : %h, AHB Read Data : %h", axi_rd_data_item.write_data[0], ahb_data_item.HRDATA_i), UVM_LOW)
                            end else begin
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_info(get_name(), "---    READ TRANSACTION FAILED     ---", UVM_NONE)
                                `uvm_info(get_name(), "---------------------------------------", UVM_NONE)
                                `uvm_error("BRIDGE_READ_TXN_FAIL", $sformatf("AXI Read Data : %h, AHB Read Data : %h", axi_rd_data_item.write_data[0], ahb_data_item.HRDATA_i))
                            end
                        end
                end
            end
    endfunction


      // Function to calculate and store AXI addresses based on transaction item details
      function void calculate_and_store_axi_addrs(
        input axi_seq_item axi_item,          // AXI transaction item
        output logic [31:0] axi_addr_queue[$]  // Queue to store the addresses
    );
        // Temporary variables
        int unsigned wrap_boundary;
        int unsigned num_bytes;
        int unsigned addr;
        int unsigned burst_length;

        // Clear the queue
        axi_addr_queue.delete();

        // Initialize parameters from the transaction item
        addr = axi_item.addr;
        burst_length = axi_item.burst_length;

        // Calculate the number of bytes per transfer based on size
        // Size = 0 -> 1 byte, Size = 1 -> 2 bytes (half-word), Size = 2 -> 4 bytes (word)
        case (axi_item.size)
            0: num_bytes = 1;
            1: num_bytes = 2;
            2: num_bytes = 4;
            default: num_bytes = 1; // Default to byte transfer if size is invalid
        endcase

        // Align the address if the size is half-word (1) or word (2)
        if (axi_item.size == 1 || axi_item.size == 2) begin
            addr = addr & ~(num_bytes - 1);
        end

        // Handle burst types
        case (axi_item.burst)
            FIXED: begin
                // For FIXED burst, store the same address repeatedly
                repeat (burst_length) begin
                    if (axi_addr_queue.size() < 256) begin
                        axi_addr_queue.push_back(addr);
                    end else begin
                        `uvm_warning("ADDR_QUEUE_FULL", "Queue size exceeded 256 items")
                        break;
                    end
                end
            end

            INCR: begin
                // For INCR burst, increment the address by `num_bytes` for each beat
                repeat (burst_length) begin
                    if (axi_addr_queue.size() < 256) begin
                        axi_addr_queue.push_back(addr);
                        addr += num_bytes; // Increment by number of bytes
                    end else begin
                        `uvm_warning("ADDR_QUEUE_FULL", "Queue size exceeded 256 items")
                        break;
                    end
                end
            end

            WRAP: begin
                // Calculate wrap boundary
                wrap_boundary = (addr / (num_bytes * burst_length)) * (num_bytes * burst_length);

                // For WRAP burst, increment the address with wrapping behavior
                repeat (burst_length) begin
                    if (axi_addr_queue.size() < 256) begin
                        axi_addr_queue.push_back(addr);
                        addr += num_bytes; // Increment by number of bytes

                        // Check if wrapping is required
                        if (addr == (wrap_boundary + (num_bytes * burst_length))) begin
                            addr = wrap_boundary; // Wrap back to the boundary
                        end
                    end else begin
                        `uvm_warning("ADDR_QUEUE_FULL", "Queue size exceeded 256 items")
                        break;
                    end
                end
            end

            default: begin
                `uvm_error("INVALID_BURST_TYPE", "Invalid burst type specified in AXI item")
            end
        endcase
    endfunction

endclass

`endif
