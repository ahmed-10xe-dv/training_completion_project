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

//-----------------------------------------------------------------------------  
// Test: basic_write_test
// Description: 
//-----------------------------------------------------------------------------  

class basic_write_test extends axi2ahb_test;
    `uvm_component_utils(basic_write_test)

    function new(string name = "basic_write_test", uvm_component parent = null);
       super.new(name, parent);
     endfunction

     function void build_phase(uvm_phase phase);
       set_type_override_by_type(axi_wr_addr_sequence::get_type(), basic_wr_addr_txn::get_type());
       set_type_override_by_type(axi_wr_data_sequence::get_type(), basic_wr_data_txn::get_type());
       super.build_phase(phase);
     endfunction

    task main_phase(uvm_phase phase);
      `uvm_info(get_full_name(), "MAIN PHASE STARTED", UVM_LOW);
      phase.raise_objection(this, "MAIN - raise_objection");
      fork
        wr_addr_seq.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wr_data_seq.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
        begin
            /*  Waiting here to make sure that AHB sequence starts 
                once the valid axi transactions have started */
            wait(axi_vif.ARREADY || axi_vif.AWREADY || axi_vif.ARREADY); 
            @(posedge axi_vif.ACLK);
            ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
        end
      join_any
      #200;
      phase.drop_objection(this, "MAIN - drop_objection");
      `uvm_info(get_full_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase

endclass


  //-----------------------------------------------------------------------------  
  // Test: basic_read_test
  // Description: 
  //-----------------------------------------------------------------------------  

class basic_read_test extends axi2ahb_test;
  `uvm_component_utils(basic_read_test)

  function new(string name = "basic_read_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
     set_type_override_by_type(axi_rd_addr_sequence::get_type(), basic_rd_addr_txn::get_type());
     super.build_phase(phase);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      rd_addr_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      begin
          /*  Waiting here to make sure that AHB sequence starts 
              once the valid axi transactions have started */
          // wait(axi_vif.ARREADY || axi_vif.AWREADY || axi_vif.ARREADY); 
          // wait(axi_vif.ARREADY || axi_vif.AWREADY || axi_vif.ARREADY); 

          // @(posedge axi_vif.ACLK);
          // @(ahb_vif.HADDR);
          ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #300;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_full_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase

endclass


  //-----------------------------------------------------------------------------  
  // Test: basic_read_multiple_beats_test
  // Description: 
  //-----------------------------------------------------------------------------  

class basic_read_multiple_beats_test extends axi2ahb_test;
  `uvm_component_utils(basic_read_multiple_beats_test)

  function new(string name = "basic_read_multiple_beats_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

   function void build_phase(uvm_phase phase);
     set_type_override_by_type(axi_rd_addr_sequence::get_type(), basic_rd_multiple_beats_txn::get_type());
     ahb_seq.Transactions_Count = 1;
     super.build_phase(phase);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_full_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      rd_addr_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      begin
          /*  Waiting here to make sure that AHB sequence starts 
              once the valid axi transactions have started */
          wait(axi_vif.ARREADY || axi_vif.AWREADY || axi_vif.ARREADY); 
          @(posedge axi_vif.ACLK);
          ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join
    #20;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_full_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase

endclass


  //-----------------------------------------------------------------------------  
  // Test: basic_incr_wr_test
  // Description: 
  //-----------------------------------------------------------------------------  

  class basic_incr_wr_test extends axi2ahb_test;
    `uvm_component_utils(basic_incr_wr_test)
  
    function new(string name = "basic_incr_wr_test", uvm_component parent = null);
       super.new(name, parent);
     endfunction
  
     function void build_phase(uvm_phase phase);
       set_type_override_by_type(axi_wr_addr_sequence::get_type(), basic_inc_write_txn::get_type());
       set_type_override_by_type(axi_wr_data_sequence::get_type(), basic_inc_write_data_txn::get_type());
       ahb_seq.Transactions_Count = 1;
       super.build_phase(phase);
     endfunction
  
    task main_phase(uvm_phase phase);
      `uvm_info(get_full_name(), "MAIN PHASE STARTED", UVM_LOW);
      phase.raise_objection(this, "MAIN - raise_objection");
      fork
        wr_addr_seq.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wr_data_seq.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
        begin
            /*  Waiting here to make sure that AHB sequence starts 
                once the valid axi transactions have started */
            wait(axi_vif.ARREADY || axi_vif.AWREADY || axi_vif.ARREADY); 
            @(posedge axi_vif.ACLK);
            ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
        end
      join
      #20;
      phase.drop_objection(this, "MAIN - drop_objection");
      `uvm_info(get_full_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
  
  endclass


// class basic_read_test extends axi2ahb_test;
//     `uvm_component_utils(basic_read_test)

//     function new(string name = "basic_read_test", uvm_component parent = null);
//        super.new(name, parent);
//      endfunction
     
//      function void build_phase(uvm_phase phase);
//       super.build_phase(phase);
//       // int Transactions_Count;
//       //  set_type_override_by_type(axi_sequence::get_type(), basic_read_txn::get_type());
//        mul_seq.ahb_seq.Transactions_Count = 4;
//       uvm_config_db #(int) :: set(this, "env.ahb_env.ahb_agnt", "Transactions_Count", 5);
//      endfunction
// endclass

// class basic_inc_write_test extends axi2ahb_test;
//   `uvm_component_utils(basic_inc_write_test)

//   function new(string name = "basic_inc_write_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction
//    function void build_phase(uvm_phase phase);
//      set_type_override_by_type(axi_sequence::get_type(), basic_inc_write_txn::get_type());
//      super.build_phase(phase);
//    endfunction
// endclass


// class basic_inc_read_test extends axi2ahb_test;
//   `uvm_component_utils(basic_inc_read_test)

//   function new(string name = "basic_inc_read_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction
//    function void build_phase(uvm_phase phase);
//      set_type_override_by_type(axi_sequence::get_type(), basic_inc_read_txn::get_type());
//     //  set_type_override_by_type(ahb_sequence::get_type(), basic_read_seq::get_type());
//      super.build_phase(phase);
//    endfunction
// endclass

// class basic_rd_wr_test extends axi2ahb_test;
//   `uvm_component_utils(basic_rd_wr_test)

//   function new(string name = "basic_rd_wr_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction
//    function void build_phase(uvm_phase phase);
//      set_type_override_by_type(axi_sequence::get_type(), basic_rd_wr_txn::get_type());
//     //  set_type_override_by_type(ahb_sequence::get_type(), basic_read_seq::get_type());
//      super.build_phase(phase);
//    endfunction
// endclass



// class basic_fixed_wr_test extends axi2ahb_test;
//   `uvm_component_utils(basic_fixed_wr_test)

//   function new(string name = "basic_fixed_wr_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction
//    function void build_phase(uvm_phase phase);
//      set_type_override_by_type(axi_sequence::get_type(), basic_fixed_wr_txn::get_type());
//      super.build_phase(phase);
//    endfunction
// endclass


// class boundary_cross_test extends axi2ahb_test;
//   `uvm_component_utils(boundary_cross_test)

//   function new(string name = "boundary_cross_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction
//    function void build_phase(uvm_phase phase);
//      set_type_override_by_type(axi_sequence::get_type(), boundary_cross_txn::get_type());
//      super.build_phase(phase);
//    endfunction
// endclass

// class basic_wrap4_wr_test extends axi2ahb_test;
//   `uvm_component_utils(basic_wrap4_wr_test)

//   function new(string name = "basic_wrap4_wr_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction
//    function void build_phase(uvm_phase phase);
//      set_type_override_by_type(axi_sequence::get_type(), basic_wrap4_wr_txn::get_type());
//      super.build_phase(phase);
//    endfunction
// endclass


// class basic_fixed_wr_nrw_trnsfr_test extends axi2ahb_test;
//   `uvm_component_utils(basic_fixed_wr_nrw_trnsfr_test)

//   function new(string name = "basic_fixed_wr_nrw_trnsfr_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction
//    function void build_phase(uvm_phase phase);
//      set_type_override_by_type(axi_sequence::get_type(), basic_fixed_wr_txn_with_holes::get_type());
//      super.build_phase(phase);
//    endfunction
// endclass