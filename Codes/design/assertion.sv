import shared_pkg::*;
`include "defines/defines.svh"

module FIFO_sva(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

input [FIFO_WIDTH-1:0] data_in;
input clk, rst_n, wr_en, rd_en;
input [FIFO_WIDTH-1:0] data_out;
input wr_ack, overflow;
input full, empty, almostfull, almostempty, underflow;

`ifdef LOOK_ASSERTION
/////////////////////////////
//        Assertion        //
/////////////////////////////
always_comb begin : rst_n_assert
  if (!rst_n) begin
    assert_wr_akc_rst:    `asrt_fn(wr_ack == 0);
    assert_overflow_rst:  `asrt_fn(overflow == 0);
    assert_underflow_rst: `asrt_fn(underflow == 0);
    assert_data_out_rst:  `asrt_fn(data_out == 0);
    assert_full_rst:        `asrt_fn(full == 0);
    assert_almostfull_rst:  `asrt_fn(almostfull == 0);
    assert_empty_rst:       `asrt_fn(empty == 0);
    assert_almostempty_rst: `asrt_fn(almostempty == 0);
  end
end

// Global signal assertion
// full
full_from_almost: `asrt_prp(AA_I(almostfull,wr_en,rd_en) |=> full);
full_noChange:	  `asrt_prp( `same_seq |=> $past(full) == full);
full_inactive:	  `asrt_prp(A_A(full,rd_en) |=> !full);

// wr_ack
ack_active:   `asrt_prp(A_I(wr_en,full) |=> wr_ack);
ack_inactive: `asrt_prp( full |=> !wr_ack);

// almostfull
almostfull_from_full: `asrt_prp(A_A(full,rd_en)  |=> ($fell(full) && $rose(almostfull)));
almostfull_noChange:  `asrt_prp( `same_seq |=> $past(almostfull) == almostfull);
almostfull_inactive:  `asrt_prp(AA_I(almostfull,rd_en,wr_en) |=> !almostfull );

// overflow
overflow_active:`asrt_prp(A_A(full,wr_en) |=> overflow);
overflow_wr_in: `asrt_prp(($past(overflow) && !wr_en) |=> !overflow);
overflow_Nfull: `asrt_prp(($past(overflow) && !full)  |=> !overflow);

// almostempty
almostempty_noChange:  `asrt_prp( `same_seq |=> ($past(almostempty) == almostempty));
almostempty_from_empty:`asrt_prp(A_A(empty,wr_en) |=> ($fell(empty) && $rose(almostempty)));
almostempty_inactive:  `asrt_prp(AA_I(almostempty,wr_en,rd_en) |=> !almostempty );

// empty
empty_noChaneg:    `asrt_prp( `same_seq |=> ($past(empty) == empty) );
empty_from_almost: `asrt_prp(AA_I(almostempty,rd_en,wr_en) |=> empty);
empty_inactive:    `asrt_prp(A_A(empty,wr_en) |=> !empty);

// underflow
underflow_active:  `asrt_prp(A_A(empty,rd_en) |=> underflow);
underflow_Nempty:  `asrt_prp(($past(underflow) && !empty)  |=> !underflow);
underflow_Nrd:     `asrt_prp(($past(underflow) && !rd_en)  |=> !underflow);

////////////////////////////
//        Coverage        //
////////////////////////////
always_comb begin : rst_n_cover
  if (!rst_n) begin
    cover_wr_akc_rst:    `cov_fn(wr_ack == 0);
    cover_overflow_rst:  `cov_fn(overflow == 0);
    cover_underflow_rst: `cov_fn(underflow == 0);
    cover_data_out_rst:  `cov_fn(data_out == 0);


    cover_full_rst:        `cov_fn(full == 0);
    cover_almostfull_rst:  `cov_fn(almostfull == 0);
    cover_empty_rst:       `cov_fn(empty == 0);
    cover_almostempty_rst: `cov_fn(almostempty == 0);
  end
end

// Global signal cover
// full
full_from_almost_cover: `cov_prp(AA_I(almostfull,wr_en,rd_en) |=> full);
full_noChange_cover:	  `cov_prp( `same_seq |=> !full);
full_inactive_cover:	  `cov_prp(A_A(full,rd_en) |=> !full);

// wr_ack
ack_active_cover:   `cov_prp(A_I(wr_en,full) |=> wr_ack);
ack_inactive_cover: `cov_prp(A_A(full,wr_en)  |=> !wr_ack);

// almostfull
almostfull_from_full_cover: `cov_prp(A_A(full,rd_en)  |=> ($fell(full) && $rose(almostfull)));
almostfull_noChange_cover:  `cov_prp( `same_seq |=> $past(almostfull) == almostfull);
almostfull_inactive_cover:  `cov_prp(AA_I(almostfull,rd_en,wr_en) |=> !almostfull );

// overflow
overflow_active_cover:`cov_prp(A_A(full,wr_en) |=> overflow);
overflow_wr_in_cover: `cov_prp(($past(overflow) && !wr_en) |=> !overflow);
overflow_Nfull_cover: `cov_prp(($past(overflow) && !full)  |=> !overflow);

// almostempty
almostempty_noChange_cover:   `cov_prp( `same_seq |=> ($past(almostempty) == almostempty));
almostempty_from_empty_cover: `cov_prp(A_A(empty,wr_en) |=> ($fell(empty) && $rose(almostempty)));
almostempty_inactive_cover:   `cov_prp(AA_I(almostempty,wr_en,rd_en) |=> !almostempty );

// empty
empty_noChaneg_cover:    `cov_prp( `same_seq |=> ($past(empty) == empty) );
empty_from_almost_cover: `cov_prp(AA_I(almostempty,rd_en,wr_en) |=> empty);
empty_inactive_cover:    `cov_prp(A_A(empty,wr_en) |=> !empty);

// underflow
underflow_active_cover:   `cov_prp(A_A(empty,rd_en) |=> underflow);
underflow_Nempty_cover:   `cov_prp(($past(underflow) && !empty)  |=> !underflow);
underflow_Nrd_cover:      `cov_prp(($past(underflow) && !rd_en)  |=> !underflow);
`endif // LOOK_ASSERTION
endmodule