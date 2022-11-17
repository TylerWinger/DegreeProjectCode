onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -color Yellow -height 25 /spiTB/clk
add wave -noupdate -color Yellow -height 25 /spiTB/sck
add wave -noupdate -height 25 /spiTB/rst
add wave -noupdate -expand -group Select -height 25 /spiTB/ss
add wave -noupdate -expand -group Select -height 25 /spiTB/ss_d
add wave -noupdate -expand -group Select -height 25 /spiTB/ss_q
add wave -noupdate -expand -group IN -color Magenta -height 25 /spiTB/mosi
add wave -noupdate -expand -group IN -height 25 /spiTB/mosi_d
add wave -noupdate -expand -group IN -height 25 /spiTB/mosi_q
add wave -noupdate -expand -group IN -height 25 /spiTB/din
add wave -noupdate -expand -group OUT -height 25 /spiTB/miso
add wave -noupdate -expand -group OUT -height 25 /spiTB/miso_q
add wave -noupdate -expand -group OUT -height 25 /spiTB/miso_d
add wave -noupdate -expand -group OUT -height 25 /spiTB/dout
add wave -noupdate -height 25 /spiTB/data_d
add wave -noupdate -height 25 /spiTB/data_q
add wave -noupdate -height 25 /spiTB/done
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {100 ms} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {2700 ms} {3900 ms}
