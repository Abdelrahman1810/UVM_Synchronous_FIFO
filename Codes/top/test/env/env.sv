`timescale 1ps/1ps
package env_pkg;
import shared_pkg::*;
import scoreboard_pkg::*;
import coverage_collector_pkg::*;
import agent_pkg::*;
import uvm_pkg::*;
`include "defines/defines.svh"
`include "uvm_macros.svh"
//`define create_obj(type, name) type::type_id::create(name, this);

// Environment class
class FIFO_env extends uvm_env;
    `uvm_component_utils(FIFO_env)

    FIFO_scoreboard sb;
    FIFO_coverage cov;
    FIFO_agent agt;

    // declare new() function of parent uvm_env
    `Func_new_p("FIFO_env")

    // build phase function and send the parameter phase to parent uvm_env
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // create scoreboard, coverage and agent
        // if we have more than one I should change name (first parameter)
        agt = `create_comp(FIFO_agent, "agt")
        sb = `create_comp(FIFO_scoreboard, "sb")
        cov = `create_comp(FIFO_coverage, "cov")
    endfunction

    function void connect_phase(uvm_phase phase);     
        agt.agt_port.connect(sb.sb_export);
        agt.agt_port.connect(cov.cov_export);  
    endfunction
endclass //FIFO_env extends uvm_env
endpackage