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

    task main_phase(uvm_phase phase);
      `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
      phase.raise_objection(this, "MAIN - raise_objection");
      fork
        fix_wr_beat1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_beat1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
        begin
             ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
        end
      join_any
      #200;
      phase.drop_objection(this, "MAIN - drop_objection");
      `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase

endclass


//-----------------------------------------------------------------------------  
// Test: basic_write_test
// Description: 
//-----------------------------------------------------------------------------  

// class basic_write_test extends axi2ahb_test;
//   `uvm_component_utils(basic_write_test)

//   function new(string name = "basic_write_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       fix_wr_beat1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
//       fix_wr_data_beat1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
//       wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
//       begin
//            ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #200;
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
// endtask : main_phase

// endclass


//-----------------------------------------------------------------------------  
// Test: fixd_wr_multiple_beats_test
// Description: 
//-----------------------------------------------------------------------------  

// class fixd_wr_multiple_beats_test extends axi2ahb_test;
//   `uvm_component_utils(fixd_wr_multiple_beats_test)

//   function new(string name = "fixd_wr_multiple_beats_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       fixd_wr_seq_multiple_beats.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
//       fixd_wr_data_seq_multiple_beats.start(env.axi_env.wr_data_agnt.wr_data_sqr);
//       wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
//       begin
//            ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #950;
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
// endtask : main_phase

// endclass




//   //-----------------------------------------------------------------------------  
//   // Test: basic_read_multiple_beats_test
//   // Description: 
//   //-----------------------------------------------------------------------------  

// class basic_read_multiple_beats_test extends axi2ahb_test;
//   `uvm_component_utils(basic_read_multiple_beats_test)

//   function new(string name = "basic_read_multiple_beats_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//    function void build_phase(uvm_phase phase);
//      super.build_phase(phase);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       rd_addr_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           /*  Waiting here to make sure that AHB sequence starts 
//               once the valid axi transactions have started */
//           wait(axi_vif.ARREADY || axi_vif.AWREADY || axi_vif.ARREADY); 
//           @(posedge axi_vif.ACLK);
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join
//     #20;
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
// endtask : main_phase

// endclass


  //-----------------------------------------------------------------------------  
  // Test: basic_incr_wr_test
  // Description: 
  //-----------------------------------------------------------------------------  

  // class basic_incr_wr_test extends axi2ahb_test;
  //   `uvm_component_utils(basic_incr_wr_test)
  
  //   function new(string name = "basic_incr_wr_test", uvm_component parent = null);
  //      super.new(name, parent);
  //    endfunction
  
  //    function void build_phase(uvm_phase phase);
  //      set_type_override_by_type(axi_wr_addr_sequence::get_type(), basic_inc_write_txn::get_type());
  //      set_type_override_by_type(axi_wr_data_sequence::get_type(), basic_inc_write_data_txn::get_type());
  //     //  ahb_seq.Transactions_Count = 1;
  //      super.build_phase(phase);
  //    endfunction
  
  //   task main_phase(uvm_phase phase);
  //     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  //     phase.raise_objection(this, "MAIN - raise_objection");
  //     fork
  //       wr_addr_seq.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
  //       wr_data_seq.start(env.axi_env.wr_data_agnt.wr_data_sqr);
  //       wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
  //       begin

  //           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
  //       end
  //     join
  //     #20;
  //     phase.drop_objection(this, "MAIN - drop_objection");
  //     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  // endtask : main_phase
  
  // endclass







  // Read Tests



  //-----------------------------------------------------------------------------  
  // Test: basic_read_test
  // Description: 
  //-----------------------------------------------------------------------------  

// class basic_read_test extends axi2ahb_test;
//   `uvm_component_utils(basic_read_test)

//   function new(string name = "basic_read_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       basic_rd_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #150;
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass

// //-----------------------------------------------------------------------------  
// // Test: inc_rd_len1_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class inc_rd_len1_test extends axi2ahb_test;
//   `uvm_component_utils(inc_rd_len1_test)

//   function new(string name = "inc_rd_len1_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       inc_rd_len1_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #120; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: inc_rd_len2_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class inc_rd_len2_test extends axi2ahb_test;
//   `uvm_component_utils(inc_rd_len2_test)

//   function new(string name = "inc_rd_len2_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       inc_rd_len2_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #150; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass



//-----------------------------------------------------------------------------  
// Test: incr_rd_test
// Description:  
//-----------------------------------------------------------------------------  

// class incr_rd_test extends axi2ahb_test;
//   `uvm_component_utils(incr_rd_test)

//   function new(string name = "incr_rd_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       incr_rd_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #200; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass



//-----------------------------------------------------------------------------  
// Test: wrap_rd_large_test
// Description:  
//-----------------------------------------------------------------------------  

// class wrap_rd_large_test extends axi2ahb_test;
//   `uvm_component_utils(wrap_rd_large_test)

//   function new(string name = "wrap_rd_large_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       wrap_rd_large_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass



