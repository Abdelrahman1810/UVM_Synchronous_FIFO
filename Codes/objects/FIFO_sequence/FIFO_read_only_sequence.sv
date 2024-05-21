package read_only_sequence_pkg;
import shared_pkg::*;
import uvm_pkg::*;
import sequenceItem_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"
 
class FIFO_read_only_sequence extends uvm_sequence #(FIFO_sequenceItem);
    `uvm_object_utils(FIFO_read_only_sequence) 

    `Func_new("FIFO_read_only_sequence")
    FIFO_sequenceItem item;
    // Main task
    task body();
        if (isFirstRead)
            repeat(BEFORE_ALMOST) begin
                item = `create_obj(FIFO_sequenceItem, "item")  // Creat seq_item
                ////////////////////////////
                //  edit constraint mode  //
                //    CONSTRAINT RULES    //
                ////////////////////////////
                `OFF_ALL
                `ON(CON_RESET)
                `ON(CON_R)

                start_item(item);
                assert (item.randomize());
                finish_item(item);
            end
        else 
            repeat(DEPTH_LOOP) begin
                item = `create_obj(FIFO_sequenceItem, "item")  // Creat seq_item
                ////////////////////////////
                //  edit constraint mode  //
                //    CONSTRAINT RULES    //
                ////////////////////////////
                `OFF_ALL
                `ON(CON_RESET)
                `ON(CON_R)

                start_item(item);
                assert (item.randomize());
                finish_item(item);
            end

        isFirstRead = 0;
    endtask
endclass //FIFO_read_only_sequence extends uvm_sequence #(FIFO_sequenceItem)
endpackage