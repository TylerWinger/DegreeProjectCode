

module testing64In (
    input clk,
    input sw,
    input wire uart_RX,
    output wire uart_TX,
    output wire [7:0] led
);
    reg [63:0] dataIn = 64'b0;

    //UART TOP
    impl_top impl_top_Inst(
        .clk(clk),
        .sw_0(sw),
        .uart_rxd(uart_RX),
        .uart_txd(uart_TX),
        .led(led)
    );
	 
	 

endmodule