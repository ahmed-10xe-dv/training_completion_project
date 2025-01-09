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
        axi_wr_addr_item.print();
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
    endfunction

    virtual function void write_axi_wr_rsp(axi_seq_item axi_wr_rsp_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_axi_wr_rsp Analysis Imp Port"),UVM_LOW)
        axi_wr_rsp_q.push_back(axi_wr_rsp_item);
    endfunction

    virtual function void write_ahb_data(ahb_seq_item ahb_data_item);
        `uvm_info(get_type_name(),$sformatf("Received trans On write_ahb_data Analysis Imp Port"),UVM_LOW)
        ahb_data_q.push_back(ahb_data_item);
        compare_txns();
    endfunction

    /*************************************************************************
     * Run Phase: Launch the comparison tasks.
     *************************************************************************/
    // task main_phase(uvm_phase phase);
    //     `uvm_info(get_full_name(), "Main Phase Started in Scoreboard", UVM_LOW);
    //     fork
    //         // #100;
    //         compare_txns();
    //     `uvm_info(get_type_name(),$sformatf("IN SCB Main"),UVM_LOW)
            
    //         // compare_read_data_transfer();
    //     join
    // endtask

    /*************************************************************************
    * Compare Write Data Transfer: AXI to AHB Write Transaction Comparison
    *************************************************************************/


    function void compare_txns();
        // axi_seq_item temp_axi_wr_addr_item;
        // axi_seq_item temp_axi_wr_data_item;
        // ahb_seq_item temp_ahb_data_item;

        // bit [7:0] temp_wr_data[$];

        $display("Scoreboard Started");

        // forever begin

            if ((/*axi_wr_addr_q.size() && */ (axi_wr_data_q.size()) && (ahb_data_q.size()))) begin
                $display("In Write Compare Loop");
                axi_wr_addr_item = axi_wr_addr_q.pop_front();
                axi_wr_data_item = axi_wr_data_q.pop_front();
                ahb_data_item    = ahb_data_q.pop_front();
            
                // Check for valid write transactions
                if (/* axi_wr_addr_item.access == WRITE_TRAN &&*/ axi_wr_data_item.access == WRITE_TRAN ) begin
                    // do begin
                        // Retrieve data from the AHB FIFO
                        if (ahb_data_item.ACCESS_o == write) begin
                            int beat = 0;
                            //Compare AXI and AHB write data
                            if (ahb_data_item.HWDATA_o == axi_wr_data_item.write_data[0]) begin
                                `uvm_info("BRIDGE_WRITE_TXN_PASS", 
                                          $sformatf("AXI and AHB Write transactions match\nAXI: %h\nAHB: %h", 
                                                    axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o), 
                                          UVM_LOW)
                            end else begin
                                `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
                                           $sformatf("AXI and AHB Write transactions mismatch\nAXI: %h\nAHB: %h", 
                                                     axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o))
                                    // break;
                            end
                            beat++;
                            
                        end
                    // end while (!axi_wr_data_item.LAST);
                end
            end
            else if ((axi_rd_data_q.size()) && (ahb_data_q.size())) begin
                $display("In Read Compare Loop");
                axi_rd_addr_item = axi_rd_addr_q.pop_front();
                axi_rd_data_item = axi_rd_data_q.pop_front();
                ahb_data_item    = ahb_data_q.pop_front();

                // Check for valid write transactions
                if (/* axi_rd_addr_item.access == READ_TRAN &&*/ axi_rd_data_item.access == READ_TRAN ) begin
                    // do begin
                        // Retrieve data from the AHB FIFO
                        if (ahb_data_item.ACCESS_o == read) begin
                            // int beat = 0;
                            //Compare AXI and AHB write data
                            if (ahb_data_item.HRDATA_i == axi_rd_data_item.write_data[0]) begin
                                `uvm_info("BRIDGE_READ_TXN_PASS", 
                                          $sformatf("AXI and AHB READ transactions match\nAXI: %h\nAHB: %h", 
                                                    axi_rd_data_item.write_data[0], ahb_data_item.HRDATA_i), 
                                          UVM_LOW)
                            end else begin
                                `uvm_error("BRIDGE_READ_TXN_FAIL", 
                                           $sformatf("AXI and AHB READ transactions mismatch\nAXI: %h\nAHB: %h", 
                                           axi_rd_data_item.write_data[0], ahb_data_item.HRDATA_i))
                            end
                            // beat++;
                            
                        end
                    // end while (!axi_wr_data_item.LAST);
                end
                
            end
    endfunction




    /*************************************************************************
    * Compare Write Data Transfer: AXI to AHB Write Transaction Comparison
    *************************************************************************/


    // function void compare_write_data_transfer();
    //     // axi_seq_item temp_axi_wr_addr_item;
    //     // axi_seq_item temp_axi_wr_data_item;
    //     // ahb_seq_item temp_ahb_data_item;

    //     // bit [7:0] temp_wr_data[$];

    //     $display("Scoreboard Write Compare task is started");

    //     // forever begin

    //         if ((/*axi_wr_addr_q.size() && */ (axi_wr_data_q.size()) && (ahb_data_q.size()))) begin
    //             $display("In While Loop");
    //             axi_wr_addr_item = axi_wr_addr_q.pop_front();
    //             axi_wr_data_item = axi_wr_data_q.pop_front();
    //             ahb_data_item    = ahb_data_q.pop_front();
            
    //             // Check for valid write transactions
    //             if (/* axi_wr_addr_item.access == WRITE_TRAN &&*/ axi_wr_data_item.access == WRITE_TRAN ) begin
    //                 // do begin
    //                     // Retrieve data from the AHB FIFO
    //                     if (ahb_data_item.ACCESS_o == write) begin
    //                         int beat = 0;
    //                         //Compare AXI and AHB write data
    //                         if (ahb_data_item.HWDATA_o == axi_wr_data_item.write_data[0]) begin
    //                             `uvm_info("BRIDGE_WRITE_TXN_PASS", 
    //                                       $sformatf("AXI and AHB Write transactions match\nAXI: %h\nAHB: %h", 
    //                                                 axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o), 
    //                                       UVM_LOW)
    //                         end else begin
    //                             `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
    //                                        $sformatf("AXI and AHB Write transactions mismatch\nAXI: %h\nAHB: %h", 
    //                                                  axi_wr_data_item.write_data[0], ahb_data_item.HWDATA_o))
    //                                 // break;
    //                         end
    //                         beat++;
                            
    //                     end
    //                 // end while (!axi_wr_data_item.LAST);
    //             end
    //         end
    // endfunction




    // function void compare_write_data_transfer();
    //     // axi_seq_item temp_axi_wr_addr_item;
    //     // axi_seq_item temp_axi_wr_data_item;
    //     // ahb_seq_item temp_ahb_data_item;

    //     // bit [7:0] temp_wr_data[$];

    //     $display("Scoreboard Write Compare task is started");

    //     // forever begin

    //         while (!(axi_wr_addr_q.size() && !(axi_wr_data_q.size()) && !(ahb_data_q.size()))) begin
    //             $display("In While Loop");

    //             // Pop items from AXI write address and data queues
    //             // axi_wr_addr_item        = axi_seq_item::type_id::create("axi_wr_addr_item");
    //             // axi_wr_data_item        = axi_seq_item::type_id::create("axi_wr_data_item");
    //             // axi_rd_addr_item        = axi_seq_item::type_id::create("axi_rd_addr_item");
    //             // axi_rd_data_item        = axi_seq_item::type_id::create("axi_rd_data_item");
    //             // axi_wr_rsp_item         = axi_seq_item::type_id::create("axi_wr_rsp_item");
    //             // ahb_data_item           = ahb_seq_item::type_id::create("ahb_data_item");

    //             axi_wr_addr_item = axi_wr_addr_q.pop_front();
    //             axi_wr_data_item = axi_wr_data_q.pop_front();
    //             ahb_data_item    = ahb_data_q.pop_front();

    //             // if (axi_wr_addr_item == null) begin
    //             //     `uvm_error("SCOREBOARD_ERROR", "axi_wr_addr_item was not created.")
    //             // end
                

    //             // if (axi_wr_addr_item == null || axi_wr_data_item == null || ahb_data_item == null) begin
    //             //     `uvm_error("TRANSACTION_ERROR", "Invalid transaction detected.");
    //             // end
                
            
    //             // Check for valid write transactions
    //             if (axi_wr_addr_item.access == WRITE_TRAN && axi_wr_data_item.access == WRITE_TRAN && 
    //                 !(axi_wr_addr_item.size == 0)) begin
    //                 do begin
    //                     // Retrieve data from the AHB FIFO
    //                     if (ahb_data_item.ACCESS_o == write) begin
    //                         int beat = 0;
    //                         // Compare AXI and AHB write data
    //                         if (ahb_data_item.HWDATA_o == axi_wr_data_item.write_data[beat]) begin
    //                             `uvm_info("BRIDGE_WRITE_TXN_PASS", 
    //                                       $sformatf("AXI and AHB Write transactions match\nAXI: %h\nAHB: %h", 
    //                                                 axi_wr_data_item.write_data[beat], ahb_data_item.HWDATA_o), 
    //                                       UVM_LOW);
    //                         end else begin
    //                             `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
    //                                        $sformatf("AXI and AHB Write transactions mismatch\nAXI: %h\nAHB: %h", 
    //                                                  axi_wr_data_item.write_data[beat], ahb_data_item.HWDATA_o));
    //                         end
                
    //                         // Increment beat
    //                         beat++;
                            
    //                     end
    //                 end while (!axi_wr_data_item.LAST);
    //             end
    //         end
            

    //         // if (temp_axi_wr_addr_item.access == WRITE_TRAN & temp_ahb_data_item.ACCESS_o == write) begin
    //         //          $display("Scoreboard Debug");
                
    //         //     if (temp_ahb_data_item.HWDATA_o == temp_axi_wr_data_item.write_data[0]) begin
    //         //         `uvm_info("BRIDGE_WRITE_TXN_PASS", 
    //         //                 $sformatf("AXI and AHB Write transactions match\nAXI: %h\nAHB: %h", temp_axi_wr_data_item.write_data[0], temp_ahb_data_item.HWDATA_o), UVM_LOW);
    //         //         end 
    //         //         else begin
    //         //             `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
    //         //                 $sformatf("AXI and AHB Write transactions mismatch\nAXI: %h\nAHB: %h", temp_axi_wr_data_item.write_data[0], temp_ahb_data_item.HWDATA_o))
    //         //     end   
                
    //         // end
    //         // else begin
    //         //     $display("Could Not Find Write");
                
    //         // end
    //     // end

    //         // for (int i = 0; i < (temp_axi_wr_data_item.data.size() / 4); i++) begin
    //         //         ahb_data_fifo.get(temp_ahb_data_item);
    //         //         // foreach (temp_ahb_data_item.data[m])
    //         //         //     temp_wr_data.push_back(temp_ahb_data_item.data[m]);
    //         // end




    //         // // Handle Fixed Burst transactions
    //         // if (temp_axi_wr_addr_item.burst == FIXED) begin
    //         //     for (int i = 0; i < (temp_axi_wr_data_item.data.size() / 4); i++) begin
    //         //         ahb_data_fifo.get(temp_ahb_data_item);
    //         //         // foreach (temp_ahb_data_item.data[m])
    //         //         //     temp_wr_data.push_back(temp_ahb_data_item.data[m]);
    //         //     end

    //         //     // temp_ahb_data_item.print();
    //         //     if (temp_axi_wr_data_item.data == temp_wr_data) begin
    //         //         `uvm_info("BRIDGE_WRITE_TXN_PASS", 
    //         //             $sformatf("AXI and AHB Write transactions match\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_wr_data), UVM_LOW);
    //         //     end else begin
    //         //         `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
    //         //             $sformatf("AXI and AHB Write transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_wr_data))
    //         //     end
    //         //     temp_wr_data = {};
    //         // end 
    //         // else begin
    //         //     // Non-Fixed Burst transactions
    //         //     ahb_data_fifo.get(temp_ahb_data_item);
    //         //     // temp_ahb_data_item.print();

    //         //     // if (temp_axi_wr_data_item.data == temp_ahb_data_item.data) begin
    //         //     //     `uvm_info("BRIDGE_WRITE_TXN_PASS", 
    //         //     //         $sformatf("AXI and AHB Write transactions match\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_ahb_data_item.data), UVM_LOW);
    //         //     // end else begin
    //         //     //     `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
    //         //     //         $sformatf("AXI and AHB Write transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_wr_data_item.data, temp_ahb_data_item.data))
    //         //     // end
    //         // end
    //     // end
    // endfunction




    // task compare_read_data_transfer();
    //     axi_seq_item temp_axi_rd_addr_item, temp_axi_rd_data_item;
    //     ahb_seq_item temp_ahb_data_item;
    //     bit [7:0] temp_wr_data[$];

    //     $display("Scoreboard Write Compare task is started");

    //     forever begin
    //         // Retrieve write address and data from AXI FIFOs
    //         axi_rd_addr_fifo.get(temp_axi_rd_addr_item);
    //         axi_rd_data_fifo.get(temp_axi_rd_data_item);
            
    //         ahb_data_fifo.get(temp_ahb_data_item);


    //         temp_axi_wr_addr_item.print();
    //         temp_axi_wr_data_item.print();
    //         temp_ahb_data_item.print();


    //         if (temp_axi_rd_addr_item.access == READ_TRAN & temp_ahb_data_item.ACCESS_o == read) begin
    //                  $display("Scoreboard Debug");

    //             if (temp_ahb_data_item.HRDATA_i == temp_axi_wr_data_item.write_data[0]) begin
    //                 `uvm_info("BRIDGE_READ_TXN_PASS", 
    //                         $sformatf("AXI and AHB Write transactions match\nAXI: %h\nAHB: %h", temp_axi_wr_data_item.write_data[0], temp_ahb_data_item.HWDATA_o), UVM_LOW);
    //                 end 
        //             else begin
        //                 `uvm_error("BRIDGE_WRITE_TXN_FAIL", 
        //                     $sformatf("AXI and AHB Write transactions mismatch\nAXI: %h\nAHB: %h", temp_axi_wr_data_item.write_data[0], temp_ahb_data_item.HWDATA_o))
        //         end   
                
        //     end
        //     else begin
        //         $display("Could Not Find Write");
                
        //     end
        // end

    /*************************************************************************
    * Compare Read Data Transfer: AXI to AHB Read Transaction Comparison
    *************************************************************************/
    // task compare_read_data_transfer();
    //     axi_seq_item temp_axi_rd_addr_item, temp_axi_rd_data_item;
    //     ahb_seq_item temp_ahb_data_item;
    //     bit [7:0] temp_rd_data[$];
    //     int i = 0;

    //     $display("Scoreboard Read Compare task is started");

    //     forever begin
    //         // Retrieve read address and data from AXI FIFOs
    //         axi_rd_addr_fifo.get(temp_axi_rd_addr_item);
    //         axi_rd_data_fifo.get(temp_axi_rd_data_item);

    //         $display("AXI READ @ Scoreboard -- %0d", i);
    //         temp_axi_rd_addr_item.print();
    //         temp_axi_rd_data_item.print();

    //         // Handle Fixed Burst transactions
    //         if (temp_axi_rd_addr_item.burst == FIXED) begin
    //             for (int j = 0; j < (temp_axi_rd_data_item.data.size() / 4); j++) begin
    //                 ahb_data_fifo.get(temp_ahb_data_item);
    //                 // foreach (temp_ahb_data_item.data[m])
    //                 //     temp_rd_data.push_back(temp_ahb_data_item.data[m]);
    //             end

    //             $display("AHB READ @ Scoreboard -- %0d", i);
    //             temp_ahb_data_item.print();

    //             if (temp_axi_rd_data_item.data == temp_rd_data) begin
    //                 `uvm_info("BRIDGE_READ_TXN_PASS", 
    //                     $sformatf("AXI and AHB Read transactions match\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_rd_data), UVM_LOW);
    //             end else begin
    //                 `uvm_error("BRIDGE_READ_TXN_FAIL", 
    //                     $sformatf("AXI and AHB Read transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_rd_data))
    //             end
    //             temp_rd_data = {};
    //         end 
            
    //         else begin
    //             // Non-Fixed Burst transactions
    //             ahb_data_fifo.get(temp_ahb_data_item);
    //             $display("AHB READ @ Scoreboard -- %0d", i);
    //             // temp_ahb_data_item.print();

    //             // if (temp_axi_rd_data_item.data == temp_ahb_data_item.data) begin
    //             //     `uvm_info("BRIDGE_READ_TXN_PASS", 
    //             //         $sformatf("AXI and AHB Read transactions match\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_ahb_data_item.data), UVM_LOW);
    //             // end else begin
    //             //     `uvm_error("BRIDGE_READ_TXN_FAIL", 
    //             //         $sformatf("AXI and AHB Read transactions mismatch\nAXI: %p\nAHB: %p", temp_axi_rd_data_item.data, temp_ahb_data_item.data))
    //             // end
    //         end
            
    //         i++;
    //     end
    // endtask


endclass

`endif
