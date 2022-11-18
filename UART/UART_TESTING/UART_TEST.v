
module UART_TEST (
    input clk,
    input RX,
    output TX
);
    reg TX_DV; //Set HIGH to send data, set LOW o.w.
    reg RX_DV; //Will go HIGH for one clock cylce at the end of the received byte
    reg TX_DONE; //Will go HIGH for one clock cycle after byte is transmitted
    reg [7:0] TX_BYTE, RX_BYTE; // transmitted and received bytes

    parameter CLKS_PER_BIT = 5208 //50MHZ clk / 9600 baud rate = 5208 clk per bit

    UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_Inst(
        .i_Clock(clk),
        .i_RX_Serial(RX),
        .o_RX_Byte(RX_BYTE),
        .o_RX_DV(RX_DV)
    );

    UART_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_Inst(
        .i_Clock(clk),
        .i_TX_DV(TX_DV),
        .i_TX_Byte(TX_BYTE),
        .o_TX_Done(TX_DONE)
    );
    
    always @(posedge clk ) begin
        
    end


endmodule