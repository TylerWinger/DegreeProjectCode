module ck(
//input [3:0]messageIn [8:0], output reg [14:0]codeWord
); 
//====================================================================================================================
    reg [3:0] galoisField [15:0]; // n = 15 GF elements of length m = 4
    reg [3:0] genPoly [6:0]; //g(X) of power FCR+2t-1 = 6
    reg [3:0] parityInfo [7:0]; //CK(X)
    reg [3:0] messageIn [8:0]; //M(X)
    reg [3:0] codeWordVector [14:0]; //C(X) = [X^(n-k)]M(X) + CK(X)
    reg [3:0] shiftRegister [14:0]; 
    reg [3:0] shiftRegisterOld [14:0]; 
    reg [4:0] vectorTemp;
    
    integer i,j,k;
//====================================================================================================================    
    initial begin
        //testing
      for(i = 0; i < 9; i = i+1) begin
        messageIn[i] = 0;
      end  
      messageIn[1] = 4'b1110;

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
      
      // Giving g(X) appropriate magnitudes from hand calculations 
      genPoly[0] = galoisField[6];
      genPoly[1] = galoisField[9];
      genPoly[2] = galoisField[6];
      genPoly[3] = galoisField[4];
      genPoly[4] = galoisField[14];
      genPoly[5] = galoisField[10];
      genPoly[6] = galoisField[0];


    //-------------------------------------------------------------------------
    // Following Appendix A
    //Case 0
    for (i = 0; i < 6; i = i + 1) begin
      shiftRegister[i] = 0;
    end
    //Case 1 through k=9
    for (i = 8; i > -1; i = i - 1) begin
      for (k = 0; k < 15; k = k + 1) begin
        shiftRegisterOld[k] = shiftRegister[k];
      end

      //X^0 = (X^5_old + M_i(X))alpha^6
      vectorTemp = addition(shiftRegisterOld[5], messageIn[i]); 
      vectorTemp = vectorTemp != 15 ? vectorTemp + 4'd6 : 4'b0; 
      shiftRegister[0] = vectorTemp % 15; //Finite Field

      //X^1 = X^0_old + (X^5_old + M_i(X))alpha^9
      vectorTemp = addition(shiftRegisterOld[5], messageIn[i]);
      vectorTemp = addition(shiftRegisterOld[0], galoisField[vectorTemp]);
      vectorTemp = vectorTemp != 15 ? vectorTemp + 4'd9 : 4'b0; 
      shiftRegister[1] = vectorTemp % 15;

      //X^2 = X^1_old + (X^5_old + M_i(X))alpha^6
      vectorTemp = addition(shiftRegisterOld[5], messageIn[i]);
      vectorTemp = addition(shiftRegisterOld[1], galoisField[vectorTemp]);
      vectorTemp = vectorTemp != 15 ? vectorTemp + 4'd6 : 4'b0;
      shiftRegister[2] = vectorTemp % 15;

      //X^3 = X^2_old + (X^5_old + M_i(X))alpha^3
      vectorTemp = addition(shiftRegisterOld[5], messageIn[i]);
      vectorTemp = addition(shiftRegisterOld[1], galoisField[vectorTemp]);
      vectorTemp = vectorTemp != 15 ? vectorTemp + 4'd4 : 4'b0;
      shiftRegister[3] = vectorTemp % 15;
      
      //X^4 = X^3_old + (X^5_old + M_i(X))alpha^14
      vectorTemp = addition(shiftRegisterOld[5], messageIn[i]);
      vectorTemp = addition(shiftRegisterOld[1], galoisField[vectorTemp]);
      vectorTemp = vectorTemp != 15 ? vectorTemp + 4'd14 : 4'b0;
      shiftRegister[4] = vectorTemp % 15;

      //X^5 = X^4_old + (X^5_old + M_i(X))alpha^10
      vectorTemp = addition(shiftRegisterOld[5], messageIn[i]);
      vectorTemp = addition(shiftRegisterOld[1], galoisField[vectorTemp]);
      vectorTemp = vectorTemp != 15 ? vectorTemp + 4'd10 : 4'b0;
      shiftRegister[5] = vectorTemp % 15;

      for (j = 0; j < 15; j = j + 1) begin //Checking and fixing for finite field
        shiftRegister[j] = shiftRegister[j] % 15;
      end
    end

    end

    function [3:0] addition;
       input [3:0] a, b;
       reg [3:0] temp;
      begin
        temp = a ^ b;
        $display("a: %4b, b: %4b, temp: %4b",a,b,temp);
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

