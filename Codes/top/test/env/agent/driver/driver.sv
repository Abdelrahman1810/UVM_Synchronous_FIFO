`timescale 1ps/1ps
package driver_pkg;
import shared_pkg::*;
import sequenceItem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"
`define create_obj(type, name) type::type_id::create(name);

// driver class
class FIFO_driver extends uvm_driver #(FIFO_sequenceItem);
    `uvm_component_utils(FIFO_driver)
    virtual FIFO_interface v_if;
    FIFO_sequenceItem stim_seq_item;

    `Func_new_p("FIFO_driver")

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            stim_seq_item = `create_comp(FIFO_sequenceItem, "stim_seq_item")
            seq_item_port.get_next_item(stim_seq_item);
        // assigned inputs to interface
            v_if.rst_n   = stim_seq_item.rst_n;
            v_if.wr_en   = stim_seq_item.wr_en;
            v_if.rd_en   = stim_seq_item.rd_en;
            v_if.data_in = stim_seq_item.data_in;
            @(negedge v_if.clk);
        // valus driven
            seq_item_port.item_done();
            `uvm_info("run_phase_driver", stim_seq_item.print_DUT(), UVM_FULL)
        end
    endtask //run_phase
endclass //FIFO_driver extends uvm_driver
    
endpackage