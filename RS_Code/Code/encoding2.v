module encoding2(
//input [3:0]messageIn [8:0], output reg [14:0]codeWord
); 
//====================================================================================================================
    reg [3:0] galoisField [15:0]; // n = 15 GF elements of length m = 4
    reg [3:0] parityInfo [5:0] ; //CK(X)
    reg [3:0] messageIn [8:0]; //M(X)
    reg [3:0] codeWordVector [14:0]; //C(X) = [X^(n-k)]M(X) + CK(X)
    reg [3:0] shiftRegister [5:0]; 
    reg [3:0] shiftRegisterOld [5:0]; 
    reg [4:0] vectorTemp;
    
    integer i,j;
//====================================================================================================================    
  initial begin

    //Initialization
      for (i = 0; i < 15; i = i + 1) begin
        parityInfo[i] = 4'b0;
      end
      for (i = 0; i < 15; i = i + 1) begin
        messageIn[i] = 4'b0;
      end
      for (i = 0; i < 15; i = i + 1) begin
        codeWordVector[i] = 4'b0;
      end

      messageIn[1] = 4'b1110; //a^11
      //messageIn[1] = 4'd3;
      //messageIn[0] = 4'd10;

      // Establishing GF elements (alpha_i values)
      galoisField[0] = 4'b0001; //alpha^0
      galoisField[1] = 4'b0010; //alpha^1
      galoisField[2] = 4'b0100; //alpha^2
      galoisField[3] = 4'b1000; //alpha^3
      galoisField[4] = 4'b0011; //alpha^4
      galoisField[5] = 4'b0110; //alpha^5
      galoisField[6] = 4'b1100; //alpha^6
      galoisField[7] = 4'b1011; //alpha^7
      galoisField[8] = 4'b0101; //alpha^8
      galoisField[9] = 4'b1010; //alpha^9
      galoisField[10] = 4'b0111; //alpha^10
      galoisField[11] = 4'b1110; //alpha^11
      galoisField[12] = 4'b1111; //alpha^12
      galoisField[13] = 4'b1101; //alpha^13
      galoisField[14] = 4'b1001; //alpha^14
      galoisField[15] = 4'b0000; //zero
      

    //-------------------------------------------------------------------------
    // Following Appendix A from Tutorial on Reed-Solomon Error Correction Coding
    //Case 0
    for (i = 0; i < 6; i = i + 1) begin
      shiftRegister[i] = 4'b0000;
    end
    //Case 1 through k=9
    for (i = 8; i > -1; i = i - 1) begin
      for (j = 0; j < 15; j = j + 1) begin
        shiftRegisterOld[j] = shiftRegister[j];
      end

      //X^0 = (X^5_old + M_i(X))alpha^6
      vectorTemp = shiftRegisterOld[5] ^ messageIn[i];
      shiftRegister[0] = multiply(vectorTemp, 4'b1100); 

      //X^1 = X^0_old + (X^5_old + M_i(X))alpha^9
      vectorTemp = shiftRegisterOld[5] ^ messageIn[i];
      vectorTemp = multiply(vectorTemp, 4'b1010);
      shiftRegister[1] = shiftRegisterOld[0] ^ vectorTemp;

      //X^2 = X^1_old + (X^5_old + M_i(X))alpha^6
      vectorTemp = shiftRegisterOld[5] ^ messageIn[i];
      vectorTemp = multiply(vectorTemp, 4'b1100);
      shiftRegister[2] = shiftRegisterOld[1] ^ vectorTemp;

      //X^3 = X^2_old + (X^5_old + M_i(X))alpha^4
      vectorTemp = shiftRegisterOld[5] ^ messageIn[i];
      vectorTemp = multiply(vectorTemp, 4'b0011);
      shiftRegister[3] = shiftRegisterOld[2] ^ vectorTemp;

      //X^4 = X^3_old + (X^5_old + M_i(X))alpha^14
      vectorTemp = shiftRegisterOld[5] ^ messageIn[i];
      vectorTemp = multiply(vectorTemp, 4'b1001);
      shiftRegister[4] = shiftRegisterOld[3] ^ vectorTemp;

      //X^5 = X^4_old + (X^5_old + M_i(X))alpha^10
      vectorTemp = shiftRegisterOld[5] ^ messageIn[i];
      vectorTemp = multiply(vectorTemp, 4'b0111);
      shiftRegister[5] = shiftRegisterOld[4] ^ vectorTemp;      
    end
    //C(X) = X^{n-k}*M(X) + CK(X)
    for (i = 0; i < 15; i = i + 1) begin
      if (i < 6) codeWordVector[i] = shiftRegister[i];        
      else codeWordVector[i] = messageIn[i - 6];
    end
  end

  function [3:0] multiply; //GF multiplication
  input [3:0] a, b;
    begin
        multiply[3] = (a[0]&b[3]) ^ (a[1]&b[2]) ^ (a[2]&b[1]) ^ (a[3]&b[0]) ^ (a[3]&b[3]);
        multiply[2] = (a[0]&b[2]) ^ (a[1]&b[1]) ^ (a[2]&b[0]) ^ (a[3]&b[3]) ^ (a[3]&b[2]) ^ (a[2]&b[3]);
        multiply[1] = (a[0]&b[1]) ^ (a[1]&b[0]) ^ (a[3]&b[2]) ^ (a[2]&b[3]) ^ (a[1]&b[3]) ^ (a[2]&b[2]) ^ (a[3]&b[1]);
        multiply[0] = (a[0]&b[0]) ^ (a[1]&b[3]) ^ (a[2]&b[2]) ^ (a[3]&b[1]);
    end
  endfunction
endmodule

