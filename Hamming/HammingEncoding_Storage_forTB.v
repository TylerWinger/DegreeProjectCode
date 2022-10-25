
//====================================================================================================================
//Hamming Encoding for Degree Project, Lakehead Univerity
//Author: Brady Bourgeois-Robichaud, Clayton Murzyn, Tyler Winger
//Date: Oct 20, 2022
//Description: Hamming encoding 11-bits of data using 4 parity bits for error correction and an additional parity bit
// for 2-bit error detection. (15+1 hamming encoding)
//====================================================================================================================

module HammingEncodingStorage (
    input clk,
    input [10:0] dataIn,
    output reg [15:0] codeWordOut
); //11 data bits and 4 + 1 parity bits, not using the 0 parity bit yet

  reg [10:0] data; //11 data bits
  reg [3:0] dataLoc [10:0]; //4-bit addresses for 11 data bits
  reg [3:0] dataOnes [10:0]; //storing the locations where there are 1's in the dataword
  reg [3:0] dataOnesCount; //Counts the number of 1's found in the dataWord
  reg [3:0] parity; //The parity word used to encode the data
  reg [15:0] codeWord [2047:0]; //The assembly of the data and parity bits
  reg [2:0] parityOnesCount;
  reg zeroParity;
  
  integer i,j;
//==================================================================================================================== 
initial begin
  //Initialize
    dataLoc[0] = 4'b0011;
    dataLoc[1] = 4'b0101;
    dataLoc[2] = 4'b0110;
    dataLoc[3] = 4'b0111;
    dataLoc[4] = 4'b1001;
    dataLoc[5] = 4'b1010;
    dataLoc[6] = 4'b1011;
    dataLoc[7] = 4'b1100;
    dataLoc[8] = 4'b1101;
    dataLoc[9] = 4'b1110;
    dataLoc[10] = 4'b1111;
    data = 11'b00000000000; //Initialize data to 0
    parityOnesCount = 4'b0000;
//====================================================================================================================
// Making a LUT for all 2048 possible codeWords 
//--------------------------------------------------------------------------------------------------------------------
    for (j = 0; j < 2048; j = j + 1) begin    
        parity = 4'b0000; //Initialize parity to 0 at the start of every codeWord calculation
        dataOnesCount = 1'b0; //Initialize dataOnesCount to 0 at the start of every codeWord calculation

    //Determining where the 1's in the dataword reside
        for (i = 0; i < 11; i = i + 1) begin 
        if (data[i] == 1) begin
            dataOnes[dataOnesCount] = dataLoc[i];
            dataOnesCount = dataOnesCount + 1;
        end      
    end
    
    //Taking the XOR of all the locations where a 1 are, to calculate the parity word 
        if (dataOnesCount == 1)begin
            parity = dataOnes[0];
        end
        else if (dataOnesCount > 1)begin
            parity = dataOnes[0] ^ dataOnes[1];
            for (i = 2; i < dataOnesCount; i = i + 1) begin
                parity = parity ^ dataOnes[i];
            end   
        end

    //Finding the zeroth parity bit
        for (i = 0; i < 4; i = i + 1) begin
            if (parity[i] == 1) begin
                parityOnesCount = parityOnesCount + 1;
            end
        end
        zeroParity = (dataOnesCount + parityOnesCount) % 2;

        codeWord[j] = {data[10],data[9],data[8],data[7],data[6],data[5],data[4],parity[3],data[3],data[2],data[1],parity[2],data[0],parity[1],parity[0],zeroParity};
        
        data = data + 1'b1; //Increment data everytime it calculates the codeWord
    end
end
//====================================================================================================================

always @(negedge clk ) begin
    $display("Code Word: %0b \n Data In: %0b , %0d",codeWord[dataIn],dataIn,dataIn);
    codeWordOut <= codeWord[dataIn];
end
//====================================================================================================================

endmodule