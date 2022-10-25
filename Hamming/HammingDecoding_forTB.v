
//====================================================================================================================
//Hamming decoding for Degree Project, Lakehead Univerity
//Author: Brady Bourgeois-Robichaud, Clayton Murzyn, Tyler Winger
//Date: Oct 24, 2022
//Description: Hamming decoding 11-bits of data using 4 parity bits for error correction and an additional parity bit
// for 2-bit error detection. (15+1 hamming decoding)
//====================================================================================================================

module HammingDecoding (
    //input reg[15:0] channelWord, //codeWord with possible error
    //input clk
);
//====================================================================================================================
    reg [3:0] channelOnes [15:0]; //locations where there are 1's
    reg [3:0] onesCount; //number of 1's
    reg [4:0] errorLoc; //location of the error (if one exists), if 0 then there is no error
    reg [15:0] channelWord; //incoming word, may have an error
    reg [15:0] correctCodeWord; //channelWord with error corrected if one existed
    reg [10:0] dataWord; //data extracted from the correctCodeWord
    integer i; //used for for loops
//====================================================================================================================    
    //always @(posedge) begin
    initial begin
        errorLoc = 5'b00000;
        channelWord = 16'b1111110011110110; //initalizing channelWord with a dataWord with 1 error. The correct codeWord corresponses to dataWord 2030 (see 'codeWordList.txt') 
        onesCount = 0;

    //Finding the 1's in the channelWord, putting the location of the 1 in channelOnes if it exists or a 0 if not
        for (i = 1; i < 16; i = i + 1) begin //skipping the zeroth bit
            if (channelWord[i] == 1) begin
                channelOnes[i] = i; 
                onesCount = onesCount + 1;
            end
            else begin
                channelOnes[i] = 0;
            end
        end    

    //Taking the XOR of channelOnes
        if (onesCount == 1) begin
            for (i = 0; i < 16 ; i = i + 1) begin //Find the one location where the error is
                if (channelOnes[i] != 0) begin
                    errorLoc = channelOnes[i];
                end
            end
        end
        else if (onesCount > 1)begin //Taking the XOR of all the locations of channelOnes to find where the error is.
            for (i = 1; i < 16; i = i + 1) begin
                errorLoc = errorLoc ^ channelOnes[i]; 
            end      
        end
    //Correcting error and displaying results
        if (errorLoc == 0) begin
            $display("No errors were found.");
            correctCodeWord = channelWord;
        end 
        else begin
            $display("There is an error in location %0d",errorLoc);
            correctCodeWord = channelWord;
            correctCodeWord[errorLoc] = !correctCodeWord[errorLoc];
        end
        dataWord = {correctCodeWord[15],correctCodeWord[14],correctCodeWord[13],correctCodeWord[12],correctCodeWord[11],correctCodeWord[10],correctCodeWord[9],correctCodeWord[7],correctCodeWord[6],correctCodeWord[5],correctCodeWord[3]};
        $display("Received Code Word = %0b",channelWord);
        $display("Correct Code Word = %0b",correctCodeWord);
        $display("Data Word = %0d",dataWord);
    end
endmodule
