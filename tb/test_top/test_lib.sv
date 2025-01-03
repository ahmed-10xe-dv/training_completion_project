/*************************************************************************
   > File Name:   test_lib.sv
   > Description: 
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/


class basic_write_test extends axi2ahb_test;
    `uvm_component_utils(basic_write_test)

    function new(string name = "basic_write_test", uvm_component parent = null);
       super.new(name, parent);
     endfunction
     function void build_phase(uvm_phase phase);
       set_type_override_by_type(axi_sequence::get_type(), basic_write_txn::get_type());
      //  uvm_config_db #(uvm_active_passive_enum)::set(null, "*.wr_rsp_agnt", "is_active", UVM_PASSIVE);

       super.build_phase(phase);
     endfunction
endclass

class basic_read_test extends axi2ahb_test;
    `uvm_component_utils(basic_read_test)

    function new(string name = "basic_read_test", uvm_component parent = null);
       super.new(name, parent);
     endfunction
     
     function void build_phase(uvm_phase phase);
       set_type_override_by_type(axi_sequence::get_type(), basic_read_txn::get_type());
       super.build_phase(phase);
     endfunction
endclass

class basic_inc_write_test extends axi2ahb_test;
  `uvm_component_utils(basic_inc_write_test)

  function new(string name = "basic_inc_write_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction
   function void build_phase(uvm_phase phase);
     set_type_override_by_type(axi_sequence::get_type(), basic_inc_write_txn::get_type());
     super.build_phase(phase);
   endfunction
endclass


class basic_inc_read_test extends axi2ahb_test;
  `uvm_component_utils(basic_inc_read_test)

  function new(string name = "basic_inc_read_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction
   function void build_phase(uvm_phase phase);
     set_type_override_by_type(axi_sequence::get_type(), basic_inc_read_txn::get_type());
     super.build_phase(phase);
   endfunction
endclass

class basic_rd_wr_test extends axi2ahb_test;
  `uvm_component_utils(basic_rd_wr_test)

  function new(string name = "basic_rd_wr_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction
   function void build_phase(uvm_phase phase);
     set_type_override_by_type(axi_sequence::get_type(), basic_rd_wr_txn::get_type());
     super.build_phase(phase);
   endfunction
endclass