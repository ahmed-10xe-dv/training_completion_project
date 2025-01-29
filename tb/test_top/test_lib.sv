/*************************************************************************
   > File Name:   test_lib.sv
   > Description: This file has all the tests extended from base test 
   > Author:      Ahmed Raza
   > Modified:    Ahmed Raza
   > Mail:        ahmed.raza@10xengineers.ai
   ---------------------------------------------------------------
   Copyright   (c)2024 10xEngineers
   ---------------------------------------------------------------
************************************************************************/

//-----------------------------------------------------------------------------  
// Test: basic_write_test
// Description: This test is simple write of 4 bytes on given addr
//-----------------------------------------------------------------------------  

`ifndef TEST_LIB
`define TEST_LIB
class basic_write_test extends axi2ahb_test;
    `uvm_component_utils(basic_write_test)

    function new(string name = "basic_write_test", uvm_component parent = null);
       super.new(name, parent);
     endfunction

    task main_phase(uvm_phase phase); 
      `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
      phase.raise_objection(this, "MAIN - raise_objection");
      fork
        fork
          fix_wr_beat1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
          fix_wr_data_beat1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
          wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
        join
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      join_any
      #50;
      phase.drop_objection(this, "MAIN - drop_objection");
      `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase

endclass

// -----------------------------------------------------------------------------  
// Test: fix_wr_beat16_test
// Description: This test is running fixed burst transaction of DW (Data Width) 4 
//              bytes, and data size of 4 bytes each transaction
// -----------------------------------------------------------------------------  

class fix_wr_beat16_test extends axi2ahb_test;
  `uvm_component_utils(fix_wr_beat16_test)

  function new(string name = "fix_wr_beat16_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_wr_beat16_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_beat16_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_wr_beat19_test
// Description: This test is running fixed burst transaction of DW (Data Width) 4 
//              bytes, and data size of 4 bytes each transaction, since we can only
//              send 16 fixed transactions, this test is to check what happens if we 
//              send more than that. 
// -----------------------------------------------------------------------------  

class fix_wr_beat19_test extends axi2ahb_test;
  `uvm_component_utils(fix_wr_beat19_test)

  function new(string name = "fix_wr_beat19_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_wr_beat19_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_beat19_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #100;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_wr_nrw1_beat15_test
// Description: This test is running fixed burst transaction of DW (Data Width) 1 
//              bytes, and data size of 1 byte each transaction, so we will have 1 
//              beat per transaction
// -----------------------------------------------------------------------------  

class fix_wr_nrw1_beat15_test extends axi2ahb_test;
  `uvm_component_utils(fix_wr_nrw1_beat15_test)

  function new(string name = "fix_wr_nrw1_beat15_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_wr_nrw1_beat15_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_nrw1_beat15_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #100;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_wr_nrw1_beat15x4_test
// Description: This test is running fixed burst transaction of DW (Data Width) 1 
//              bytes, and data size of 4 bytes each transaction, so we will have 4 
//              beats per transaction
// -----------------------------------------------------------------------------  

class fix_wr_nrw1_beat15x4_test extends axi2ahb_test;
  `uvm_component_utils(fix_wr_nrw1_beat15x4_test)

  function new(string name = "fix_wr_nrw1_beat15x4_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_wr_nrw1_beat15x4_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_nrw1_beat15x4_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_wr_nrw2_beat15_test
// Description: This test is running a fixed burst transaction of DW (Data Width) 2 
//              bytes, and data size of 2 bytes each transaction, resulting in 15 beats.
// -----------------------------------------------------------------------------  

class fix_wr_nrw2_beat15_test extends axi2ahb_test;
  `uvm_component_utils(fix_wr_nrw2_beat15_test)

  function new(string name = "fix_wr_nrw2_beat15_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_wr_nrw2_beat15_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_nrw2_beat15_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);  
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #100;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_wr_nrw2_beat15x2_test
// Description: This test is running a fixed burst transaction of DW (Data Width) 2 
//              bytes, and data size of 2 bytes each transaction, resulting in 30 beats.
// -----------------------------------------------------------------------------  

class fix_wr_nrw2_beat15x2_test extends axi2ahb_test;
  `uvm_component_utils(fix_wr_nrw2_beat15x2_test)

  function new(string name = "fix_wr_nrw2_beat15x2_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_wr_nrw2_beat15x2_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_nrw2_beat15x2_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #100;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: fix_wr_unaligned_test
// Description: This test checks the behavior of the design when an unaligned fixed 
//              burst transaction is performed. It sends two bust transactions of both size and
//              DW 4
// -----------------------------------------------------------------------------  

class fix_wr_unaligned_test extends axi2ahb_test;
  `uvm_component_utils(fix_wr_unaligned_test)

  function new(string name = "fix_wr_unaligned_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_wr_unaligned_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        fix_wr_data_unaligned_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #100;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_len1_test
// Description: This test is running an incremental burst transaction with length 1, 
//              DW (Data Width) is 4 bytes, and each transaction is of size 4 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_len1_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len1_test)

  function new(string name = "incr_wr_len1_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #100;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: incr_wr_len2_test
// Description: This test is running an incremental burst transaction with length 2, 
//              DW (Data Width) is 4 bytes, and each transaction is of size 8 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_len2_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len2_test)

  function new(string name = "incr_wr_len2_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len2_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len2_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr); 
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_len4_test
// Description: This test is running increment burst transaction with length 8.
//              Data Width (DW) is 4 bytes, and data size of 16 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_len4_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len4_test)

  function new(string name = "incr_wr_len4_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len4_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len4_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_len8_test
// Description: This test is running increment burst transaction with length 8.
//              Data Width (DW) is 4 bytes, and data size of 32.
// -----------------------------------------------------------------------------  

class incr_wr_len8_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len8_test)

  function new(string name = "incr_wr_len8_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len8_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len8_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_len16_test
// Description: This test is running increment burst transaction with length 16.
//              Data Width (DW) is 4 bytes, and data size of 64.
// -----------------------------------------------------------------------------  

class incr_wr_len16_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len16_test)

  function new(string name = "incr_wr_len16_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len16_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len16_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: incr_wr_len50_test
// Description: This test is running increment burst transaction with length 50.
//              Data Width (DW) is 4 bytes, and data size of 198 bytes.
//               
// -----------------------------------------------------------------------------  

class incr_wr_len50_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len50_test)

  function new(string name = "incr_wr_len50_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len50_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len50_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_len13_test
// Description: This test is running increment burst transaction with length 13.
//              Data Width (DW) is 4 bytes, and data size of 49 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_len13_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len13_test)

  function new(string name = "incr_wr_len13_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len13_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len13_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_len5_test
// Description: This test is running increment burst transaction with length 5.
//              Data Width (DW) is 4 bytes, and data size of 19.
// -----------------------------------------------------------------------------  

class incr_wr_len5_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len5_test)

  function new(string name = "incr_wr_len5_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len5_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len5_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr); 
      join

      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_len256_test
// Description: This test is running increment burst transaction with length 256.
//              Data Width (DW) is 4 bytes, and data size of 1024 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_len256_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_len256_test)

  function new(string name = "incr_wr_len256_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len256_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len256_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_nrw1_test
// Description: This test is running increment burst transaction with no response waiting.
//              Data Width (DW) is 1 byte, and data size of 4 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_nrw1_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_nrw1_test)

  function new(string name = "incr_wr_nrw1_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_nrw1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_nrw1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      begin
           ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_nrw1_len256_test
// Description: Increment burst write transaction with 1 narrow burst and length 256.
//              Data Width (DW) is 1 bytes, and data size of 256 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_nrw1_len256_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_nrw1_len256_test)

  function new(string name = "incr_wr_nrw1_len256_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_nrw1_len256_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_nrw1_len256_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: incr_wr_1kb_cross_test
// Description: Increment burst write transaction crossing 1KB boundary.
//              Data Width (DW) is 4 bytes, and data size of 16 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_1kb_cross_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_1kb_cross_test)

  function new(string name = "incr_wr_1kb_cross_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_1kb_cross_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_1kb_cross_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_unaligned_test
// Description: Increment burst write transaction with unaligned start address.
//              Data Width (DW) is 4 bytes, and data size of 8 bytes.
// -----------------------------------------------------------------------------  

class incr_wr_unaligned_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_unaligned_test)

  function new(string name = "incr_wr_unaligned_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_unaligned_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_unaligned_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_wr_nrw_unaligned_test
// Description: Increment burst write transaction with unaligned narrow burst.
//              Data Width (DW) is 2 bytes, and data size of 8.
// -----------------------------------------------------------------------------  

class incr_wr_nrw_unaligned_test extends axi2ahb_test;
  `uvm_component_utils(incr_wr_nrw_unaligned_test)

  function new(string name = "incr_wr_nrw_unaligned_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_nrw_unaligned_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_nrw_unaligned_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    #50;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: wrp2_wr_test
// Description: Write address sequence with 2 pending write transactions.
//              Verifies the address behavior for write transactions.
//              DW 4 bytes and Transfer size 8 bytes
// -----------------------------------------------------------------------------  

class wrp2_wr_test extends axi2ahb_test;
  `uvm_component_utils(wrp2_wr_test)

  function new(string name = "wrp2_wr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp2_wr_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp2_wr_data_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp4_wr_test
// Description: Write address sequence with 4 pending write transactions.
//              Verifies the address behavior for write transactions.
//              DW 4 bytes and Transfer size 16 bytes
// -----------------------------------------------------------------------------  

class wrp4_wr_test extends axi2ahb_test;
  `uvm_component_utils(wrp4_wr_test)

  function new(string name = "wrp4_wr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp4_wr_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp4_wr_data_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp8_wr_test
// Description: Write address sequence with 8 pending write transactions.
//              Verifies the address behavior for write transactions.
//              DW 4 bytes and Transfer size 32 bytes
// -----------------------------------------------------------------------------  

class wrp8_wr_test extends axi2ahb_test;
  `uvm_component_utils(wrp8_wr_test)

  function new(string name = "wrp8_wr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp8_wr_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp8_wr_data_nrw2_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp16_wr_test
// Description: Write address sequence with 16 pending write transactions.
//              Verifies the address behavior for write transactions.
//              DW 4 bytes and Transfer size 64 bytes
// -----------------------------------------------------------------------------  

class wrp16_wr_test extends axi2ahb_test;
  `uvm_component_utils(wrp16_wr_test)

  function new(string name = "wrp16_wr_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp16_wr_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp16_wr_data_nrw1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp2_wr_nrw1_test
// Description: Write address sequence with 2 pending write transactions, 
//              DW 1 bytes and Transfer size 2 bytes
// -----------------------------------------------------------------------------  

class wrp2_wr_nrw1_test extends axi2ahb_test;
  `uvm_component_utils(wrp2_wr_nrw1_test)

  function new(string name = "wrp2_wr_nrw1_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp2_wr_nrw1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp2_wr_data_nrw1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass



// -----------------------------------------------------------------------------  
// Test: wrp4_wr_nrw2_test
// Description: Write address sequence with 4 pending write transactions, 
//              DW 2 bytes and Transfer size 8 bytes
// -----------------------------------------------------------------------------  

class wrp4_wr_nrw2_test extends axi2ahb_test;
  `uvm_component_utils(wrp4_wr_nrw2_test)

  function new(string name = "wrp4_wr_nrw2_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp4_wr_nrw2_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp4_wr_data_nrw2_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp8_wr_nrw2_test
// Description: Write address sequence with 8 pending write transactions, 
//              DW 2 bytes and Transfer size 16 bytes
// -----------------------------------------------------------------------------  

class wrp8_wr_nrw2_test extends axi2ahb_test;
  `uvm_component_utils(wrp8_wr_nrw2_test)

  function new(string name = "wrp8_wr_nrw2_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp8_wr_nrw2_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp8_wr_data_nrw2_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: wrp16_wr_nrw1_test
// Description: Write address sequence with 16 pending write transactions, 
//              DW 1 byte and Transfer size 16 bytes
// -----------------------------------------------------------------------------  

class wrp16_wr_nrw1_test extends axi2ahb_test;
  `uvm_component_utils(wrp16_wr_nrw1_test)

  function new(string name = "wrp16_wr_nrw1_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp16_wr_nrw1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp16_wr_data_nrw1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: wrp4_wr_misaligned_test
// Description: Write address sequence with 4 pending write transactions 
//              starting at misaligned addresses.
// -----------------------------------------------------------------------------  

class wrp4_wr_misaligned_test extends axi2ahb_test;
  `uvm_component_utils(wrp4_wr_misaligned_test)

  function new(string name = "wrp4_wr_misaligned_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  task main_phase(uvm_phase phase);
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        wrp4_wr_misaligned_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        wrp4_wr_data_misaligned_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
      join

      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass





//   -----------------------------------------------------------------------------  
//   Test: basic_read_test
//   Description: 
//   -----------------------------------------------------------------------------  

class basic_read_test extends axi2ahb_test;
  `uvm_component_utils(basic_read_test)

  function new(string name = "basic_read_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase); 
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        fix_rd_beat1_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
        rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
        ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      join
      terminate_after_beats(1);
    join_any
    #20;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase

endclass

// -----------------------------------------------------------------------------  
// Test: fix_rd_beat16_test
// Description: This test is running fixed burst transaction of DW (Data Width) 4 
//              bytes, and data size of 4 bytes each transaction
// -----------------------------------------------------------------------------  

class fix_rd_beat16_test extends axi2ahb_test;
`uvm_component_utils(fix_rd_beat16_test)

function new(string name = "fix_rd_beat16_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      fix_rd_beat16_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(16);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_rd_beat19_test
// Description: This test is running fixed burst transaction of DW (Data Width) 4 
//              bytes, and data size of 4 bytes each transaction, since we can only
//              send 16 fixed transactions, this test is to check what happens if we 
//              send more than that. 
// -----------------------------------------------------------------------------  

class fix_rd_beat19_test extends axi2ahb_test;
`uvm_component_utils(fix_rd_beat19_test)

function new(string name = "fix_rd_beat19_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      fix_rd_beat19_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(19);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_rd_nrw1_beat15_test
// Description: This test is running fixed burst transaction of DW (Data Width) 1 
//              bytes, and data size of 1 byte each transaction, so we will have 1 
//              beat per transaction
// -----------------------------------------------------------------------------  

class fix_rd_nrw1_beat15_test extends axi2ahb_test;
`uvm_component_utils(fix_rd_nrw1_beat15_test)

function new(string name = "fix_rd_nrw1_beat15_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      fix_rd_nrw1_beat15_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
      terminate_after_beats(15);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: fix_rd_nrw2_beat15_test
// Description: This test is running a fixed burst transaction of DW (Data Width) 2 
//              bytes, and data size of 2 bytes each transaction, resulting in 15 beats.
// -----------------------------------------------------------------------------  

class fix_rd_nrw2_beat15_test extends axi2ahb_test;
`uvm_component_utils(fix_rd_nrw2_beat15_test)

function new(string name = "fix_rd_nrw2_beat15_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      fix_rd_nrw2_beat15_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(15);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: fix_rd_unaligned_test
// Description: This test checks the behavior of the design when an unaligned fixed 
//              burst transaction is performed. It sends two bust transactions of both size and
//              DW 4
// -----------------------------------------------------------------------------  

class fix_rd_unaligned_test extends axi2ahb_test;
`uvm_component_utils(fix_rd_unaligned_test)

function new(string name = "fix_rd_unaligned_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      fix_rd_unaligned_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(2);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_rd_len1_test
// Description: This test is running an incremental burst transaction with length 1, 
//              DW (Data Width) is 4 bytes, and each transaction is of size 4 bytes.
// -----------------------------------------------------------------------------  

class incr_rd_len1_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_len1_test)

function new(string name = "incr_rd_len1_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_len1_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(1);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: incr_rd_len2_test
// Description: This test is running an incremental burst transaction with length 2, 
//              DW (Data Width) is 4 bytes, and each transaction is of size 8 bytes.
// -----------------------------------------------------------------------------  

class incr_rd_len2_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_len2_test)

function new(string name = "incr_rd_len2_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_len2_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(2);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_rd_len4_test
// Description: This test is running increment burst transaction with length 8.
//              Data Width (DW) is 4 bytes, and data size of 16 bytes.
// -----------------------------------------------------------------------------  

class incr_rd_len4_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_len4_test)

function new(string name = "incr_rd_len4_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_len4_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(4);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_rd_len8_test
// Description: This test is running increment burst transaction with length 8.
//              Data Width (DW) is 4 bytes, and data size of 32.
// -----------------------------------------------------------------------------  

class incr_rd_len8_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_len8_test)

function new(string name = "incr_rd_len8_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_len8_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(8);
  join_any
  #1000;
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_rd_len16_test
// Description: This test is running increment burst transaction with length 16.
//              Data Width (DW) is 4 bytes, and data size of 64.
// -----------------------------------------------------------------------------  

class incr_rd_len16_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_len16_test)

function new(string name = "incr_rd_len16_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_len16_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(16);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_rd_len256_test
// Description: This test is running increment burst transaction with length 256.
//              Data Width (DW) is 4 bytes, and data size of 1024 bytes.
// -----------------------------------------------------------------------------  

class incr_rd_len256_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_len256_test)

function new(string name = "incr_rd_len256_test", uvm_component parent = null);
   super.new(name, parent);
 endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_len256_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
  join
  terminate_after_beats(256);
    join_any
  #50;
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_rd_1kb_cross_test
// Description: Increment burst read transaction crossing 1KB boundary.
//              Data Width (DW) is 4 bytes, and data size of 16 bytes.
// -----------------------------------------------------------------------------  

class incr_rd_1kb_cross_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_1kb_cross_test)

function new(string name = "incr_rd_1kb_cross_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_1kb_cross_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(4);
  join_any
  #50;
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: incr_rd_unaligned_test
// Description: Increment burst read transaction with unaligned start address.
//              Data Width (DW) is 4 bytes, and data size of 8 bytes.
// -----------------------------------------------------------------------------  

class incr_rd_unaligned_test extends axi2ahb_test;
`uvm_component_utils(incr_rd_unaligned_test)

function new(string name = "incr_rd_unaligned_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      incr_rd_unaligned_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(2);
  join_any
  #50;
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: wrp2_rd_test
// Description: read address sequence with 2 pending read transactions.
//              Verifies the address behavior for read transactions.
//              DW 4 bytes and Transfer size 8 bytes
// -----------------------------------------------------------------------------  

class wrp2_rd_test extends axi2ahb_test;
`uvm_component_utils(wrp2_rd_test)

function new(string name = "wrp2_rd_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      wrp2_rd_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(2);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp4_rd_test
// Description: read address sequence with 4 pending read transactions.
//              Verifies the address behavior for read transactions.
//              DW 4 bytes and Transfer size 16 bytes
// -----------------------------------------------------------------------------  

class wrp4_rd_test extends axi2ahb_test;
`uvm_component_utils(wrp4_rd_test)

function new(string name = "wrp4_rd_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      wrp4_rd_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(4);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp8_rd_test
// Description: read address sequence with 8 pending read transactions.
//              Verifies the address behavior for read transactions.
//              DW 4 bytes and Transfer size 32 bytes
// -----------------------------------------------------------------------------  

class wrp8_rd_test extends axi2ahb_test;
`uvm_component_utils(wrp8_rd_test)

function new(string name = "wrp8_rd_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      wrp8_rd_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(8);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp16_rd_test
// Description: read address sequence with 16 pending read transactions.
//              Verifies the address behavior for read transactions.
//              DW 4 bytes and Transfer size 64 bytes
// -----------------------------------------------------------------------------  

class wrp16_rd_test extends axi2ahb_test;
`uvm_component_utils(wrp16_rd_test)

function new(string name = "wrp16_rd_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      wrp16_rd_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(16);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass

// -----------------------------------------------------------------------------  
// Test: wrp4_rd_misaligned_test
// Description: read address sequence with 4 pending read transactions 
//              starting at misaligned addresses.
// -----------------------------------------------------------------------------  

class wrp4_rd_misaligned_test extends axi2ahb_test;
`uvm_component_utils(wrp4_rd_misaligned_test)

function new(string name = "wrp4_rd_misaligned_test", uvm_component parent = null);
  super.new(name, parent);
endfunction

task main_phase(uvm_phase phase);
  `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
  phase.raise_objection(this, "MAIN - raise_objection");
  fork
    fork
      wrp4_rd_misaligned_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
      rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
    join
    terminate_after_beats(4);
  join_any
  phase.drop_objection(this, "MAIN - drop_objection");
  `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
//R E A D   W R I T E   T E S T S 
// -----------------------------------------------------------------------------  

// -----------------------------------------------------------------------------  
// Test: basic_rd_wr_test
// Description: Generating a basic fixed burst read write Address transaction with len 1 on the AXI read Address Channel. and Write Address Channel respectively 
// -----------------------------------------------------------------------------  
class basic_rd_wr_test extends axi2ahb_test;
  `uvm_component_utils(basic_rd_wr_test)

  function new(string name = "basic_rd_wr_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase); 
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork: main
        fork: axi_fork
          fix_wr_beat1_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
          fix_wr_data_beat1_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
          wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
        join
  
        fork: ahb_fork
          fix_rd_beat1_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
          rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
        join
        begin
          int count =0;
          while (count<1) begin
            @(posedge axi_vif.ACLK);
            if (axi_vif.RVALID) begin
              count++; 
            end
          end
          disable ahb_fork;
        end
      join

      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);

    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: incr_rd_wr_len8_test
// Description:  Generating a INCR burst read write Address transaction with len 8 on the AXI read Address Channel. and Write Address Channel respectively 
// -----------------------------------------------------------------------------  
class incr_rd_wr_len8_test extends axi2ahb_test;
  `uvm_component_utils(incr_rd_wr_len8_test)

  function new(string name = "incr_rd_wr_len8_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase); 
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork: main
        fork: axi_fork
          incr_wr_len8_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
          incr_wr_data_len8_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
          wr_rsp_seq.start( env.axi_env.wr_rsp_agnt.wr_rsp_sqr);
        join
  
        fork: ahb_fork
          incr_rd_len8_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
          rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
        join
        begin
          int count =0;
          while (count<8) begin
            @(posedge axi_vif.ACLK);
            if (axi_vif.RVALID) begin
              count++; 
            end
          end
          disable ahb_fork;
        end
      join

      ahb_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);

    join_any
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: rd_timeout_test
// Description: Generating an INCR transaction and using the HREADY signal of AHB slave to control the behavior of DUT 
// -----------------------------------------------------------------------------  
class rd_timeout_test extends axi2ahb_test;
  `uvm_component_utils(rd_timeout_test)

  function new(string name = "rd_timeout_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase); 
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
        fork: ahb_fork
          incr_rd_len2_h.start(env.axi_env.rd_addr_agnt.rd_addr_sqr);
          rd_data_seq.start(env.axi_env.rd_data_agnt.rd_data_sqr);
          begin
            ahb_slverr_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
          end
        join
        terminate_after_beats(2);
    join_any
    #1000;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: wr_timeout_test
// Description: Generating an INCR transaction and using the HREADY signal of AHB slave to control the behavior of DUT
// -----------------------------------------------------------------------------  
class wr_timeout_test extends axi2ahb_test;
  `uvm_component_utils(wr_timeout_test)

  function new(string name = "wr_timeout_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase); 
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
      fork
        incr_wr_len2_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len2_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr); 
        ahb_slverr_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      join_any
    #2000;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass


// -----------------------------------------------------------------------------  
// Test: wr_slverr_test
// Description: Generating a write transaction with a slave sequence giving an error response
// -----------------------------------------------------------------------------  
class wr_slverr_test extends axi2ahb_test;
  `uvm_component_utils(wr_slverr_test)

  function new(string name = "wr_slverr_test", uvm_component parent = null);
     super.new(name, parent);
   endfunction

  task main_phase(uvm_phase phase); 
    `uvm_info(get_name(), "MAIN PHASE STARTED", UVM_LOW);
    phase.raise_objection(this, "MAIN - raise_objection");
    fork
      fork
        incr_wr_len2_h.start(env.axi_env.wr_addr_agnt.wr_addr_sqr);
        incr_wr_data_len2_h.start(env.axi_env.wr_data_agnt.wr_data_sqr);
        wr_rsp_seq.start(env.axi_env.wr_rsp_agnt.wr_rsp_sqr); 
      join
      begin
        ahb_err_seq.start(env.ahb_env.ahb_agnt.ahb_sqr);
      end
    join_any
    #100;
    phase.drop_objection(this, "MAIN - drop_objection");
    `uvm_info(get_name(), "MAIN PHASE ENDED", UVM_LOW);
  endtask : main_phase
endclass

`endif
