package write_read_sequence_pkg;
import shared_pkg::*;
import uvm_pkg::*;
import sequenceItem_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"
 
class FIFO_write_read_sequence extends uvm_sequence #(FIFO_sequenceItem);
    `uvm_object_utils(FIFO_write_read_sequence) 

    `Func_new("FIFO_write_read_sequence")

    FIFO_sequenceItem item;
    // Main task
    task body();
        if (isFIRST_DIST_FINITH) begin
            WR_EN_ON_DIST = 30;
            RD_EN_ON_DIST = 70; 
        end
        repeat(HOBBIT_LOOP) begin
            item = `create_obj(FIFO_sequenceItem,"item")  // Creat seq_item
            ////////////////////////////
            //  edit constraint mode  //
            //    CONSTRAINT RULES    //
            ////////////////////////////
            `OFF_ALL
            `ON(CON_RESET)
            `ON(CON_W_R)
            `ON(CON_DATA_ONE_BIT)
            start_item(item);
            assert (item.randomize());
            finish_item(item);
        end
        repeat(BOOM_LOOP) begin
            item = `create_obj(FIFO_sequenceItem,"item")  // Creat seq_item
            ////////////////////////////
            //  edit constraint mode  //
            //    CONSTRAINT RULES    //
            ////////////////////////////
            `OFF_ALL
            `ON(CON_RESET)
            `ON(CON_W_R)
            start_item(item);
            assert (item.randomize());
            finish_item(item);
        end
    endtask
endclass //FIFO_write_read_sequence extends uvm_sequence #(FIFO_sequenceItem)
endpackage