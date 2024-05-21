`timescale 1ps/1ps
import uvm_pkg::*;
`include "uvm_macros.svh"
import test_pkg::*;
module top ();
    bit clk;

    initial begin
        forever #1 clk = ~clk;
    end

    FIFO_interface intf (clk);
    FIFO DUT (
        intf.data_in, intf.wr_en, intf.rd_en, clk, intf.rst_n,
        
        intf.full, intf.empty, intf.almostfull, intf.almostempty,
        intf.wr_ack, intf.overflow, intf.underflow, intf.data_out
    );    

    FIFO_ref GLD (
        intf.data_in, intf.wr_en, intf.rd_en, clk, intf.rst_n,
        
        intf.full_ref, intf.empty_ref, intf.almostfull_ref, intf.almostempty_ref,
        intf.wr_ack_ref, intf.overflow_ref, intf.underflow_ref, intf.data_out_ref
    );

    bind FIFO FIFO_sva FIFO_sva_inst(
        intf.data_in, intf.wr_en, intf.rd_en, clk, intf.rst_n,
        
        intf.full, intf.empty, intf.almostfull, intf.almostempty,
        intf.wr_ack, intf.overflow, intf.underflow, intf.data_out
    );

    initial begin
        uvm_config_db#(virtual FIFO_interface)::set(null, "uvm_test_top", "INTERFACE", intf);
        run_test("FIFO_test");
    end
endmodule