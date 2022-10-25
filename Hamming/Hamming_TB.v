//Testbench for HammingEncoding_Storage.v


`timescale 100ms/100ms //Time unit, precision

module Hamming_TB;
    reg [10:0] dataIn;
    reg clk;
    wire [15:0] codeWordOut;
    wire [10:0] dataOut;
    reg [15:0] channelWord;

    //localparam period = 1; //Duration for each bit = 1 * 100ms = 100ms


    HammingEncodingStorage_forTB UUT (
        .dataIn(dataIn), //the generated dataWord
        .clk(clk),
        .codeWordOut(codeWordOut) //The output of the encoder
    );  
    HammingDecoding_forTB UUT2(
        .clk(clk),
        .channelWord(channelWord), //The codeWord with a possible error
        .dataOut(dataOut) //The data extracted from the corrected channelWord
    );

    always begin
        clk = 1'b1;
        #0.5; //high for 1 second
        clk = 1'b0;
        #0.5; // low for 1 second
    end


    always @(posedge clk) begin
        dataIn = $random%2048; //Generating a random 11 bit number 
    end
    always @(negedge clk) begin
        channelWord = codeWordOut;
        channelWord[2] = !channelWord[2]; //Flipping bit 2
    end

endmodule
