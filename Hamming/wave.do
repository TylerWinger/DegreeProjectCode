onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 50 -label dataIn -radix binary /HammingEncoding_Storage_TB/dataIn
add wave -noupdate -color Red -height 50 -label clk /HammingEncoding_Storage_TB/clk
add wave -noupdate -color Yellow -height 50 -label codeWord /HammingEncoding_Storage_TB/codeWordOut
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {400 ms} 0}
quietly wave cursor active 1
configure wave -namecolwidth 179
configure wave -valuecolwidth 156
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
WaveRestoreZoom {0 ms} {800 ms}
