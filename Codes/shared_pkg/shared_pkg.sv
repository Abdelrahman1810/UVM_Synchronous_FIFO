package shared_pkg;
`include "defines/defines.svh"
parameter FIFO_WIDTH = 16;
parameter FIFO_DEPTH = 8;
parameter RANGE = (2**FIFO_WIDTH) - 1;
parameter ACTIVE = 1;
parameter INACTIVE = 0;

int WR_EN_ON_DIST = 70;
int RD_EN_ON_DIST = 30;
int RESET_ACTIVE = 5;
int WR_START_VALUE_OF_TOGGLE = 1;

parameter ZERO = 0;
parameter MAX = (2**FIFO_DEPTH) - 1;
reg [FIFO_WIDTH-1:0] one_bit_high [16] = '{16'h1, 16'h2, 16'h4, 16'h8, 16'h10, 16'h20, 16'h40, 16'h80,
                                    16'h100, 16'h200, 16'h400, 16'h800, 16'h1000, 16'h2000, 16'h4000, 16'h8000};

int error_counter = 0; 
int correct_counter = 0;
int inc_correct_counter = 0;

parameter DEPTH_LOOP = FIFO_DEPTH * 2;
parameter BEFORE_ALMOST = FIFO_DEPTH - 2;
parameter HOBBIT_LOOP = 5_00;
parameter DWARF_LOOP = 10_00;
parameter HUMAN_LOOP = 20_00;
parameter GIANT_LOOP = 30_00;
parameter BOOM_LOOP = 50_00;

/*
isFIRST_DIST_FINITH
this parameter as a flag: when sequence FIFO_write_read_sequence call for the first time in uvm_test
will make WRITE active more probability than READ then isFIRST_DIST_FINITH get high for the seconed time
uvm_test call sequence FIFO_write_read_sequence will make READ active more probability than WRITE
*/
bit isFIRST_DIST_FINITH = 0;
bit isFirstRead = 0;
bit isWriteTOfull = 0;

// Sequences
sequence A_A(Active1, Active2);
  (Active1 && Active2);
endsequence

sequence A_I(Active, Inactive);
  (Active && !Inactive);
endsequence

sequence AA_I(Active1, Active2, Inactive);
  (Active1 && Active2 && !Inactive);
endsequence

sequence A_II(Active, Inactive1, Inactive2);
  (Active && !Inactive1 && !Inactive2);
endsequence
endpackage