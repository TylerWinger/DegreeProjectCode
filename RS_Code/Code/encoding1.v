module encoding1( 
//input [3:0]messageIn [8:0], output reg [14:0]codeWord
); 
//====================================================================================================================
    reg [3:0] galoisField [15:0]; // n = 15 GF elements of length m = 4
    reg [3:0] parityInfo [14:0] ; //CK(X)
    reg [3:0] messageIn [14:0]; //M(X)
    reg [3:0] codeWordVector [14:0]; //C(X) = [X^(n-k)]M(X) + CK(X)
    reg [3:0] shiftRegister [5:0]; 
    reg [3:0] shiftRegisterOld [5:0]; 
    reg [4:0] vectorTemp;
    
    integer i,j,k;
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

      for(i = 0; i < 9; i = i+1) begin
        messageIn[i] = 4'd15;
      end  
      messageIn[1] = 4'd11;
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
      shiftRegister[i] = 4'd15;
    end
    //Case 1 through k=9
    for (i = 8; i > -1; i = i - 1) begin
      for (k = 0; k < 15; k = k + 1) begin
        shiftRegisterOld[k] = shiftRegister[k];
      end

      //X^0 = (X^5_old + M_i(X))alpha^6
      vectorTemp = addition(galoisField[shiftRegisterOld[5]], galoisField[messageIn[i]]); 
      shiftRegister[0] = vectorTemp != 15 ? (vectorTemp + 4'd6)%15 : 4'd15; 

      //X^1 = X^0_old + (X^5_old + M_i(X))alpha^9
      vectorTemp = addition(galoisField[shiftRegisterOld[5]], galoisField[messageIn[i]]);
      vectorTemp = vectorTemp != 15 ? (vectorTemp + 4'd9) % 15 : 4'd15; 
      shiftRegister[1] = addition(galoisField[shiftRegisterOld[0]], galoisField[vectorTemp]);

      //X^2 = X^1_old + (X^5_old + M_i(X))alpha^6
      vectorTemp = addition(galoisField[shiftRegisterOld[5]], galoisField[messageIn[i]]);
      vectorTemp = vectorTemp != 15 ? (vectorTemp + 4'd6) % 15 : 4'd15;
      shiftRegister[2] = addition(galoisField[shiftRegisterOld[1]], galoisField[vectorTemp]);

      //X^3 = X^2_old + (X^5_old + M_i(X))alpha^3
      vectorTemp = addition(galoisField[shiftRegisterOld[5]], galoisField[messageIn[i]]);
      vectorTemp = vectorTemp != 15 ? (vectorTemp + 4'd4) % 15 : 4'd15;
      shiftRegister[3] = addition(galoisField[shiftRegisterOld[2]], galoisField[vectorTemp]);
      
      //X^4 = X^3_old + (X^5_old + M_i(X))alpha^14
      vectorTemp = addition(galoisField[shiftRegisterOld[5]], galoisField[messageIn[i]]);
      vectorTemp = vectorTemp != 15 ? (vectorTemp + 4'd14) % 15 : 4'd15;
      shiftRegister[4] = addition(galoisField[shiftRegisterOld[3]], galoisField[vectorTemp]);

      //X^5 = X^4_old + (X^5_old + M_i(X))alpha^10
      vectorTemp = addition(galoisField[shiftRegisterOld[5]], galoisField[messageIn[i]]);
      vectorTemp = vectorTemp != 15 ? (vectorTemp + 4'd10) % 15 : 4'd15;
      shiftRegister[5] = addition(galoisField[shiftRegisterOld[4]], galoisField[vectorTemp]);
    end

    for (i = 0; i < 6; i = i + 1) begin //Switch from exponent form to vector form
      parityInfo[i] = galoisField[shiftRegister[i]];
    end

    //C(X) = X^{n-k}M(X) + CK(X), n-k = 6
    for (i = 8; i > -1; i = i - 1) begin //Switch from exponent form to vector form
      messageIn[i] = galoisField[messageIn[i]];
    end
    for (i = 0; i < 6 ;i = i + 1 ) begin //shift messageIn by X^{n-k} << 6
      for (j = 8; j > -1; j = j - 1) begin
        messageIn[j] = j == 0 ? 4'b0 : messageIn[j-1];
      end
    end
    for (i = 0; i < 15; i = i + 1) begin
      codeWordVector[i] = messageIn[i] + parityInfo[i];
    end
 
  end

  function [3:0] addition; // Galois field addition
      input [3:0] a, b;
      reg [3:0] temp;
    begin
      temp = a ^ b;
      //$display("a: %4b, b: %4b, temp: %4b",a,b,temp);
      case (temp)
        4'b0000 : addition = 15;
        4'b0001 : addition = 0;
        4'b0010 : addition = 1;
        4'b0100 : addition = 2;
        4'b1000 : addition = 3;
        4'b0011 : addition = 4;
        4'b0110 : addition = 5;
        4'b1100 : addition = 6;
        4'b1011 : addition = 7;
        4'b0101 : addition = 8;
        4'b1010 : addition = 9;
        4'b0111 : addition = 10;
        4'b1110 : addition = 11;
        4'b1111 : addition = 12;
        4'b1101 : addition = 13;
        4'b1001 : addition = 14;
        
      endcase
    end
  endfunction
endmodule

