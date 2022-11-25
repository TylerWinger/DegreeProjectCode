

module testing64In (
    input clk,
    input sw,
    input wire uart_RX,
    output wire uart_TX,
    output wire [7:0] led
);
    reg [63:0] dataIn = 64'b0;
    reg [3:0] byteCnt = 4'b0;
    reg dataInValid = 1'b0;
    wire [7:0] uart_DataIn;

    //UART TOP
    impl_top impl_top_Inst(
        .clk(clk),
        .sw_0(sw),
        .uart_rxd(uart_RX),
        .uart_txd(uart_TX),
        .led(led)
    );

    //Intake 64bit dataWord byte by byte
        always @(uart_rx_valid)begin
        if (byteCnt < 8)begin
             dataIn = {dataIn , uart_DataIn[byteCnt]}; //append and shift (concatenation)
             dataInValid = 1'b0;
             byteCnt = byteCnt + 1;
        end 
        else dataInValid = 1'b1;
    end
	 
	 

endmodule