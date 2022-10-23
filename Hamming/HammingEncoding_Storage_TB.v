//Testbench for HammingEncoding_Storage.v


`timescale 100ms/100ms //Time unit, precision

module HammingEncoding_Storage_TB;
    reg [10:0] dataIn;
    reg clk;
    wire [15:0] codeWordOut;

    //localparam period = 1; //Duration for each bit = 1 * 100ms = 100ms

    HammingEncodingStorage UUT (
        .dataIn(dataIn),
        .clk(clk),
        .codeWordOut(codeWordOut)
    );

  

    always begin
        clk = 1'b1;
        #0.5; //high for 1 second
        clk = 1'b0;
        #0.5; // low for 1 second
    end

    always @(posedge clk) begin
    dataIn <= $random%2048; //generate a random number between 0 and 2^11
    end

endmodule