package sequencer_pkg;
import uvm_pkg::*;
import sequenceItem_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"

// sequencer class
class sequencer extends uvm_sequencer #(FIFO_sequenceItem);
    `uvm_component_utils(sequencer)
    `Func_new_p("sequencer")
endclass //sequencer extends uvm_sequencer #(FIFO_sequenceItem)
endpackage