package rst_sequence_pkg;
import shared_pkg::*;
import sequenceItem_pkg::*;
import uvm_pkg::*;
`include "defines/defines.svh"
`include "uvm_macros.svh"
 
class FIFO_reset_sequence extends uvm_sequence #(FIFO_sequenceItem);
    `uvm_object_utils(FIFO_reset_sequence) 

    `Func_new("FIFO_reset_sequence")

    FIFO_sequenceItem item;
    // Main task
    task body;
        // Creat seq_item
        item = `create_obj(FIFO_sequenceItem, "item")
        `OFF_ALL
        repeat(5) begin
            start_item(item);
            item.data_in = 0; item.wr_en = 0; item.rd_en = 0;
            item.rst_n = 0;
            finish_item(item);
        end
    endtask
endclass //FIFO_reset_sequence extends uvm_sequence #(FIFO_sequenceItem)
endpackage