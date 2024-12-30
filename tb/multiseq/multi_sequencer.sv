// // ╔════════════════════════════════════════════════════════════════════════════╗
// // ║                         CLASS: virtual_sequencer                           ║
// // ║     Author      : Ahmed Raza                                               ║
// // ║     Date        : 25 Nov 2024                                              ║
// // ║     Description : This class defines a virtual sequencer that coordinates  ║
// // ║                   the execution of instruction and data sequencers.        ║
// // ║                   It ensures that the instruction and data sequences       ║
// // ║                   run under the same control, synchronizing them as needed.║
// // ╚════════════════════════════════════════════════════════════════════════════╝

// class virtual_sequencer extends uvm_sequencer;

//     // Data and instruction sequencers managed by the virtual sequencer
//     data_sequencer                   data_seqr;
//     inst_sequencer                   instr_seqr;
  
//     `uvm_component_utils(virtual_sequencer)
//     `uvm_component_new
  
//   endclass