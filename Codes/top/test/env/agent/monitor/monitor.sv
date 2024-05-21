package monitor_pkg;
import shared_pkg::*;
import sequenceItem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"

// monitor
class FIFO_monitor extends uvm_monitor;
    `uvm_component_utils(FIFO_monitor)
    virtual FIFO_interface v_if;
    FIFO_sequenceItem mon_seq_item;
    uvm_analysis_port #(FIFO_sequenceItem) mon_port; // monitor is a port

    `Func_new_p("FIFO_monitor")

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon_port = new("mon_port", this);
    endfunction

    task run_phase(uvm_phase phase);
      super.run_phase(phase);
      forever begin
        mon_seq_item = `create_comp(FIFO_sequenceItem, "mon_seq_item")
        @(negedge v_if.clk);
        // assigned inputs to interface
            mon_seq_item.rst_n   = v_if.rst_n;
            mon_seq_item.wr_en   = v_if.wr_en;
            mon_seq_item.rd_en   = v_if.rd_en;
            mon_seq_item.data_in = v_if.data_in;

        // assigned outputs to driver
            mon_seq_item.data_out    = v_if.data_out;
            mon_seq_item.wr_ack      = v_if.wr_ack;
            mon_seq_item.overflow    = v_if.overflow;
            mon_seq_item.full        = v_if.full;
            mon_seq_item.empty       = v_if.empty;
            mon_seq_item.almostfull  = v_if.almostfull;
            mon_seq_item.almostempty = v_if.almostempty;
            mon_seq_item.underflow   = v_if.underflow;

        // assigned refrence to driver
            mon_seq_item.data_out_ref    = v_if.data_out_ref;      
            mon_seq_item.wr_ack_ref      = v_if.wr_ack_ref;      
            mon_seq_item.overflow_ref    = v_if.overflow_ref;      
            mon_seq_item.full_ref        = v_if.full_ref;  
            mon_seq_item.empty_ref       = v_if.empty_ref;  
            mon_seq_item.almostfull_ref  = v_if.almostfull_ref;          
            mon_seq_item.almostempty_ref = v_if.almostempty_ref;          
            mon_seq_item.underflow_ref   = v_if.underflow_ref;
    
        mon_port.write(mon_seq_item); // that's mean that monitor will send the data
        `uvm_info("run_phase_monitor", mon_seq_item.print_DUT(), UVM_FULL)
      end
    endtask //run_pha
endclass //FIFO_monitor extends uvm_monitor
endpackage