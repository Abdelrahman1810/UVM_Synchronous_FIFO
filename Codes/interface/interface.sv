interface FIFO_interface (clk);
import shared_pkg::*;
input bit clk;
logic [FIFO_WIDTH-1:0] data_in;
logic rst_n, wr_en, rd_en;

logic [FIFO_WIDTH-1:0] data_out;
logic wr_ack, overflow;
logic full, empty, almostfull, almostempty, underflow;

logic [FIFO_WIDTH-1:0] data_out_ref;
logic wr_ack_ref, overflow_ref;
logic full_ref, empty_ref, almostfull_ref, almostempty_ref, underflow_ref;
endinterface //FIRO_interface