vlib work

vlog -coveropt 3 +cover +acc {shared_pkg\shared_pkg.sv}
###
vlog -coveropt 3 +cover +acc {Interface\interface.sv}
vlog -coveropt 3 +cover +acc {refrence\FIFO_ref.sv}
###
vlog -coveropt 3 +cover +acc {DUT\FIFO.sv}
vlog +define+LOOK_ASSERTION -coveropt 3 +cover +acc {DUT\assertion.sv}
###
vlog -coveropt 3 +cover +acc {objects\configration.sv}

#vlog -coveropt 3 +cover +acc {objects\sequence_Items\sequenceItem_Valid.sv}
vlog -coveropt 3 +cover +acc {objects\sequence_Item\sequenceItem.sv}

vlog -coveropt 3 +cover +acc {objects\FIFO_sequence\FIFO_reset_sequence.sv}
vlog -coveropt 3 +cover +acc {objects\FIFO_sequence\FIFO_write_only_sequence.sv}
vlog -coveropt 3 +cover +acc {objects\FIFO_sequence\FIFO_read_only_sequence.sv}
vlog -coveropt 3 +cover +acc {objects\FIFO_sequence\FIFO_write_read_sequence.sv}
vlog -coveropt 3 +cover +acc {objects\FIFO_sequence\FIFO_sync_toggle_sequence.sv}
vlog -coveropt 3 +cover +acc {objects\FIFO_sequence\FIFO_Async_toggle_sequence.sv}
vlog -coveropt 3 +cover +acc {objects\FIFO_sequence\FIFO_random_sequence.sv}
###
vlog -coveropt 3 +cover +acc {UVM_top\Test\env\agent\driver\driver.sv}
vlog -coveropt 3 +cover +acc {UVM_top\Test\env\agent\monitor\monitor.sv}
vlog -coveropt 3 +cover +acc {UVM_top\Test\env\agent\sequencer\sequencer.sv}
vlog -coveropt 3 +cover +acc {UVM_top\Test\env\agent\agent.sv}
###
vlog -coveropt 3 +cover +acc {UVM_top\Test\env\coverage_collector\coverage_collector.sv}
vlog -coveropt 3 +cover +acc {UVM_top\Test\env\scoreboard\scoreboard.sv}
vlog -coveropt 3 +cover +acc {UVM_top\Test\env\env.sv}
###
vlog -coveropt 3 +cover +acc {UVM_top\Test\test.sv}
vlog -coveropt 3 +cover +acc {UVM_top\top.sv}

#vsim -voptargs=+acc work.top -classdebug -uvmcontrol=all
vsim +UVM_VERBOSITY=UVM_LOW -voptargs=+acc work.top -classdebug -uvmcontrol=all -cover

add wave -position insertpoint sim:/top/intf/*

#run -all
vsim -coverage -vopt work.top -c -do "add wave *; coverage save -onexit -directive -codeAll cover.ucdb; run -all"
coverage report -detail -cvg -directive -comments -output {report\Directive_cover_report.txt} /.
coverage report -detail -cvg -directive -comments -output {report\covergroup_report.txt} /.
#coverage report -detail -cvg -directive -comments -output {report\code_COVER_FIFO.txt} {}

quit -sim

vcover report cover.ucdb -details -all -annotate -output {report\code_cover_FIFO.txt}

vcover report -html cover.ucdb -output {report\html_code_cover_report\.}
