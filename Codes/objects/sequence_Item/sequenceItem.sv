package sequenceItem_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"

// Sequence Item class Valid and Invalid
class FIFO_sequenceItem extends uvm_sequence_item;
    `uvm_object_utils(FIFO_sequenceItem) 
// input
    rand bit [FIFO_WIDTH-1:0] data_in;
    rand bit rst_n, wr_en, rd_en;

// output DUT
    bit [FIFO_WIDTH-1:0] data_out;
    bit wr_ack, overflow;
    bit full, empty, almostfull, almostempty, underflow;

// output refrence
    bit [FIFO_WIDTH-1:0] data_out_ref;
    bit wr_ack_ref, overflow_ref;
    bit full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;

// new
    `Func_new("FIFO_sequenceItem")


// my function to print FIFO DUT and REF
    function string print_DUT();
        return $sformatf("DUT:\ndata_out = %0d, wr_ack = %0d, full = %0d, empty = %0d, underflow = %0d, almostempty = %0d, almostfull = %0d, overflow = %0d",
        data_out, wr_ack, full, empty, underflow, almostempty, almostfull, overflow
        ); 
    endfunction
    
    function string print_REF();
        return $sformatf("REF:\ndata_out_ref = %0d, wr_ack_ref = %0d, full_ref = %0d, empty_ref = %0d, underflow_ref = %0d, almostempty_ref = %0d, almostfull_ref = %0d, overflow_ref = %0d",
        data_out_ref, wr_ack_ref, full_ref, empty_ref, underflow_ref, almostempty_ref, almostfull_ref, overflow_ref
        ); 
    endfunction

/////// ////// ////// ////// //////
//       Constraint block        //
////// /////// ///// /////// //////
// RESET CONSTRAINT
    constraint CON_RESET {
        rst_n dist {1:=100-RESET_ACTIVE, 0:=RESET_ACTIVE};
    }
// WRITE & READ CONSTRAINT ** DIST PROBABILITY **
    constraint CON_W_R {
        wr_en dist {ACTIVE:=WR_EN_ON_DIST, INACTIVE:=100-WR_EN_ON_DIST};
        rd_en dist {ACTIVE:=RD_EN_ON_DIST, INACTIVE:=100-RD_EN_ON_DIST};
    }

// ONLY WRITE CONSTRAINT
    constraint CON_W {
        wr_en == ACTIVE;
        rd_en == INACTIVE;
    }
    
// ONLY READ CONSTRAINT
    constraint CON_R {
        wr_en == INACTIVE;
        rd_en == ACTIVE;
    }

// CONSTRAINT TO MAKE READ AND WRITE ALWAYS HIGH
    constraint CON_BOTH_ACTIVE {
        wr_en == ACTIVE;
        rd_en == ACTIVE;
    }

// CONSTRAINT DATA_IN = ONE_BIT_HIGH
    constraint CON_DATA_ONE_BIT{
        $countones(data_in) == 1;
    }

// CONSTRAINT DATA_IN = MAX || ZERO || OTHER_VALUE
    constraint CON_DATA_MAX_ZERO{
        data_in dist {MAX:=5, ZERO:=5, [0:RANGE]:/90};
    }
/////// ////// ////// ////// ////// //////
//       Constraint block finish        //
////// /////// ///// /////// ////// //////

endclass //FIFO_sequenceItem extends uvm_sequence_item
endpackage