// /*************************************************************************
//    > File Name:   defines.sv
//    > Description: < Short description of what this file contains >
//    > Author:      Ahmed Raza
//    > Modified:    Ahmed Raza
//    > Mail:        ahmed.raza@10xengineers.ai
//    ---------------------------------------------------------------
//    Copyright   (c)2024 10xEngineers
//    ---------------------------------------------------------------
// ************************************************************************/


`ifndef AXI_DEFINES
`define AXI_DEFINES


`define ADDR_WIDTH = 32 
`define DATA_WIDTH = 32 
`define ID_W_WIDTH = 16 
`define BRESP_WIDTH = 2 
`define WIDTH 4

`endif




/*************************************************************************
   > File Name:   ahb_seq_item.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


// `ifndef AXI_DRIVER
// `define AXI_DRIVER

// class axi_driver extends uvm_driver #(axi_seq_item);

//   `uvm_component_utils(axi_driver)

//   virtual axi_interface axi_vif;
//   axi_seq_item write_addr_queue[$];
//   axi_seq_item write_data_queue[$];

  
//   axi_seq_item addr_item;
//   axi_seq_item temp_data_item;                // Temporary AXI sequence item


//   function new(string name = "axi_driver", uvm_component parent = null);
//     super.new(name, parent);
//   endfunction

//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_full_name(), "BUILD @driver", UVM_LOW)
//   endfunction

//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
//       `uvm_error(get_full_name(), "Interface Connection Failed")
//     else
//       `uvm_info(get_full_name(), "Interface Connection Success", UVM_LOW)
//   endfunction
 

//   task drive_write_addr();
//     forever begin
//       wait(axi_vif.ARESETn);
// `uvm_info(get_full_name(), "Driving Write Addr", UVM_LOW)

//       @(posedge axi_vif.ACLK);
//       if (write_addr_queue.size > 0) begin
//         addr_item = write_addr_queue.pop_back();

//         axi_vif.AWVALID <= 1'b1;
//         axi_vif.AWBURST <= addr_item.burst;
//         axi_vif.AWADDR  <= addr_item.addr;
//         axi_vif.AWID    <= addr_item.id;
//         axi_vif.AWSIZE  <= addr_item.awsize_val;
//         axi_vif.AWLEN   <= addr_item.burst_length - 1;

//         wait(axi_vif.AWREADY);
//         @(posedge axi_vif.ACLK);
//         axi_vif.AWVALID <= 1'b0;

//       end
//     end
//   endtask

//   /******************************************************************************
//    > Task Name: drive_write_data_channel
//    > Description: Handles the AXI write data channel transactions by driving 
//                   data, strobes, and control signals in compliance with the AXI protocol.
// ******************************************************************************/

// task drive_write_data_channel();
  
//   forever begin
//       // Wait for reset to be deasserted
//       wait(axi_vif.ARESETn);
      
//       // Check if there are items in the write data queue
//       if (write_data_queue.size() > 0) begin
//           temp_data_item = write_data_queue.pop_back();
          
          
//           // Drive the write data channel
//           for (int i = 0; i < temp_data_item.burst_length; i++) begin
//               @(posedge axi_vif.ACLK); // Synchronize with clock
              
//               // Drive AXI signals
//               axi_vif.WVALID <= 1'b1;
//               axi_vif.WID <= temp_data_item.id;
//               axi_vif.WDATA <= 32'hDEADBEEF;
//               axi_vif.WSTRB <= 4'b1111;
              
//               if (i == temp_data_item.burst_length - 1) begin
//                   axi_vif.WLAST <= 1'b1; // Assert WLAST for the last transfer
//                   @(posedge axi_vif.ACLK);
//                   axi_vif.WLAST <= 1'b0;
//                   wait(axi_vif.WREADY); // Wait for ready signal
//               end
//                else begin
//                   axi_vif.WLAST <= 1'b0; 
//                   @(posedge axi_vif.ACLK);
//                   wait(axi_vif.WREADY); 
//               end
//           end
          
