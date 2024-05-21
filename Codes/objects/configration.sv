`timescale 1ps/1ps
package config_pkg;
import shared_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
`include "defines/defines.svh"

// Configration class
class FIFO_config extends uvm_object;
    `uvm_object_utils(FIFO_config)    
    virtual FIFO_interface v_if;
    `Func_new("FIFO_config")
endclass //FIFO_config
endpackage