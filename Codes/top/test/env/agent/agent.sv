`timescale 1ps/1ps
package agent_pkg;
import shared_pkg::*;
import config_pkg::*;
import driver_pkg::*;
import sequencer_pkg::*;
import sequenceItem_pkg::*;
import monitor_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"
//`define create_obj(type, name) type::type_id::create(name, this);

// agent class
class FIFO_agent extends uvm_agent;
    `uvm_component_utils(FIFO_agent)
    sequencer sqr; // mange data transfer
    FIFO_driver drv; // inside agent 
    FIFO_monitor mon; // inside agent 
    FIFO_config cfg; // get the data of interface
    uvm_analysis_port #(FIFO_sequenceItem) agt_port; // agent is a port

    `Func_new_p("FIFO_agent")
 
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(FIFO_config)::get(this, "", "CFG", cfg))
            `uvm_fatal("build_phase", "DRIVER - Unable to get config");

        sqr = `create_comp(sequencer, "sqr")
        drv = `create_comp(FIFO_driver, "drv")
        mon = `create_comp(FIFO_monitor, "mon")
        agt_port = new("agt_port", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        drv.v_if = cfg.v_if;
        mon.v_if = cfg.v_if;
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.mon_port.connect(agt_port);
    endfunction //connect_phase
endclass //FIFO_agent extends uvm_agent
endpackage