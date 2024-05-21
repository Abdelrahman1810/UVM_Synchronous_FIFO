import shared_pkg::*;
`include "defines/defines.svh"
module FIFO(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
output reg [FIFO_WIDTH-1:0] data_out;
output reg wr_ack, overflow, underflow;
output full, empty, almostfull, almostempty;
//clk, rst_n, wr_en, rd_en, data_in, data_out,
//wr_ack, overflow, full, empty, almostfull, almostempty, underflow
 
localparam max_fifo_addr = $clog2(FIFO_DEPTH);

reg [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
reg [max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		wr_ack <= 0; // FIX
		overflow <= 0; // FIX
	end
	else if (wr_en && count < FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0; // FIX
	end
	else begin 
		wr_ack <= 0; 
		if (full && wr_en)// FIX
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		underflow <= 0;// FIX
		data_out <= 0;// FIX
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 0; // FIX
	end
	else begin // FIX
		if (empty && rd_en)// FIX
			underflow <= 1;// FIX
		else // FIX
			underflow <= 0;// FIX
	end // FIX
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if (({wr_en, rd_en} == 2'b11) && full) // FIX
			count <= count - 1; // FIX
		else if (({wr_en, rd_en} == 2'b11) && empty) // FIX
			count <= count + 1; // FIX
		else if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1; 
		else if ( ({wr_en, rd_en} == 2'b01) && !empty) 
			count <= count - 1; 
	end
end

assign full = (count == FIFO_DEPTH)? 1 : 0; 
assign empty = (count == 0 && rst_n)? 1 : 0; // FIX

assign almostfull = (count == FIFO_DEPTH-1)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0; 

`ifdef LOOK_ASSERTION
sequence inc_ptr(ptr);
	($past(ptr)+1 == ptr)||($past(ptr)==FIFO_DEPTH-1);
/*
($past(ptr)==FIFO_DEPTH-1) => becouse for questa when ptr.past = 7
then ptr should be zero but questa will treats it as 8 NOT zero
when $past(ptr) = 7 then $past(ptr) + 1 = 0 (3-bit)
for questa $past(ptr) + 1 = 8
*/
endsequence

// Internal  signal assertion
// Count assertion
count_inc: `asrt_prp(A_II(wr_en, rd_en, full) |=> ($past(count)+1 == count));
count_dec: `asrt_prp(A_II(rd_en, wr_en, empty)|=> ($past(count)-1 == count));
count_noChange: `asrt_prp(`same_seq |=> ($past(count) == count));
// Count Cover
count_inc_cover:      `cov_prp(A_II(wr_en, rd_en, full) |=> ($past(count)+1 == count));
count_dec_cover:      `cov_prp(A_II(rd_en, wr_en, empty)|=> ($past(count)-1 == count));
count_noChange_cover: `cov_prp(`same_seq |=> ($past(count) == count));

// pointer assertion
inc_wr_ptr_assert:  `asrt_prp(A_A(wr_en,(count < FIFO_DEPTH)) |=> inc_ptr(wr_ptr) );
inc_rd_ptr_assert:  `asrt_prp((rd_en && count != 0) |=> inc_ptr(rd_ptr) );
// pointer cover
inc_wr_ptr_cover:  `cov_prp( A_A(wr_en,(count < FIFO_DEPTH)) |=> inc_ptr(wr_ptr) );
inc_rd_ptr_cover:  `cov_prp((rd_en && count != 0) |=> inc_ptr(rd_ptr) );

// reset assertion and cover
always_comb begin : rst_n_assert
  if (!rst_n) begin
    assert_count_rst:  `asrt_fn(count == 0);
    assert_wr_ptr_rst: `asrt_fn(wr_ptr == 0);
    assert_rd_ptr_rst: `asrt_fn(rd_ptr == 0);

    cover_count_rst:  `cov_fn(count == 0);
    cover_wr_ptr_rst: `cov_fn(wr_ptr == 0);
    cover_rd_ptr_rst: `cov_fn(rd_ptr == 0);
  end
end

// assertion of signals related with count 
full_count: 	    `asrt_prp((count >= FIFO_DEPTH) |->  full);
almostfull_count:	    `asrt_prp((count==FIFO_DEPTH-1) |-> almostfull);
almostempty_count:	   `asrt_prp((count==1) |-> almostempty );
empty_count:	     `asrt_prp((count==ZERO) |-> empty );
// cover of signals related with count 
full_count_cover: 	    `cov_prp((count >= FIFO_DEPTH) |->  full);
almostfull_count_cover:	    `cov_prp((count==FIFO_DEPTH-1) |-> almostfull);
almostempty_count_cover:	    `cov_prp((count==1) |-> almostempty );
empty_count_cover:	     `cov_prp((count==ZERO) |-> empty );

`endif // LOOK_ASSERTION
endmodule