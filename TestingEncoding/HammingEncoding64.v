
//====================================================================================================================
//Hamming Encoding for Degree Project, Lakehead Univerity
//Author: Brady Bourgeois-Robichaud, Clayton Murzyn, Tyler Winger
//Date: Oct 20, 2022
//Description: Hamming encoding 57-bits of data using 7 parity bits for error correction and an additional parity bit
// for 2-bit error detection. (15+1 hamming encoding)
//====================================================================================================================

module HammingEncoding64 (
   
    input clk,
    input [63:0] dataIn,
    input dataIn64Done,
    output reg [71:0] codeWord
    
); //64 data bits and 7 + 1 parity bits, not using the 0 parity bit yet
  reg [7:0] dataLoc [63:0];
  reg [7:0] dataOnes [63:0];
  reg [6:0] dataOnesCount;
  reg [6:0] parityOnesCount = 7'b0;
  reg [6:0] parity;
  reg zeroParity;
  integer i,j;
//==================================================================================================================== 
initial begin
  //Initialize
    dataOnesCount = 6'b000000;

//Generating the array of the locations of the data
  j = 0;
  for (i = 3; i < 72; i = i + 1) begin
    if (i != 4 && i != 8 && i != 16 && i != 32 && i != 64 ) begin
        dataLoc[j] = i;
        j = j + 1;
    end
  end
end
//====================================================================================================================
always @(posedge dataIn64Done) begin
//Determining where the 1's are in the data
  for (i = 0; i < 64; i = i + 1) begin
      if (dataIn[i] == 1) begin
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
    for (i = 0; i < 7; i = i + 1) begin
        if (parity[i] == 1) begin
            parityOnesCount = parityOnesCount + 1;
        end
    end
    zeroParity = (dataOnesCount + parityOnesCount) % 2;

    //Creating the codeWord
    codeWord[0] = zeroParity;
    codeWord[1] = parity[0];
    codeWord[2] = parity[1];
    codeWord[3] = dataIn[0];
    codeWord[4] = parity[2];
    for (i = 5; i < 8; i = i + 1) begin
    codeWord[i] = dataIn[i-4];
    end
    codeWord[8] = parity[3];
    for (i = 9; i < 16; i = i + 1) begin
    codeWord[i] = dataIn[i-5];
    end
    codeWord[16] = parity[4];
    for (i = 17; i < 32; i = i + 1) begin
    codeWord[i] = dataIn[i-6];
    end
    codeWord[32] = parity[5];
    for (i = 33; i < 64; i = i + 1) begin
    codeWord[i] = dataIn[i-7];
    end
    codeWord[64] = parity[6];
    for (i = 65; i < 72; i = i + 1) begin
    codeWord[i] = dataIn[i-8];
    end

  //$display("P7=%b, P6=%b, P5=%b, P4=%b, P3=%b, P2-%b, P1=%b, P0=%b",parity[6],parity[5],parity[4],parity[3],parity[2],parity[1],parity[0],zeroParity);

end
//====================================================================================================================
endmodule


//Make an FSM for this