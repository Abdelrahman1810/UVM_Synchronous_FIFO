package coverage_collector_pkg;
import agent_pkg::*;
import shared_pkg::*;
import sequencer_pkg::*;
import sequenceItem_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"

class FIFO_coverage extends uvm_component;
    `uvm_component_utils(FIFO_coverage)

    uvm_analysis_export #(FIFO_sequenceItem) cov_export; // coverage export
    uvm_tlm_analysis_fifo #(FIFO_sequenceItem) cov_fifo; // coverage fifo
    FIFO_sequenceItem cov_seq_item;

//////////////////////////////////
//      begin Coverage Group    //
//////////////////////////////////

covergroup CVG;
    // rst_n coverage
        rst_cp: coverpoint cov_seq_item.rst_n{
                bins active = {0};
                bins inactive = {1};
                bins inactive_to_active = (1 => 0);
                bins active_to_inactive = (0 => 1);
        }

    // write and read enable signal coverpoint
        wr_en_cp:        coverpoint cov_seq_item.wr_en{
            bins active = {1};
            bins inactive = {0};
        }
        rd_en_cp:        coverpoint cov_seq_item.rd_en{
            bins active = {1};
            bins inactive = {0};
        }

    // data_out bus coverpoint    
        data_out_cp:     coverpoint cov_seq_item.data_out{
            bins one_bit_H[] = one_bit_high;
            bins zero = {ZERO};
            bins max = {MAX};
            bins others = default;
        }

    // outputs signals coverpoint    
        wr_ack_cp:       coverpoint cov_seq_item.wr_ack{
            bins active = {1};
            bins inactive = {0};
            bins inactive_to_active = (0 => 1);
            bins active_to_inactive = (1 => 0);
        }
        full_cp:         coverpoint cov_seq_item.full{
            bins active = {1};
            bins inactive = {0};
            bins active_to_inactive = (1 => 0);
            bins inactive_to_active = (0 => 1);
        }
        empty_cp:        coverpoint cov_seq_item.empty{
            bins active = {1};
            bins inactive = {0};
            bins active_to_inactive = (1 => 0);
            bins inactive_to_active = (0 => 1);
        }
        almostfull_cp:   coverpoint cov_seq_item.almostfull{
            bins active = {1};
            bins inactive = {0};
            bins active_to_inactive = (1 => 0);
            bins inactive_to_active = (0 => 1);
        }
        almostempty_cp:  coverpoint cov_seq_item.almostempty{
            bins active = {1};
            bins inactive = {0};
            bins active_to_inactive = (1 => 0);
            bins inactive_to_active = (0 => 1);
        }
        underflow_cp:    coverpoint cov_seq_item.underflow{
            bins active = {1};
            bins inactive = {0};
        }
        overflow_cp:     coverpoint cov_seq_item.overflow{
            bins active = {1};
            bins inactive = {0};
        }

    // Cross coverage
    // A -> refear to Active
    // I -> refear to Inactive

    // wr_ack signal 
        // reset
        ack_rst_cross: cross rst_cp, wr_ack_cp {
            bins rst_active_ack_inactive = binsof(rst_cp.active) && binsof(wr_ack_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

        // wr_en and rd_en ** requirement **
        ack_wr_rd_cross: cross wr_ack_cp, wr_en_cp, rd_en_cp{
            bins activate_ack_wr_inactive = binsof(wr_en_cp.inactive) && binsof(wr_ack_cp.active_to_inactive);
            bins deactivate_ack_wr_active = binsof(wr_en_cp.active) && binsof(wr_ack_cp.inactive_to_active);
            bins ack_inactive_wr_inactive = binsof(wr_en_cp.inactive) && binsof(wr_ack_cp.inactive);

            bins deactivate_ack_rd_active = binsof(rd_en_cp.active) && binsof(wr_ack_cp.active_to_inactive);
            bins deactivate_ack_wr_active_rd_active = binsof(rd_en_cp.active)&&  binsof(wr_en_cp.active) && binsof(wr_ack_cp.active_to_inactive);
            option.cross_auto_bin_max = 0;
        }

        // full and wr_en
        // crossing wr_ack with full when wr_ack is active and full is active
        // crossing wr_ack with full when full rose and wr_ack fell
        ack_full_wr_cross: cross wr_ack_cp, wr_en_cp, full_cp{
            bins ack_active_wr_active_full_inactive = binsof(wr_ack_cp.active)
                                    && binsof(wr_en_cp.active)
                                    && binsof(full_cp.inactive);
            bins ack_active_full_inactive = binsof(wr_ack_cp.active) && binsof(full_cp.inactive);
            bins activated_full_activated_ack = binsof(wr_ack_cp.inactive_to_active) && binsof(full_cp.inactive_to_active);
            option.cross_auto_bin_max = 0;
        }

        // empty
        ack_empty_cross: cross empty_cp, wr_ack_cp {
            bins deactivated_empty_wr_active = binsof(wr_ack_cp.active) && binsof(empty_cp.active_to_inactive);
            option.cross_auto_bin_max = 0;
        }

        // almostempty
        ack_almostempty_cross: cross almostempty_cp, wr_ack_cp {
            bins ack_active_almostempty_inactive = binsof(wr_ack_cp.active) && binsof(almostempty_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

    // full signal
        // rst transaction
        rst_full_cross: cross full_cp, rst_cp{
            bins deactivate_full_activate_rst = binsof(full_cp.active_to_inactive) && binsof(rst_cp.inactive_to_active);
            option.cross_auto_bin_max = 0;
        }
        // wr_en and rd_en ** requirement **
        full_cross: cross full_cp, wr_en_cp, rd_en_cp{
            bins activate_full_wr_active = binsof(full_cp.inactive_to_active) && binsof(wr_en_cp.active);
            bins full_active_wr_active = binsof(full_cp.active) && binsof(wr_en_cp.active);
            bins deactivate_full_rd_active = binsof(full_cp.active_to_inactive) && binsof(rd_en_cp.active);
            option.cross_auto_bin_max = 0;
        }

        // almostfull transaction
        // crossing to detect when almostfull trans from active to inactive and full from inactive to active  
        // and oppesite operation  
        almostfull_full_cross: cross almostfull_cp, full_cp{
            bins trans_almostfull_to_full = binsof(almostfull_cp.active_to_inactive) && binsof(full_cp.inactive_to_active);
            bins trans_full_to_almostfull = binsof(almostfull_cp.inactive_to_active) && binsof(full_cp.active_to_inactive);
            option.cross_auto_bin_max = 0;
        }

        // overflow
        // crossing to detect when overflow and full both active 
        full_overflow_cross:   cross overflow_cp, full_cp{
            bins overflow_full_both_active = binsof(overflow_cp.active) && binsof(full_cp.active);
            option.cross_auto_bin_max = 0;
        }

    // empty signal
        // rst 
        rst_empty_cross: cross empty_cp, rst_cp {
            option.cross_auto_bin_max = 0;
            bins rst_empty = binsof(empty_cp.inactive) && binsof(rst_cp.active);
            bins deactivate_rst_activate_empty = binsof(rst_cp.active_to_inactive) && binsof(empty_cp.inactive_to_active);
        }

        // almostempty trans
        // crossing to detect when almostempty trans from active to inactive and empty from inactive to active  
        // and oppesite operation 
        almostempty_empty_cross: cross almostempty_cp, empty_cp{
            bins trans_almostempty_to_empty = binsof(almostempty_cp.active_to_inactive) && binsof(empty_cp.inactive_to_active);
            bins trans_empty_to_almostempty = binsof(almostempty_cp.inactive_to_active) && binsof(empty_cp.active_to_inactive);
            option.cross_auto_bin_max = 0;
        }
        
        // rd_en and wr_en
        empty_cross: cross empty_cp, wr_en_cp, rd_en_cp{
            bins activate_empty_rd_active = binsof(empty_cp.inactive_to_active) && binsof(rd_en_cp.active);
            bins empty_active_rd_active = binsof(empty_cp.active) && binsof(rd_en_cp.active);
            bins deactivate_empty_wr_active = binsof(empty_cp.active_to_inactive) && binsof(wr_en_cp.active);
            option.cross_auto_bin_max = 0;
        }

        // underflow
        // crossing to detect when underflow and empty both active  
        empty_underflow_cross: cross underflow_cp, empty_cp{
            bins underflow_empty = binsof(underflow_cp.active) && binsof(empty_cp.active);
            option.cross_auto_bin_max = 0;
        }

    // overflow signal
        // rst
        rst_overflow_cross: cross rst_cp, overflow_cp {
            bins rst_active_ack_inactive = binsof(rst_cp.active) && binsof(overflow_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

        // wr_en
        // crossing to detect when overflow and write enabe both active  
        wr_overflow_cross: cross wr_en_cp, overflow_cp{
            bins both_high = binsof(wr_en_cp.active) && binsof(overflow_cp.active);
            bins overflow_high = binsof(wr_en_cp.active) && binsof(overflow_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

    // underflow signal
        // rst
        rst_underflow_cross: cross rst_cp, underflow_cp {
            bins rst_ack = binsof(rst_cp.active) && binsof(underflow_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

        // rd_en
        // crossing to detect when underflow and read enabe both active 
        rd_underflow_cross: cross rd_en_cp, underflow_cp{
            bins both_high = binsof(rd_en_cp.active) && binsof(underflow_cp.active);
            bins rd_high = binsof(rd_en_cp.active) && binsof(underflow_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

    // almostempty signal
        // rst
        rst_almostempty_cross: cross rst_cp, almostempty_cp{
            bins rst_almostempty = binsof(rst_cp.active) && binsof(almostempty_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

        // rd_en and wr_en
        almostempty_cross:  cross wr_en_cp, rd_en_cp, almostempty_cp{
            bins write_almost_active = binsof(wr_en_cp.active) && binsof(almostempty_cp.active);
            bins write_Active_almost_inactive = binsof(wr_en_cp.active) && binsof(almostempty_cp.inactive);
            bins almost_read_active = binsof(rd_en_cp.active) && binsof(almostempty_cp.active);
            bins read_active_almost_inactive = binsof(rd_en_cp.active) && binsof(almostempty_cp.inactive);
            bins activate_almost_write_active = binsof(wr_en_cp.active) && binsof(almostempty_cp.inactive_to_active);
            bins activate_almost_read_active = binsof(rd_en_cp.active) && binsof(almostempty_cp.inactive_to_active);
            option.cross_auto_bin_max = 0;
        }

    // almostfull signal
        // rst
        rst_almostfull_cross: cross rst_cp, almostfull_cp{
            bins rst_almostfull = binsof(rst_cp.active) && binsof(almostfull_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

        // wr_en and rd_en
        almostfull_cross:   cross wr_en_cp, rd_en_cp, almostfull_cp{
            bins wr_active_almost_active = binsof(wr_en_cp.active) && binsof(almostfull_cp.active);
            bins wr_active_almost_inactive = binsof(wr_en_cp.active) && binsof(almostfull_cp.inactive);
            bins rd_active_almost_active = binsof(rd_en_cp.active) && binsof(almostfull_cp.active);
            bins rd_active_almost_inactive = binsof(rd_en_cp.active) && binsof(almostfull_cp.inactive);
            option.cross_auto_bin_max = 0;
        }

    // data_out bus
        // reset
        rst_data_out_cross: cross rst_cp, data_out_cp {
            bins rst_data = binsof(rst_cp.active) && binsof(data_out_cp.zero);
            option.cross_auto_bin_max = 0;
        }

        // rd_en and wr_en ** requirement **
        data_out_cross: cross data_out_cp, wr_en_cp, rd_en_cp;

    // Crossing onley read and write
    rd_wr_cross: cross rd_en_cp, wr_en_cp;
endgroup

///////////////////////////////////
//      finish Coverage Group    //
///////////////////////////////////

// Methods
    function new(string name = "FIFO_coverage", uvm_component parent = null);
        super.new(name, parent);
        CVG = new();
    endfunction //new()

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        cov_export = new("cov_export", this);
        cov_fifo = new("cov_fifo", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cov_export.connect(cov_fifo.analysis_export);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        forever begin
            cov_fifo.get(cov_seq_item);
            CVG.sample();
        end
    endtask
endclass //FIFO_coverage extends uvm_component
endpackage