//           // Deassert WVALID after the transaction is complete
//           @(posedge axi_vif.ACLK);
//           axi_vif.WVALID <= 1'b0;
//       end 
//       else begin
//           // If no data in the queue, synchronize with the clock
//           @(posedge axi_vif.ACLK);
//       end
//   end
// endtask


//   task fetch_data();
//     forever begin
//   `uvm_info(get_full_name(), "Fetching Data", UVM_LOW)

//       seq_item_port.get_next_item(req);
//       req.print();
//       if (req.access == WRITE_TRAN) begin 
//           write_data_queue.push_front(req);
//           write_addr_queue.push_front(req);
//       end
//       seq_item_port.item_done();
// `uvm_info(get_full_name(), "Fetching Data Completed", UVM_LOW)

//     end
//   endtask

//   task check_reset();
//     forever begin
//       @(posedge axi_vif.ACLK);
//       if (!axi_vif.ARESETn) axi_vif.AWVALID <= 1'b0;
//     end
//     wait(axi_vif.ARESETn);
//     // break;
//   endtask


//   task run_phase(uvm_phase phase);
//     `uvm_info(get_full_name(), "Run Phase Started", UVM_LOW)
//     fork
//       fetch_data();
//       check_reset();
//       drive_write_addr();
//       // drive_write_data_channel();
//     join
//     $display("AXI Run Phase ended");
//   endtask

// endclass

// `endif



// `ifndef AXI_DRIVER
// `define AXI_DRIVER

// class axi_driver extends uvm_driver #(axi_seq_item);

//   `uvm_component_utils(axi_driver)

//   virtual axi_interface axi_vif;

//   axi_seq_item axi_seq_h;


//   function new(string name = "axi_driver", uvm_component parent = null);
//     super.new(name, parent);
//   endfunction

//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_full_name(), "BUILD @driver", UVM_LOW)
//   endfunction

//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
//       `uvm_error(get_full_name(), "Interface Connection Failed")
//     else
//       `uvm_info(get_full_name(), "Interface Connection Success", UVM_LOW)
//   endfunction
 

//   task run_phase(uvm_phase phase);
//     `uvm_info(get_full_name(), "Run Phase Started", UVM_LOW)
    
//     axi_seq_h =  new();
//       //TODO
//       // get next item here
//       // write address sequence firs

//       // write all control address signals
//       display
//       // wait forawready
//       display
//       // write data sequence
//       // same for data
//       // finish items

//   endtask

// endclass

// `endif


