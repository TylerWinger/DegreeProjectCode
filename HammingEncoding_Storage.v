
//====================================================================================================================
//Hamming Encoding for Degree Project, Lakehead Univerity
//Author: Brady Bourgeois-Robichaud, Clayton, Tyler Winger
//Date: Oct 20, 2022
//Description: Hamming encoding 11-bits of data using 4 parity bits for error correction and an additional parity bit
// for 2-bit error detection. (15+1 hamming encoding)
//====================================================================================================================

module HammingEncodingStorage (); //11 data bits and 4 + 1 parity bits, not using the 0 parity bit yet

  reg [10:0] data; //11 data bits
  reg [3:0] dataLoc [10:0]; //4-bit addresses for 11 data bits
  reg [3:0] dataOnes [10:0]; //storing the locations where there are 1's in the dataword
  reg [3:0] dataOnesCount; //Counts the number of 1's found in the dataWord
  reg [3:0] parity; //The parity word used to encode the data
  reg [15:0] codeWord [2047:0]; //The assembly of the data and parity bits
  
  integer i,j;
  
initial begin
    //data = 11'b10000101101; //arbitrary data bits for testing

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
        
        codeWord[j] = {data[10],data[9],data[8],data[7],data[6],data[5],data[4],parity[3],data[3],data[2],data[1],parity[2],data[0],parity[1],parity[0],1'b0};
        
        data = data + 1'b1; //Increment data everytime it calculates the codeWord
    end
end
endmodule