// //-----------------------------------------------------------------------------  
// // Test: incr_rd_single_beat_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class incr_rd_single_beat_test extends axi2ahb_test;
//   `uvm_component_utils(incr_rd_single_beat_test)

//   function new(string name = "incr_rd_single_beat_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       incr_rd_single_beat_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass




// //-----------------------------------------------------------------------------  
// // Test: fixed_rd_large_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class fixed_rd_large_test extends axi2ahb_test;
//   `uvm_component_utils(fixed_rd_large_test)

//   function new(string name = "fixed_rd_large_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       fixed_rd_large_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: wrap_rd_small_width_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class wrap_rd_small_width_test extends axi2ahb_test;
//   `uvm_component_utils(wrap_rd_small_width_test)

//   function new(string name = "wrap_rd_small_width_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       wrap_rd_small_width_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass

// //-----------------------------------------------------------------------------  
// // Test: incr_rd_mixed_size_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class incr_rd_mixed_size_test extends axi2ahb_test;
//   `uvm_component_utils(incr_rd_mixed_size_test)

//   function new(string name = "incr_rd_mixed_size_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       incr_rd_mixed_size_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: fixed_rd_single_small_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class fixed_rd_single_small_test extends axi2ahb_test;
//   `uvm_component_utils(fixed_rd_single_small_test)

//   function new(string name = "fixed_rd_single_small_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       fixed_rd_single_small_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: incr_rd_large_offset_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class incr_rd_large_offset_test extends axi2ahb_test;
//   `uvm_component_utils(incr_rd_large_offset_test)

//   function new(string name = "incr_rd_large_offset_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       incr_rd_large_offset_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: fixed_rd_alt_beat_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class fixed_rd_alt_beat_test extends axi2ahb_test;
//   `uvm_component_utils(fixed_rd_alt_beat_test)

//   function new(string name = "fixed_rd_alt_beat_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       fixed_rd_alt_beat_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass



// //-----------------------------------------------------------------------------  
// // Test: wrap_rd_non_aligned_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class wrap_rd_non_aligned_test extends axi2ahb_test;
//   `uvm_component_utils(wrap_rd_non_aligned_test)

//   function new(string name = "wrap_rd_non_aligned_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       wrap_rd_non_aligned_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass



// //-----------------------------------------------------------------------------  
// // Test: incr_rd_rand_addr_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class incr_rd_rand_addr_test extends axi2ahb_test;
//   `uvm_component_utils(incr_rd_rand_addr_test)

//   function new(string name = "incr_rd_rand_addr_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       incr_rd_rand_addr_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: wrap_rd_full_data_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class wrap_rd_full_data_test extends axi2ahb_test;
//   `uvm_component_utils(wrap_rd_full_data_test)

//   function new(string name = "wrap_rd_full_data_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       wrap_rd_full_data_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #350; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: fixed_rd_seq_data_inc_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class fixed_rd_seq_data_inc_test extends axi2ahb_test;
//   `uvm_component_utils(fixed_rd_seq_data_inc_test)

//   function new(string name = "fixed_rd_seq_data_inc_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       fixed_rd_seq_data_inc_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #550; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass



// //-----------------------------------------------------------------------------  
// // Test: incr_rd_var_beat_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class incr_rd_var_beat_test extends axi2ahb_test;
//   `uvm_component_utils(incr_rd_var_beat_test)

//   function new(string name = "incr_rd_var_beat_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       incr_rd_var_beat_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #1000; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass



// //-----------------------------------------------------------------------------  
// // Test: wrap_rd_misaligned_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class wrap_rd_misaligned_test extends axi2ahb_test;
//   `uvm_component_utils(wrap_rd_misaligned_test)

//   function new(string name = "wrap_rd_misaligned_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       wrap_rd_misaligned_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #300; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass


// //-----------------------------------------------------------------------------  
// // Test: fixed_rd_alt_id_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class fixed_rd_alt_id_test extends axi2ahb_test;
//   `uvm_component_utils(fixed_rd_alt_id_test)

//   function new(string name = "fixed_rd_alt_id_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       fixed_rd_alt_id_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #2000; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass

// //-----------------------------------------------------------------------------  
// // Test: rd_single_beat_multi_test
// // Description:  
// //-----------------------------------------------------------------------------  

// class rd_single_beat_multi_test extends axi2ahb_test;
//   `uvm_component_utils(rd_single_beat_multi_test)

//   function new(string name = "rd_single_beat_multi_test", uvm_component parent = null);
//      super.new(name, parent);
//    endfunction

//   task main_phase(uvm_phase phase);
//     `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
//     phase.raise_objection(this, "MAIN - raise_objection");
//     fork
//       rd_single_beat_multi_seq.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
//       rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
//       begin
//           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
//       end
//     join_any
//     #1000; // Delay after join_any
//     phase.drop_objection(this, "MAIN - drop_objection");
//     `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
//   endtask : main_phase

// endclass















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