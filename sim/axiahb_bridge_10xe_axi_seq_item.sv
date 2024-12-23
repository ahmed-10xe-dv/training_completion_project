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

typedef enum bit [1:0] {FIXED, INCR, WRAP} burst_type;
typedef enum bit [1:0] {OKAY, EXOKAY, SLVERR, DECERR} response_type;
typedef enum bit {READ_TRAN, WRITE_TRAN} operation_type;

// AXI Sequence Item Class
class axi_seq_item extends uvm_sequence_item;

  // Randomized variables
  bit                            [31:0]                           addr;
  randc                          bit [3:0]                        id;
  rand                           int                              size;
  rand                           burst_type                       burst;
  rand                           bit [7:0]                        data[];
  response_type                                                   response;
  rand                           operation_type                   access;
  int                                                             burst_length;
  bit                            [31:0]                           aligned_addr;
  bit                            [2:0]                            awsize_val;
 
  // Constraints
  constraint data_con { data.size inside {[1:1024]}; }
  constraint size_con { size inside {1, 2, 4 ,8,16,32,64,128}; }




  // UVM Macros for field registration
  `uvm_object_utils_begin(axi_seq_item)
    `uvm_field_int(addr, UVM_DEFAULT | UVM_DEC)
    `uvm_field_int(id, UVM_DEFAULT)
    `uvm_field_int(size, UVM_DEFAULT)
    `uvm_field_enum(burst_type, burst, UVM_DEFAULT)
    `uvm_field_enum(response_type, response, UVM_DEFAULT)
    `uvm_field_enum(operation_type, access, UVM_DEFAULT)
    `uvm_field_sarray_int(data, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor
  function new(string name="axi_seq_item");
    super.new(name);
  endfunction

  // Task: Calculate Burst Length for AXI Transactions
function int calculate_burst_length();
    // Local variables
    int aligned_address;         // Address aligned to the size of the data
    int remaining_data_size;    
    int temp_length;             
    bit [1:0] address_alignment; 
  
    address_alignment = this.addr[1:0]; // Extract lower 2 bits of the address for alignment
    remaining_data_size = this.data.size - (this.size * (address_alignment % this.size));

    temp_length = ((remaining_data_size % this.size) == 0) ? 
                  (remaining_data_size / this.size) : 
                  ((remaining_data_size / this.size) + 1);

    this.burst_length = temp_length; // Final burst length excludes the initial beat
endfunction 


// Function to calculate aligned address based on burst type
function bit [31:0] calculate_aligned_addr();
  return (this.burst == FIXED) ? this.addr : (this.addr & ~(this.size - 1));
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





 // Post-randomization function to calculate AWSIZE
 function void post_randomize();
  calculate_burst_length();
  this.awsize_val = awsize(); // Compute AWSIZE using the size value
  this.aligned_addr = calculate_aligned_addr();
endfunction


endclass

`endif