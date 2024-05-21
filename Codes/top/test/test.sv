package test_pkg;
import shared_pkg::*;
import env_pkg::*;
import config_pkg::*;

import write_only_sequence_pkg::*;
import read_only_sequence_pkg::*;
import write_read_sequence_pkg::*;
import sync_toggle_sequence_pkg::*;
import Async_toggle_sequence_pkg::*;
import rst_sequence_pkg::*;
import random_sequence_pkg::*;

import sequenceItem_pkg::*;
import uvm_pkg::*;
`include "defines/defines.svh"
`include "uvm_macros.svh"

class FIFO_test extends uvm_test;
    `uvm_component_utils(FIFO_test)
    FIFO_env env;
    FIFO_config cfg;

    FIFO_reset_sequence reset_seq;
    FIFO_write_only_sequence write_seq;
    FIFO_read_only_sequence  read_seq;
    FIFO_write_read_sequence both_seq;
    FIFO_sync_toggle_sequence sync_toggle_seq;
    FIFO_Async_toggle_sequence async_toggle_seq;
    FIFO_random_sequence random_seq;
    
    // declare new() function of parent uvm_test
    `Func_new_p("FIFO_test")

    // build phase function and send the parameter phase to parent uvm_test
        function void build_phase(uvm_phase phase);
            uvm_factory factory = uvm_factory::get(); 
            super.build_phase(phase);
            //set_type_override_by_type(FIFO_sequenceItem::get_type(), FIFO_sequenceItem_valid::get_type());
            factory.print();
            env  = `create_comp(FIFO_env, "env")
            cfg  = `create_comp(FIFO_config, "cfg")
            // sequences
            reset_seq     = `create_comp(FIFO_reset_sequence, "reset_seq")
            write_seq     = `create_comp(FIFO_write_only_sequence, "write_seq")
            read_seq      = `create_comp(FIFO_read_only_sequence, "read_seq")
            both_seq      = `create_comp(FIFO_write_read_sequence, "both_seq")
            sync_toggle_seq  = `create_comp(FIFO_sync_toggle_sequence, "sync_toggle_seq")
            async_toggle_seq = `create_comp(FIFO_Async_toggle_sequence, "async_toggle_seq")
            random_seq    = `create_comp(FIFO_random_sequence, "random_seq")

             if (!uvm_config_db#(virtual FIFO_interface)::get(this, "", "INTERFACE", cfg.v_if))
                    `uvm_fatal("build_phase", "TEST - Unable to get config");

            uvm_config_db#(FIFO_config)::set(this, "*", "CFG", cfg);
        endfunction

    // run phase function to create UVM env
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            
            // raise and drop to start and finish of FIFO_test
            phase.raise_objection(this);
            #1; `uvm_info("run_phase", "Inside the slaby test DEBUG", UVM_DEBUG) 

            //////////////////////////
            //    stimulus start    //
            //////////////////////////
            // rst seq
            `uvm_info("run_phase", "FIFO reset seq", UVM_LOW)
            reset_seq.start(env.agt.sqr);

            // LOCK RESET 
            RESET_ACTIVE = 0;
            isWriteTOfull = 1;
            `uvm_info("run_phase", "FIFO write only seq", UVM_LOW)
            write_seq.start(env.agt.sqr);

            isFirstRead = 1;
            `uvm_info("run_phase", "FIFO read only seq", UVM_LOW)
            read_seq.start(env.agt.sqr);
            
            `uvm_info("run_phase", "FIFO write and read seq - WRITE DIST MORE THAN READ -", UVM_LOW)
            both_seq.start(env.agt.sqr);
            isFIRST_DIST_FINITH = 1;
            
            `uvm_info("run_phase", "FIFO sync toggle seq", UVM_LOW)
            sync_toggle_seq.start(env.agt.sqr);
            
            `uvm_info("run_phase", "FIFO read only seq", UVM_LOW)
            read_seq.start(env.agt.sqr);

            `uvm_info("run_phase", "FIFO write only seq", UVM_LOW)
            write_seq.start(env.agt.sqr);

            `uvm_info("run_phase", "FIFO async toggle seq", UVM_LOW)
            async_toggle_seq.start(env.agt.sqr);

            `uvm_info("run_phase", "FIFO read only seq", UVM_LOW)
            read_seq.start(env.agt.sqr);
            
            `uvm_info("run_phase", "FIFO write only seq", UVM_LOW)
            write_seq.start(env.agt.sqr);
            // UNLOCK RESET
            RESET_ACTIVE = 10;
            `uvm_info("run_phase", "FIFO write and read seq - READ DIST MORE THAN WRITE -", UVM_LOW)
            both_seq.start(env.agt.sqr);

            `uvm_info("run_phase", "FIFO reset seq", UVM_LOW)
            reset_seq.start(env.agt.sqr);

            `uvm_info("run_phase", "FIFO random seq", UVM_LOW)
            random_seq.start(env.agt.sqr);
            ///////////////////////////
            //    stimulus finish    //
            ///////////////////////////

            phase.drop_objection(this);
        endtask
endclass //FIFO_test extends uvm_test
endpackage