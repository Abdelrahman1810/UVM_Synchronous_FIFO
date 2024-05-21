package random_sequence_pkg;
import shared_pkg::*;
import uvm_pkg::*;
import sequenceItem_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"
 
class FIFO_random_sequence extends uvm_sequence #(FIFO_sequenceItem);
    `uvm_object_utils(FIFO_random_sequence) 

    `Func_new("FIFO_random_sequence")

    FIFO_sequenceItem item;
    // Main task
    task body();
        repeat(BOOM_LOOP) begin
            item = `create_obj(FIFO_sequenceItem, "item")  // Creat seq_item
            ////////////////////////////
            //  edit constraint mode  //
            //    CONSTRAINT RULES    //
            ////////////////////////////
            `OFF_ALL
            `ON(CON_RESET)
            `ON(CON_DATA_MAX_ZERO)

            start_item(item);
            assert (item.randomize());
            finish_item(item);
        end
    endtask
endclass //FIFO_random_sequence extends uvm_sequence #(FIFO_sequenceItem)
endpackage