/*************************************************************************
   > File Name:   axi_seq_item.sv
   > Description: The AXI Sequence Item is a UVM class defining randomized AXI4 transactions with constraints 
                  to ensure protocol compliance and diverse test coverage.
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AXI_SEQ_ITEM
`define AXI_SEQ_ITEM

// Enums for Readibility
typedef enum bit [1:0] {FIXED, INCR, WRAP} burst_type;
typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR, DECERR} response_type;
typedef enum bit {READ_TRAN, WRITE_TRAN} operation_type;

// AXI Sequence Item Class
class axi_seq_item extends uvm_sequence_item;

  // Randomized variables
  bit    [bus_params_pkg::BUS_AW-1:0]      addr;                     // Address        
  randc  bit [bus_params_pkg::BUS_IDW-1:0] id;                       // Transaction ID                   
  rand   int                               size;                     // Data size
  rand   burst_type                        burst;                    // Burst type      
  rand   bit [7:0]                         data[];                   // Data array
  response_type                            response;                 // Response type   
  rand  operation_type                     access;                   // Operation type     
  int                                      burst_length;             // Burst length      
  bit   [bus_params_pkg::BUS_AW-1:0]       aligned_addr;             // Aligned address
  bit   [bus_params_pkg::BUS_DS-1:0]       awsize_val;               // AWSIZE value
  bit   [bus_params_pkg::BUS_DBW-1:0]      write_strobe[1023:0];     // Write strobe array
  bit   [bus_params_pkg::BUS_DW-1:0]       write_data[$];            // Write data array
  rand bit                                 bready;                   // Write Response 
  rand bit                                 aw_valid;                 // Write Address Valid 
  rand bit                                 w_valid;                  // Write Data Valid         
  rand bit                                 ar_valid;                 // Read Address Valid 
  rand bit                                 rready;                   // Read Response 




  // Constraints
  constraint data_con { data.size inside {[1:1024]}; }
  constraint size_con { size inside {1, 2, 4}; }
  constraint wr_res_con { bready == 1; }
  constraint rd_res_con { rready == 1; }
  constraint wr_addr_valid_con { aw_valid == 1; }
  constraint wr_data_valid_con { w_valid == 1; }
  constraint rd_addr_valid_con { ar_valid == 1; }


  // UVM Macros for field registration
  `uvm_object_utils_begin(axi_seq_item)
    `uvm_field_int(addr, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(id, UVM_DEFAULT)
    `uvm_field_int(size, UVM_DEFAULT)
    `uvm_field_enum(burst_type, burst, UVM_DEFAULT)
    `uvm_field_enum(response_type, response, UVM_DEFAULT)
    `uvm_field_enum(operation_type, access, UVM_DEFAULT)
    `uvm_field_sarray_int(data, UVM_DEFAULT)
    `uvm_field_sarray_int(write_data, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor
  function new(string name="axi_seq_item");
    super.new(name);
  endfunction

// Function to calculate AWSIZE based on size
function bit [2:0] awsize();
  case (this.size)
    1   : return 3'b000; 
    2   : return 3'b001; 
    4   : return 3'b010; 
    8   : return 3'b011; 
    16  : return 3'b100; 
    32  : return 3'b101; 
    64  : return 3'b110; 
    128 : return 3'b111; 
    default: return 3'bxxx; // Invalid size
  endcase
endfunction


// Function to find Length of the Burst from AxSize and Data size
function void burst_strobe_data_gen();

      // Local variables
    int aligned_address;         // Address aligned to the size of the data
    int remaining_data_size;    
    int temp_length;             
    bit [1:0] address_alignment;
    int i = 0;
    int aligned_add;
    int data_index = 0;

    address_alignment = this.addr[1:0]; // Extract lower 2 bits of the address for alignment
    remaining_data_size = this.data.size - (this.size * (address_alignment % this.size));

    temp_length = ((remaining_data_size % this.size) == 0) ? 
                  (remaining_data_size / this.size) : 
                  ((remaining_data_size / this.size) + 1);

    this.burst_length = temp_length+1; // Final burst length includes the initial beat

    aligned_add = (this.addr / this.size) * this.size;
    // Handle WRITE transactions
    if (this.access == WRITE_TRAN) begin
    // First transfer
    for (int j = this.addr % `WIDTH; j < ((this.addr % `WIDTH) + this.size); j++) begin
        this.write_strobe[i][j] = 1;
    end

    // Handle subsequent bursts
    for (int k = 1; k < this.burst_length; k++) begin
        aligned_add += this.size; // Increment aligned address
        i += 1;

        if (k == (this.burst_length - 1)) begin
            // Handle the last transfer (remaining data size)
            int last_transfer_size = (remaining_data_size % this.size == 0) ? this.size : (remaining_data_size % this.size);
            for (int l = aligned_add % `WIDTH; l < (aligned_add % `WIDTH) + last_transfer_size; l++) begin
                this.write_strobe[i][l] = 1;
            end
        end else begin
            // Handle intermediate bursts
            for (int l = aligned_add % `WIDTH; l < (aligned_add % `WIDTH) + this.size; l++) begin
                this.write_strobe[i][l] = 1;
            end
        end
    end
      /*------------------------------------------------------------------------------
      Generate write data:
        This code generates the write_data for each burst beat by iterating 
        through all valid byte positions marked by write_strobe. It maps the corresponding bits 
        from the data array into the appropriate positions in write_data, incrementing the data_index 
        for each byte processed.
      ------------------------------------------------------------------------------*/

        for (int beat_index = 0; beat_index < this.burst_length; beat_index++) begin
            for (int byte_index = 0; byte_index < `WIDTH; byte_index++) begin
                if (this.write_strobe[beat_index][byte_index] == 1'b1) begin
                    for (int bit_index = 0; bit_index < 8; bit_index++) begin
                        this.write_data[beat_index][(byte_index * 8) + bit_index] = this.data[data_index][bit_index];
                    end
                    data_index++;
                end
            end
        end
      
    end
    endfunction

  // Post-randomization function to calculate AWSIZE, Burst Length, Strobe and WDATA
  function void post_randomize();
    this.awsize_val = awsize();    // Compute AWSIZE using the size value
    burst_strobe_data_gen();
  endfunction
  
endclass

`endif


