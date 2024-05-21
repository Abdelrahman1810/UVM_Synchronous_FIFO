package write_only_sequence_pkg;
import shared_pkg::*;
import uvm_pkg::*;
import sequenceItem_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"
//`define create_item FIFO_sequenceItem::type_id::create("item");
//`define OFF_ALL item.constraint_mode(0);
//`define ON(constraint) item.constraint.constraint_mode(1);

class FIFO_write_only_sequence extends uvm_sequence #(FIFO_sequenceItem);
    `uvm_object_utils(FIFO_write_only_sequence)
    
    `Func_new("FIFO_write_only_sequence")

    FIFO_sequenceItem item;
    // Main task
    task body();
        if (isWriteTOfull)
            repeat(DEPTH_LOOP) begin
                item = `create_obj(FIFO_sequenceItem, "item")  // Creat seq_item
                ////////////////////////////
                //  edit constraint mode  //
                //    CONSTRAINT RULES    //
                ////////////////////////////
                `OFF_ALL
                `ON(CON_RESET)
                `ON(CON_W)

                start_item(item);
                assert (item.randomize());
                finish_item(item);
            end
        else
            repeat(BEFORE_ALMOST) begin
                item = `create_obj(FIFO_sequenceItem, "item")  // Creat seq_item
                ////////////////////////////
                //  edit constraint mode  //
                //    CONSTRAINT RULES    //
                ////////////////////////////
                `OFF_ALL
                `ON(CON_RESET)
                `ON(CON_W)

                start_item(item);
                assert (item.randomize());
                finish_item(item);
            end
        isWriteTOfull = 0;
    endtask
endclass //FIFO_write_only_sequence extends uvm_sequence #(FIFO_sequenceItem)
endpackage