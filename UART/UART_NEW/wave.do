onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /input64_TB/uart_rxd
add wave -noupdate /input64_TB/reset
add wave -noupdate /input64_TB/fsm_state
add wave -noupdate /input64_TB/byteCnt
add wave -noupdate /input64_TB/uart_DataIn
add wave -noupdate /input64_TB/uart_rx_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {67047 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 193
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits sec
update
WaveRestoreZoom {6233319 ns} {10198247 ns}
