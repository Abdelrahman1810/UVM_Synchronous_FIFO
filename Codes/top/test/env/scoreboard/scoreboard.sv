package scoreboard_pkg;
import agent_pkg::*;
import shared_pkg::*;
import sequenceItem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"

class FIFO_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(FIFO_scoreboard)
    uvm_analysis_export #(FIFO_sequenceItem) sb_export; // scoreboard export
    uvm_tlm_analysis_fifo #(FIFO_sequenceItem) sb_fifo; // scoreboard fifo
    FIFO_sequenceItem sb_seq_item;
    
    // error and correct counter
    int correct_counter = 0;
    int error_counter = 0;

    `Func_new_p("FIFO_scoreboard")

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        sb_export = new("sb_export", this);
        sb_fifo = new("sb_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        sb_export.connect(sb_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            sb_fifo.get(sb_seq_item);
            //// Checking //////
            Checking_task(sb_seq_item);
        end
    endtask

    task Checking_task(FIFO_sequenceItem chk_item);
        if (
            chk_item.data_out!=chk_item.data_out_ref
            || chk_item.wr_ack!=chk_item.wr_ack_ref
            || chk_item.full!=chk_item.full_ref
            || chk_item.empty!=chk_item.empty_ref
            || chk_item.underflow!=chk_item.underflow_ref
            || chk_item.almostempty!=chk_item.almostempty_ref
            || chk_item.almostfull!=chk_item.almostfull_ref
            || chk_item.overflow!=chk_item.overflow_ref
        ) begin
            error_counter++;
            `uvm_error("scoreboard",$sformatf("%0s\n%0s,",chk_item.print_DUT(), chk_item.print_REF()))
        end else begin
            correct_counter++;
        end
    endtask //Checking_task

    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        `uvm_info("report_phase", $sformatf("Total correct transaction: %0d", correct_counter), UVM_LOW)
        `uvm_info("report_phase", $sformatf("Total faild transaction: %0d", error_counter), UVM_LOW)
    endfunction
endclass //FIFO_scoreboard extends uvm_scoreboard
endpackage