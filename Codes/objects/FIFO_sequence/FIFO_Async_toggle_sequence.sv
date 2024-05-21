package Async_toggle_sequence_pkg;
import shared_pkg::*;
import uvm_pkg::*;
import sequenceItem_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"
   
class FIFO_Async_toggle_sequence extends uvm_sequence #(FIFO_sequenceItem);
    `uvm_object_utils(FIFO_Async_toggle_sequence)

    `Func_new("FIFO_Async_toggle_sequence")

    FIFO_sequenceItem item;
    // Main task
    task body();
        for (int i = WR_START_VALUE_OF_TOGGLE; i<GIANT_LOOP; i++) begin
            item = `create_obj(FIFO_sequenceItem, "item")  // Creat seq_item
            ////////////////////////////
            //  edit constraint mode  //
            //    CONSTRAINT RULES    //
            ////////////////////////////
            `OFF_ALL
            `ON(CON_RESET)
            `ON(CON_DATA_ONE_BIT)

            start_item(item);
            assert (item.randomize());
            item.wr_en = i%2;
            item.rd_en = !(i%2);
            finish_item(item);
        end
    endtask
endclass //FIFO_Async_toggle_sequence extends uvm_sequence #(FIFO_sequenceItem)
endpackage
