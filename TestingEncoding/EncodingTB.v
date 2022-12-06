
`timescale 1ns/1ns

module EncodingTB (
    output reg clk, //50MHz system clock
    output reg uart_rxd, //Hardware pin connected to uart_rx
    output reg reset, //reset pin active high
    wire [63:0] dataInput, data to be encoded
    wire [71:0] codeWord, //encoded data
    wire dataIn64Done
);
    reg [7:0] uart_DataIn [0:7]; //data for testing in bytes
    integer i;

       //Clock
    parameter CLK_HZ = 50000000;
    parameter CLK_P = 1000000000 / CLK_HZ;
    always begin #(CLK_P/2) assign clk = ~clk; end
    //UART bit rate
    parameter BIT_RATE = 9600;
    parameter BIT_P = (1000000000/BIT_RATE);
      
    initial begin
        reset = 1'b1;
        clk = 1'b0;
        uart_rxd = 1'b1;
        #480;
        reset = 1'b0;

    //Arbitrary data
        uart_DataIn[0] = 8'b10101010;
        uart_DataIn[1] = 8'b10101010;
        uart_DataIn[2] = 8'b11111111;
        uart_DataIn[3] = 8'b10101010;
        uart_DataIn[4] = 8'b10101010;
        uart_DataIn[5] = 8'b00000000;
        uart_DataIn[6] = 8'b10101010;
        uart_DataIn[7] = 8'b10101010;

        #10;

        repeat (8)begin
            send_byte(8'hAA); //active fsm
        end
        $display("Active fsm");
        for (i = 0; i < 8; i = i + 1) begin
            send_byte(uart_DataIn[i]);
            $display("Sending data...");
        end
        repeat (8)begin
            send_byte(8'h55); //idle the fsm
        end  
        $display("Idle fsm");

    end 

    input64 input64_Inst(
        .clk(clk), //Top level system clock
        .uart_rx_pin(uart_rxd), //uart recieve pin
        .reset(reset), //asynchronous active high reset
        .dataInput(dataInput), //64 bits of data to be encoded
        .dataIn64Done(dataIn64Done) //Pulses high when there is a new dataInput
    );

    HammingEncoding64 HammingEncoding64_Inst(
        .clk(clk), //Top level system clock
        .dataIn(dataInput), //64 bits of data to be encoded
        .codeWord(codeWord), //encoded data
        .dataIn64Done(dataIn64Done) //Triggers when to encode the data
    );
// Sends a single byte down the UART line.
    task send_byte;
        input [7:0] to_send;
        integer i;
        begin
            //$display("Sending byte: %d at time %d", to_send, $time);

            #BIT_P;  uart_rxd = 1'b0;
            for(i=0; i < 8; i = i+1) begin
                #BIT_P;  uart_rxd = to_send[i];

                //$display("    Bit: %d at time %d", i, $time);
            end
            #BIT_P;  uart_rxd = 1'b1;
            #1000;
        end
    endtask
endmodule