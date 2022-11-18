onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 25 /UART_TB/r_Clock
add wave -noupdate -height 25 /UART_TB/r_TX_DV
add wave -noupdate -height 25 /UART_TB/w_TX_Active
add wave -noupdate -height 25 /UART_TB/w_UART_Line
add wave -noupdate -height 25 /UART_TB/w_TX_Serial
add wave -noupdate -height 25 /UART_TB/r_TX_Byte
add wave -noupdate -height 25 /UART_TB/w_RX_Byte
add wave -noupdate -height 25 /UART_TB/w_RX_DV
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {7087460 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 252
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
WaveRestoreZoom {0 ps} {60841710 ps}