/*************************************************************************
   > File Name:   ahb_seq_item.sv
   > Description: < Short description of what this file contains >
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


// `ifndef AXI_DRIVER
// `define AXI_DRIVER

// class axi_driver extends uvm_driver #(axi_seq_item);

//   `uvm_component_utils(axi_driver)

//   virtual axi_interface axi_vif;
//   axi_seq_item addr_queue[$];
//   axi_seq_item addr_item;

//   function new(string name = "axi_driver", uvm_component parent = null);
//     super.new(name, parent);
//   endfunction

//   function void build_phase(uvm_phase phase);
//     super.build_phase(phase);
//     `uvm_info(get_full_name(), "BUILD @driver", UVM_LOW)
//   endfunction

//   function void connect_phase(uvm_phase phase);
//     super.connect_phase(phase);
//     if (!uvm_config_db#(virtual axi_interface)::get(null, "*", "axi_vif", axi_vif))
//       `uvm_error(get_full_name(), "Interface Connection Failed")
//     else
//       `uvm_info(get_full_name(), "Interface Connection Success", UVM_LOW)
//   endfunction
 

//   task drive_write_addr();
//     forever begin
//       wait(axi_vif.ARESETn);
//       @(posedge axi_vif.ACLK);
//       if (addr_queue.size > 0) begin
//         addr_item = addr_queue.pop_back();

//         axi_vif.AWVALID <= 1'b1;
//         axi_vif.AWBURST <= addr_item.burst;
//         axi_vif.AWADDR  <= addr_item.addr;
//         axi_vif.AWID    <= addr_item.id;
//         axi_vif.AWSIZE  <= addr_item.awsize_val;
//         axi_vif.AWLEN   <= addr_item.burst_length;

//         wait(axi_vif.AWREADY);
//         @(posedge axi_vif.ACLK);
//         axi_vif.AWVALID <= 1'b0;

//       end
//     end
//   endtask

//   task fetch_data();
//     forever begin
//       seq_item_port.get_next_item(req);
//       req.print();
//       if (req.access == WRITE_TRAN) addr_queue.push_front(req);
//       seq_item_port.item_done();
//     `uvm_info(get_full_name(), "Item Recevied and Done", UVM_LOW)
//     end
//   endtask

//   task check_reset();
//     forever begin
//       @(posedge axi_vif.ACLK);
//       if (!axi_vif.ARESETn) axi_vif.AWVALID <= 1'b0;
//     end
//     wait(axi_vif.ARESETn);
//   endtask


//   task run_phase(uvm_phase phase);
//     `uvm_info(get_full_name(), "Run Phase Started", UVM_LOW)
//     fork
//       fetch_data();
//       check_reset();
//       drive_write_addr();
//     join
//   endtask

// endclass

// `endif




























// /*************************************************************************
//    > File Name:   axi_seq_item.sv
//    > Description: The AXI Sequence Item is a UVM class defining randomized AXI4 transactions with constraints 
//                   to ensure protocol compliance and diverse test coverage.
//    > Author:      Ahmed Raza
//    > Modified:    Ahmed Raza
//    > Mail:        ahmed.raza@10xengineers.ai
//    ---------------------------------------------------------------
//    Copyright   (c)2024 10xEngineers
//    ---------------------------------------------------------------
// ************************************************************************/

// `ifndef AXI_SEQ_ITEM
// `define AXI_SEQ_ITEM

// `define WIDTH 4

// typedef enum bit [1:0] {FIXED, INCR, WRAP} burst_type;
// typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR, DECERR} response_type;
// typedef enum bit {READ_TRAN, WRITE_TRAN} operation_type;

// // AXI Sequence Item Class
// class axi_seq_item extends uvm_sequence_item;

//   // Randomized variables
//   bit                            [31:0]                           addr;                     // Address        
//   randc                          bit [3:0]                        id;                       // Transaction ID  
//   rand                           int                              size;                     // Data size
//   rand                           burst_type                       burst;                    // Burst type      
//   rand                           bit [7:0]                        data[];                   // Data array
//   response_type                                                   response;                 // Response type   
//   rand                           operation_type                   access;                   // Operation type   
//   int                                                             burst_length;             // Burst length      
//   bit                            [31:0]                           aligned_addr;             // Aligned address
//   bit                            [2:0]                            awsize_val;               // AWSIZE value
//   bit                            [`WIDTH-1:0]                     write_strobe[$];          // Write strobe array
//   bit                            [`WIDTH*8-1:0]                   write_data[$];            // Write data array

//   // Constraints
//   constraint data_con { data.size inside {[1:1024]}; }
//   constraint size_con { size inside {1, 2, 4 ,8,16,32,64,128}; }

//   // UVM Macros for field registration
//   `uvm_object_utils_begin(axi_seq_item)
//     `uvm_field_int(addr, UVM_DEFAULT | UVM_DEC)
//     `uvm_field_int(id, UVM_DEFAULT)
//     `uvm_field_int(size, UVM_DEFAULT)
//     `uvm_field_enum(burst_type, burst, UVM_DEFAULT)
//     `uvm_field_enum(response_type, response, UVM_DEFAULT)
//     `uvm_field_enum(operation_type, access, UVM_DEFAULT)
//     `uvm_field_sarray_int(data, UVM_DEFAULT)
//   `uvm_object_utils_end

//   // Constructor
//   function new(string name="axi_seq_item");
//     super.new(name);
//   endfunction

// // Function to calculate aligned address based on burst type
// function bit [31:0] calculate_aligned_addr();
//   return (this.burst == FIXED) ? this.addr : (this.addr & ~(this.size - 1));
// endfunction

