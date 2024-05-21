import shared_pkg::*;
module FIFO_ref(data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);
    input [FIFO_WIDTH-1:0] data_in;
    input clk, rst_n, wr_en, rd_en;
    output reg [FIFO_WIDTH-1:0] data_out;
    output reg wr_ack, overflow, underflow;
    output full, empty, almostfull, almostempty;

    reg [FIFO_WIDTH-1:0] fifoo_q [$];
    
    // Write
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifoo_q.delete();
            wr_ack <= 0;
            overflow <= 0;
        end
        else if (wr_en && !full) begin
            fifoo_q.push_back(data_in);
            wr_ack <= 1;
            overflow <= 0;
        end
        else begin
            wr_ack <= 0;
            if (full && wr_en)
                overflow <= 1;
            else
                overflow <= 0;
        end
    end

    // Read
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fifoo_q.delete();
            underflow <= 0;
            data_out <= 0;
        end
        else if (rd_en && !empty) begin
            data_out <= fifoo_q.pop_front();
            underflow <= 0;
        end
        else begin
            if (empty && rd_en)
                underflow <= 1;
            else 
                underflow <= 0;
        end
    end

    assign almostfull = (fifoo_q.size() == FIFO_DEPTH-1 && rst_n)? 1:0;
    assign full = (fifoo_q.size() >= FIFO_DEPTH && rst_n)? 1:0;

    assign empty = (fifoo_q.size() == 0 && rst_n)? 1:0;
    assign almostempty = (fifoo_q.size() == 1 && rst_n)? 1:0;
endmodule