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

class axi2ahb_scoreboard extends uvm_component;

    // Registering the scoreboard component with UVM factory
    `uvm_component_utils(axi2ahb_scoreboard)

    // TLM analysis FIFOs for data transfer
    uvm_tlm_analysis_fifo #(axi_seq_item) axi_wr_addr_fifo;
    uvm_tlm_analysis_fifo #(axi_seq_item) axi_rd_addr_fifo;
    uvm_tlm_analysis_fifo #(axi_seq_item) axi_wr_data_fifo;
    uvm_tlm_analysis_fifo #(axi_seq_item) axi_rd_data_fifo;
    uvm_tlm_analysis_fifo #(ahb_seq_item) ahb_data_fifo;

    // Transaction items for comparison
    axi_seq_item axi_wr_addr_item, axi_wr_data_item, axi_rd_addr_item, axi_rd_data_item;
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
        axi_wr_addr_fifo = new("axi_wr_addr_fifo", this);
        axi_rd_addr_fifo = new("axi_rd_addr_fifo", this);
        axi_wr_data_fifo = new("axi_wr_data_fifo", this);
        axi_rd_data_fifo = new("axi_rd_data_fifo", this);
        ahb_data_fifo    = new("ahb_data_fifo", this);
    endfunction

    /*************************************************************************
     * Run Phase: Launch the comparison tasks.
     *************************************************************************/
    task main_phase(uvm_phase phase);
        `uvm_info(get_full_name(), "Main Phase Started in Scoreboard", UVM_LOW);
        fork
            compare_write_data_transfer();
            compare_read_data_transfer();
        join
    endtask

    /*************************************************************************
    * Compare Write Data Transfer: AXI to AHB Write Transaction Comparison
    *************************************************************************/
    task compare_write_data_transfer();
        axi_seq_item temp_axi_wr_addr_item, temp_axi_wr_data_item;
        ahb_seq_item temp_ahb_data_item;
        bit [7:0] temp_wr_data[$];

        $display("Scoreboard Write Compare task is started");

        forever begin
            // Retrieve write address and data from AXI FIFOs
            axi_wr_addr_fifo.get(temp_axi_wr_addr_item);
            axi_wr_data_fifo.get(temp_axi_wr_data_item);

            // temp_axi_wr_addr_item.print();
            // temp_axi_wr_data_item.print();

            // Handle Fixed Burst transactions
            if (temp_axi_wr_addr_item.burst == FIXED) begin
                for (int i = 0; i < (temp_axi_wr_data_item.data.size() / 4); i++) begin
                    ahb_data_fifo.get(temp_ahb_data_item);
                    // foreach (temp_ahb_data_item.data[m])
                    //     temp_wr_data.push_back(temp_ahb_data_item.data[m]);
                end

                temp_ahb_data_item.print();
                if (temp_axi_wr_data_item.data == temp_wr_data) begin
                    `uvm_info("BRIDGE_WRITE_TXN_PASS", 
                        $sformatf("AXI and AHB Write transactions match\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_wr_data), UVM_LOW);
                end else begin
                    `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
                        $sformatf("AXI and AHB Write transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_wr_data))
                end
                temp_wr_data = {};
            end 
            else begin
                // Non-Fixed Burst transactions
                ahb_data_fifo.get(temp_ahb_data_item);
                // temp_ahb_data_item.print();

                // if (temp_axi_wr_data_item.data == temp_ahb_data_item.data) begin
                //     `uvm_info("BRIDGE_WRITE_TXN_PASS", 
                //         $sformatf("AXI and AHB Write transactions match\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_ahb_data_item.data), UVM_LOW);
                // end else begin
                //     `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
                //         $sformatf("AXI and AHB Write transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_ahb_data_item.data))
                // end
            end
        end
    endtask

    /*************************************************************************
    * Compare Read Data Transfer: AXI to AHB Read Transaction Comparison
    *************************************************************************/
    task compare_read_data_transfer();
        axi_seq_item temp_axi_rd_addr_item, temp_axi_rd_data_item;
        ahb_seq_item temp_ahb_data_item;
        bit [7:0] temp_rd_data[$];
        int i = 0;

        $display("Scoreboard Read Compare task is started");

        forever begin
            // Retrieve read address and data from AXI FIFOs
            axi_rd_addr_fifo.get(temp_axi_rd_addr_item);
            axi_rd_data_fifo.get(temp_axi_rd_data_item);

            $display("AXI READ @ Scoreboard -- %0d", i);
            temp_axi_rd_addr_item.print();
            temp_axi_rd_data_item.print();

            // Handle Fixed Burst transactions
            if (temp_axi_rd_addr_item.burst == FIXED) begin
                for (int j = 0; j < (temp_axi_rd_data_item.data.size() / 4); j++) begin
                    ahb_data_fifo.get(temp_ahb_data_item);
                    // foreach (temp_ahb_data_item.data[m])
                    //     temp_rd_data.push_back(temp_ahb_data_item.data[m]);
                end

                $display("AHB READ @ Scoreboard -- %0d", i);
                temp_ahb_data_item.print();

                if (temp_axi_rd_data_item.data == temp_rd_data) begin
                    `uvm_info("BRIDGE_READ_TXN_PASS", 
                        $sformatf("AXI and AHB Read transactions match\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_rd_data), UVM_LOW);
                end else begin
                    `uvm_error("BRIDGE_READ_TXN_FAIL", 
                        $sformatf("AXI and AHB Read transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_rd_data))
                end
                temp_rd_data = {};
            end 
            
            else begin
                // Non-Fixed Burst transactions
                ahb_data_fifo.get(temp_ahb_data_item);
                $display("AHB READ @ Scoreboard -- %0d", i);
                temp_ahb_data_item.print();

                // if (temp_axi_rd_data_item.data == temp_ahb_data_item.data) begin
                //     `uvm_info("BRIDGE_READ_TXN_PASS", 
                //         $sformatf("AXI and AHB Read transactions match\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_ahb_data_item.data), UVM_LOW);
                // end else begin
                //     `uvm_error("BRIDGE_READ_TXN_FAIL", 
                //         $sformatf("AXI and AHB Read transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_ahb_data_item.data))
                // end
            end
            
            i++;
        end
    endtask


endclass

`endif
