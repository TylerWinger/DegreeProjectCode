
//====================================================================================================================
//Reed-Solomon encoding for Degree Project, Lakehead Univerity
//Author: Brady Bourgeois-Robichaud, Clayton Murzyn, Tyler Winger
//Date: Dec 1, 2022
//Description: Hamming decoding 9-bits of data using 6 parity bits for error correction (15,9)RS
//====================================================================================================================
module HammingDecodingJan10(
//input [3:0]messageIn [8:0], output reg [14:0]codeWord
); 
//====================================================================================================================
    reg [3:0]galoisField [14:0]; // n = 15 GF elements of length m = 4
    reg [3:0]genPoly [6:0]; //g(X) of power FCR+2t-1 = 6
    reg [3:0]parityInfo [7:0]; //CK(X)
    reg [3:0]messageIn [8:0]; //M(X)
    reg [3:0]codeWord [14:0]; //[X^(n-k)]M(X)
    reg [31:0] dividend, divisor, quotient, remainder;
    reg [31:0] remainder_temp;
    
    integer messageInt;
    integer genInt;
    integer out;
    integer i;
//====================================================================================================================    
    initial begin
      
      for(i = 0; i < 9; i = i+1) begin
        messageIn[i] = 0;
      end  
      messageIn[1] = 4'b1110;

      // Establishing GF elements (alpha_i values)
      galoisField[0] = 4'b0001;
      galoisField[1] = 4'b0010;
      galoisField[2] = 4'b0100;
      galoisField[3] = 4'b1000;
      galoisField[4] = 4'b0011;
      galoisField[5] = 4'b0110;
      galoisField[6] = 4'b1100;
      galoisField[7] = 4'b1011;
      galoisField[8] = 4'b0101;
      galoisField[9] = 4'b1010;
      galoisField[10] = 4'b0111;
      galoisField[11] = 4'b1110;
      galoisField[12] = 4'b1111;
      galoisField[13] = 4'b1101;
      galoisField[14] = 4'b1001;
      
      // Giving g(X) appropriate magnitudes from hand calculations 
      genPoly[0] = galoisField[6];
      genPoly[1] = galoisField[9];
      genPoly[2] = galoisField[6];
      genPoly[3] = galoisField[4];
      genPoly[4] = galoisField[14];
      genPoly[5] = galoisField[10];
      genPoly[6] = galoisField[0];
      
      for (i = 0; i < 15; i = i+1) begin
        codeWord[i] = 0; 
      end
      
      // Shifting M(X) by 6 (performing the function of X^(n-k) 
      // This version of the code word does not include CK(X) yet
      for (i = 8; i > -1; i = i-1)begin
        codeWord[i+6] = messageIn[i];  
      end
      
      // Calculating CK(X)   
      for (i = 0; i < 6; i=i+1) begin
        parityInfo[i] = codeWord[i] % genPoly[i];
      end
        
       
    end
endmodule


