/*************************************************************************
   > File Name:   ahb_seq_item.sv
   > Description: Defines the AHB sequence item class with randomized fields 
                  and UVM field macros for AXI-to-AHB bridge verification
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

`ifndef AHB_SEQ_ITEM
`define AHB_SEQ_ITEM

// Enumerations for access type and response type
typedef enum {read, write} access_type;
typedef enum bit [1:0] {okay, ERROR} resp_type;

class ahb_seq_item extends uvm_sequence_item;
  // Randomized variables
  rand bit         [7:0]           data[];
  bit              [31:0]          addr;
  resp_type                   resp;
  access_type                 access;

  //TODO : Use 80 20 const for resp

  // Field registration macros
  `uvm_object_utils_begin(ahb_seq_item)
    `uvm_field_int(addr, UVM_DEFAULT | UVM_DEC)
    `uvm_field_enum(access_type, access, UVM_DEFAULT)
    `uvm_field_enum(resp_type, resp, UVM_DEFAULT)
    `uvm_field_sarray_int(data, UVM_DEFAULT)
  `uvm_object_utils_end

  // Constructor
  function new(string name = "ahb_seq_item");
    super.new(name);
  endfunction
endclass

`endif