// // Function to calculate AWSIZE based on size
// function bit [2:0] awsize();
//   case (this.size)
//     1   : return 3'b000; 
//     2   : return 3'b001; 
//     4   : return 3'b010; 
//     8   : return 3'b011; 
//     16  : return 3'b100; 
//     32  : return 3'b101; 
//     64  : return 3'b110; 
//     128 : return 3'b111; 
//     default: return 3'bxxx; // Invalid size
//   endcase
// endfunction


// // Function to find Length of the Burst from AxSize and Data size
// function void burst_strobe_data_gen();

//       // Local variables
//     int aligned_address;         // Address aligned to the size of the data
//     int remaining_data_size;    
//     int temp_length;             
//     bit [1:0] address_alignment;
//     int i = 0;
//     int aligned_add;
//     int data_index = 0;

  
//     address_alignment = this.addr[1:0]; // Extract lower 2 bits of the address for alignment
//     remaining_data_size = this.data.size - (this.size * (address_alignment % this.size));

//     temp_length = ((remaining_data_size % this.size) == 0) ? 
//                   (remaining_data_size / this.size) : 
//                   ((remaining_data_size / this.size) + 1);

//     this.burst_length = temp_length+1; // Final burst length includes the initial beat

//     // aligned_add = (this.addr / this.size) * this.size;
//     aligned_add =this.addr & ~(this.size - 1);
//     // this.aligned_addr = aligned_add;
//     $display("Aligned Address = %0b", aligned_add);

//     for (int j = this.addr % `WIDTH; j < (aligned_add + `WIDTH); j++) begin
//         this.write_strobe[i][j] = 1;
//     end
  
//     for (int k = 1; k < this.burst_length; k++) begin
//         aligned_add = aligned_add + this.size;
//         i = i + 1;
//         if (k == (this.burst_length - 1)) begin
//             for (int l = aligned_add % `WIDTH; l < ((aligned_add % `WIDTH) + ((remaining_data_size % this.size == 0) ? this.size : (remaining_data_size % this.size))); l++) begin
//                 this.write_strobe[i][l] = 1;
//             end
//         end 
//         else begin
//             for (int l = aligned_add % `WIDTH; l < (aligned_add % `WIDTH) + this.size; l++) begin
//                 this.write_strobe[i][l] = 1;
//             end
//         end
//     end


//   /*------------------------------------------------------------------------------
//   Generate write data:
//     This code generates the write_data for each burst beat by iterating 
//     through all valid byte positions marked by write_strobe. It maps the corresponding bits 
//     from the data array into the appropriate positions in write_data, incrementing the data_index 
//     for each byte processed.
//    ------------------------------------------------------------------------------*/

//     for (int beat_index = 0; beat_index < this.burst_length; beat_index++) begin
//         for (int byte_index = 0; byte_index < `WIDTH; byte_index++) begin
//             if (this.write_strobe[beat_index][byte_index] == 1'b1) begin
//                 for (int bit_index = 0; bit_index < 8; bit_index++) begin
//                     this.write_data[beat_index][(byte_index * 8) + bit_index] = this.data[data_index][bit_index];
//                 end
//                 data_index++;
//             end
//         end
//     end
//   endfunction

//   // Post-randomization function to calculate AWSIZE, Burst Length, Strobe and WDATA
//   function void post_randomize();
//     this.awsize_val = awsize();                         // Compute AWSIZE using the size value
//     // this.aligned_addr = calculate_aligned_addr();
//     burst_strobe_data_gen();
//   endfunction

// endclass

