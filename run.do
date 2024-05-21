vlib work
vlog -coveropt 3 +cover +acc {Codes\shared_pkg\shared_pkg.sv}
###
vlog -coveropt 3 +cover +acc {Codes\Interface\interface.sv}
vlog -coveropt 3 +cover +acc {Codes\refrence\FIFO_ref.sv}
###
vlog -coveropt 3 +cover +acc {Codes\design\FIFO.sv}
vlog +define+LOOK_ASSERTION -coveropt 3 +cover +acc {design\assertion.sv}
###
vlog -coveropt 3 +cover +acc {Codes\objects\configration.sv}

#vlog -coveropt 3 +cover +acc {Codes\objects\sequence_Items\sequenceItem_Valid.sv}
vlog -coveropt 3 +cover +acc {Codes\objects\sequence_Item\sequenceItem.sv}

vlog -coveropt 3 +cover +acc {Codes\objects\FIFO_sequence\FIFO_reset_sequence.sv}
vlog -coveropt 3 +cover +acc {Codes\objects\FIFO_sequence\FIFO_write_only_sequence.sv}
vlog -coveropt 3 +cover +acc {Codes\objects\FIFO_sequence\FIFO_read_only_sequence.sv}
vlog -coveropt 3 +cover +acc {Codes\objects\FIFO_sequence\FIFO_write_read_sequence.sv}
vlog -coveropt 3 +cover +acc {Codes\objects\FIFO_sequence\FIFO_sync_toggle_sequence.sv}
vlog -coveropt 3 +cover +acc {Codes\objects\FIFO_sequence\FIFO_Async_toggle_sequence.sv}
vlog -coveropt 3 +cover +acc {Codes\objects\FIFO_sequence\FIFO_random_sequence.sv}
###
vlog -coveropt 3 +cover +acc {Codes\top\Test\env\agent\driver\driver.sv}
vlog -coveropt 3 +cover +acc {Codes\top\Test\env\agent\monitor\monitor.sv}
vlog -coveropt 3 +cover +acc {Codes\top\Test\env\agent\sequencer\sequencer.sv}
vlog -coveropt 3 +cover +acc {Codes\top\Test\env\agent\agent.sv}
###
vlog -coveropt 3 +cover +acc {Codes\top\Test\env\coverage_collector\coverage_collector.sv}
vlog -coveropt 3 +cover +acc {Codes\top\Test\env\scoreboard\scoreboard.sv}
vlog -coveropt 3 +cover +acc {Codes\top\Test\env\env.sv}
###
vlog -coveropt 3 +cover +acc {Codes\top\Test\test.sv}
vlog -coveropt 3 +cover +acc {Codes\top\top.sv}

#vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
vsim +UVM_VERBOSITY=UVM_LOW -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

add wave -position insertpoint sim:/top/intf/*

run -all
#quit -sim