// `endif






    // // Task to handle AHB Lite write transactions in driver
    // task write_data();
    //   int temp_addr;
    //   `uvm_info(get_full_name(), "Entering AHB Driver Write Data Task", UVM_LOW)

    //   // Initialize the array
    //   foreach (array[m])
    //     array[m] = 32'hffffffff;

    //   // Wait for reset to deassert and synchronize with the clock
    //   wait(ahb_vif.HRESETn);
    //   @(posedge ahb_vif.HCLK);
    //   ahb_vif.HREADY <= 1'b1;

    //   wait(ahb_vif.HTRANS);
    //   if (ahb_vif.HTRANS!= 2'b00) begin // Check if transfer is not IDLE
    //     `uvm_info(get_full_name(), "AHB Driver Write - Valid Transfer Detected", UVM_LOW)
    //     temp_addr = ahb_vif.HADDR;

    //     while (1) begin
    //       ahb_vif.HREADY <= 1'b1;

    //       // Handle BUSY state
    //       if (ahb_vif.HTRANS == 2'b01) begin
    //         @(posedge ahb_vif.HCLK);
    //         continue;
    //       end

    //       // Handle valid transfers
    //       if (ahb_vif.HTRANS!= 2'b00) begin
    //         wait(ahb_vif.HWDATA);
    //               `uvm_info(get_full_name(), 
    //   $sformatf("AHB Driver Write  HWDATA: %0h", ahb_vif.HWDATA), 
    //   UVM_LOW)

    //         for (int i = 0; i < 2**ahb_vif.HSIZE; i++)
    //           for (int j = 0; j < 8; ++j) 
    //             array[temp_addr][j] = ahb_vif.HWDATA[(i*8)+j];
              
    //         `uvm_info(get_full_name(), "AHB Driver Write - Write Completed", UVM_LOW)
              
    //         // Set response and ready signals
    //         if (seq.resp == ERROR)
    //           ahb_vif.HRESP <= 1'b1;
    //         else begin
    //           ahb_vif.HREADY <= 1'b0;
    //           @(posedge ahb_vif.HCLK);
    //           ahb_vif.HREADY <= 1'b1;
    //           ahb_vif.HRESP <= 1'b0;
    //          `uvm_info(get_full_name(), "AHB Driver Write - Response is OKAY", UVM_LOW)
    //         end
    //       end 
    //       else
    //       `uvm_info(get_full_name(), "AHB Driver Write - In ELSE", UVM_LOW)
    //         break;
    //     end
    //   end
    // endtask: write_data





  // // Task to write data
  // task write_data();
  //  `uvm_info(get_full_name(), "Entering AHB Driver Write Data Task", UVM_LOW)
  //  foreach (array[m]) begin
  //    array[m] = 32'hffffffff;
  //  end

  //  @(posedge ahb_vif.HCLK); //Okay?
  //  ahb_vif.HREADY <= 1'b1;

  //  while (!ahb_vif.HTRANS[1]) begin
  //      if (ahb_vif.HTRANS == 2'b01) begin // Busy state
  //       @(posedge ahb_vif.HCLK);
  //       continue;
  //      `uvm_info(get_full_name(), "AHB Driver Write - Slave Busy", UVM_LOW)
  //      end
  //  end

  //  // wait(ahb_vif.HTRANS[1]);                  //Only When the transfer is seq or no seq, not for idle or busy
 
  //  // if (ahb_vif.HTRANS != 2'b00) begin
  //  `uvm_info(get_full_name(), "AHB Driver Write - Valid Transfer Detected", UVM_LOW)

  //  //   // while (1) begin
  //  //   if (ahb_vif.HTRANS == 2'b01) begin // Busy state
  //  //     @(posedge ahb_vif.HCLK);
  //  //     // continue;
  //  //   `uvm_info(get_full_name(), "AHB Driver Write - Slave Busy", UVM_LOW)
  //  //   end

  //    // if (ahb_vif.HTRANS != 2'b00) begin
  //      for (int i = 0; i < 2**ahb_vif.HSIZE; ++i)
  //        for (int j = 0; j < 8; ++j)
  //          array[ahb_vif.HADDR][j] = ahb_vif.HWDATA[(i*8)+j];
  //      `uvm_info(get_full_name(), "AHB Driver Write - Write Completed", UVM_LOW)
  //      ahb_vif.HRESP <= 1'b0;   //Response is okay
  //    // end 
  //    ahb_vif.HREADY <= 1'b0;
  //    @(posedge ahb_vif.HCLK);
  //    ahb_vif.HREADY <= 1'b1;
  //  //  end
  //  endtask: write_data
