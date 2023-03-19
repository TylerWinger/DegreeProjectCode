module decodingCont(
    input [59:0] recievedWordIn,
    input decodeMessage,
    output reg [35:0] messageRecieved ,
    output reg decoderBusy
); 
//====================================================================================================================
reg [3:0] galoisField[14:0]; //GF(15)
reg [3:0] recievedWord[14:0]; //R(X)
reg [3:0] syndromeComponent[5:0]; //S_i
reg [3:0] det [4:0]; //determinants
reg [3:0] errorLocator[2:0]; //sigma_i
reg [3:0] errorTemp;
reg [3:0] errorPosition[2:0]; //z_i
reg [3:0] errorValue[2:0]; //y_i
reg [3:0] errorWord[14:0];
reg [3:0] codeWord[14:0];

integer i,j,k;
integer T; //Used for # of errors
integer loc[2:0]; //Used to know decimal location of error
//====================================================================================================================    
initial begin
  decoderBusy = 0;

  //Establishing GF elements (alpha_i values)
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

end


always @(decodeMessage)begin
  decoderBusy = 1;
  //Initialization
    
  for (i = 0; i < 15; i = i + 1) begin
    recievedWord[i] = 0;
    errorWord[i] = 0;
    codeWord[i] = 0;
  end
    
  for (i = 0; i < 6; i = i + 1) begin
    syndromeComponent[i] = 0;
  end

  for (i = 0; i < 3; i = i + 1) begin
    errorLocator[i] = 0;
    errorPosition[i] = 0;
    errorValue[i] = 0;
    loc[i] = 0;
  end

  errorTemp = 0;

  //Unpack recievedWordIn
  for (i = 0; i <= 14 ;i = i + 1) begin
    recievedWord[i] = recievedWordIn[4*i +: 4];
  end
   
  //--------------------------------------------------
      
  //Calculating syndrome components (Method 1 4.2.1)
  //Note: S1 to S6 used in the reference paper

  for(i = 1; i < 7; i = i+1) begin
    for(j = 0; j < 15; j = j+1) begin
      if((j*i) < 15) begin
        syndromeComponent[i-1] = syndromeComponent[i-1] ^ multiply(recievedWord[j],galoisField[j*i]); 
      end
      else begin
        syndromeComponent[i-1] = syndromeComponent[i-1] ^ multiply(recievedWord[j],galoisField[(j*i)%15]);
      end
    end
  end

  //Calculating error locator polynomial using linear recursion 4.3.2
  det[0] = multiply(syndromeComponent[2],syndromeComponent[4]) ^ multiply(syndromeComponent[3],syndromeComponent[3]); // Represents det3,4
  det[1] = multiply(syndromeComponent[1],syndromeComponent[4]) ^ multiply(syndromeComponent[3],syndromeComponent[2]); // Represents det2,4
  det[2] = multiply(syndromeComponent[1],syndromeComponent[3]) ^ multiply(syndromeComponent[2],syndromeComponent[2]); // Represents det2,3
  det[3] = multiply(syndromeComponent[0],det[0]) ^ multiply(syndromeComponent[1],det[1]) ^ multiply(syndromeComponent[2],det[2]); //Represents det1,2,3


  //When all Si are 0, there are no errors
  if((syndromeComponent[0] || syndromeComponent[1] || syndromeComponent[2] || syndromeComponent[3] || syndromeComponent[4] || syndromeComponent[5]) == 0) begin
    T = 0;
  end

//Condition for 1 error, this condition is also true when all syndromes are zero, thus we used else if 
  else if((divide(syndromeComponent[1],syndromeComponent[0])==divide(syndromeComponent[2],syndromeComponent[1])) && (divide(syndromeComponent[2],syndromeComponent[1])==divide(syndromeComponent[3],syndromeComponent[2])) && (divide(syndromeComponent[3],syndromeComponent[2])==divide(syndromeComponent[4],syndromeComponent[3])) && (divide(syndromeComponent[4],syndromeComponent[3])==divide(syndromeComponent[5],syndromeComponent[4])) && (divide(syndromeComponent[5],syndromeComponent[4])==divide(syndromeComponent[1],syndromeComponent[0]))) begin
    errorLocator[0] = divide(syndromeComponent[1],syndromeComponent[0]);
    T = 1;
  end

  //Condition for 2 errors 
  if(det[0] != 0) begin //If the determinant of generated equations is not 0
    errorLocator[0] = divide((multiply(syndromeComponent[0],syndromeComponent[3]) ^ multiply(syndromeComponent[1],syndromeComponent[2])),(multiply(syndromeComponent[0],syndromeComponent[2]) ^ multiply(syndromeComponent[1],syndromeComponent[1])));
    errorLocator[1] = divide((multiply(syndromeComponent[1],syndromeComponent[3]) ^ multiply(syndromeComponent[2],syndromeComponent[2])),(multiply(syndromeComponent[1],syndromeComponent[1]) ^ multiply(syndromeComponent[0],syndromeComponent[2])));  
    T = 2;
  end

    //Condition for T = 3
  if(det[3] != 0) begin
    errorLocator[0] = divide(multiply(multiply(syndromeComponent[0],syndromeComponent[2]),syndromeComponent[5]) ^ multiply(multiply(syndromeComponent[0],syndromeComponent[3]),syndromeComponent[4]) ^ multiply(multiply(syndromeComponent[1],syndromeComponent[1]),syndromeComponent[5]) ^ multiply(multiply(syndromeComponent[1],syndromeComponent[2]),syndromeComponent[4]) ^ multiply(multiply(syndromeComponent[3],syndromeComponent[3]),syndromeComponent[1]) ^ multiply(multiply(syndromeComponent[2],syndromeComponent[2]),syndromeComponent[3]),det[3]);
    errorLocator[1] = divide(multiply(syndromeComponent[0],multiply(syndromeComponent[4],syndromeComponent[4])) ^ multiply(syndromeComponent[0],multiply(syndromeComponent[3],syndromeComponent[5])) ^ multiply(syndromeComponent[1],multiply(syndromeComponent[3],syndromeComponent[4])) ^ multiply(syndromeComponent[2],multiply(syndromeComponent[3],syndromeComponent[3])) ^ multiply(syndromeComponent[1],multiply(syndromeComponent[2],syndromeComponent[5])) ^ multiply(syndromeComponent[4],multiply(syndromeComponent[2],syndromeComponent[2])), det[3]);
    errorLocator[2] = divide(multiply(syndromeComponent[3],multiply(syndromeComponent[3],syndromeComponent[3])) ^ multiply(syndromeComponent[1],multiply(syndromeComponent[4],syndromeComponent[4])) ^ multiply(syndromeComponent[1],multiply(syndromeComponent[3],syndromeComponent[5])) ^ multiply(syndromeComponent[5],multiply(syndromeComponent[2],syndromeComponent[2])),det[3]);
    T = 3;
  end


  //Finding error positions
  if(T == 1 || T == 2 || T == 3) begin
    j = 0;
    for(i = 0; i < 15; i = i+1) begin
      if(T == 1) begin
        errorTemp = galoisField[i] ^ errorLocator[0];
        if(errorTemp == 0) begin
          errorPosition[0] = galoisField[i];
          loc[0] = i;
        end
      end

      if(T == 2) begin
        errorTemp = multiply(galoisField[i],galoisField[i]) ^ multiply(errorLocator[0],galoisField[i]) ^ errorLocator[1];
          if(errorTemp == 0) begin
            errorPosition[j] = galoisField[i];
            loc[j] = i;
            j = j+1;
          end
      end

      if(T == 3) begin
        errorTemp = multiply(galoisField[i],multiply(galoisField[i],galoisField[i])) ^ multiply(errorLocator[0],multiply(galoisField[i],galoisField[i])) ^ multiply(errorLocator[1],galoisField[i]) ^ errorLocator[2];
          if(errorTemp == 0) begin
            errorPosition[j] = galoisField[i];
            loc[j] = i;
           j = j+1;
          end
      end
    end


    
    if (T == 1) begin //4.5.1 Direct Method
      errorValue[0] = divide(syndromeComponent[0],errorPosition[0]); //Finding error values
      errorWord[loc[0]] = errorValue[0]; //Decoding the error word 
    end
    if (T == 2) begin //4.5.1 Direct Method
      det[4] = multiply(multiply(errorPosition[1],errorPosition[1]),errorPosition[0]) ^ multiply(multiply(errorPosition[0],errorPosition[0]),errorPosition[1]);
      errorValue[0] = divide(multiply(syndromeComponent[0],multiply(errorPosition[1],errorPosition[1])) ^ multiply(syndromeComponent[1],errorPosition[1]) , det[4]);
      errorValue[1] = divide(multiply(errorPosition[0],syndromeComponent[1]) ^ multiply(multiply(errorPosition[0],errorPosition[0]),syndromeComponent[0]) , det[4]);
      errorWord[loc[0]] = errorValue[0]; 
      errorWord[loc[1]] = errorValue[1];
    end
    if(T == 3)begin //4.5.1 Direct Method
      if (!(loc[0] & loc[1]) || !(loc[0] & loc[2]) || !(loc[1] & loc[2])) begin //If any two locations are zero then there is more than 3 errors.
        T = 4;
      end
      else begin
        errorValue[0] = divide(multiply(errorPosition[2],multiply(syndromeComponent[0],errorPosition[1]) ^ syndromeComponent[1]) ^ multiply(syndromeComponent[1],errorPosition[1]) ^ syndromeComponent[2]  ,  multiply(errorPosition[2],multiply(errorPosition[0],errorPosition[1]) ^ multiply(errorPosition[0],errorPosition[0])) ^ multiply(multiply(errorPosition[0],errorPosition[0]),errorPosition[1]) ^ multiply(multiply(errorPosition[0],errorPosition[0]),errorPosition[0]));
        errorValue[1] = divide(multiply(errorPosition[2],multiply(syndromeComponent[0],errorPosition[0]) ^ syndromeComponent[1]) ^ multiply(syndromeComponent[1],errorPosition[0]) ^ syndromeComponent[2]  ,  multiply(errorPosition[2],multiply(errorPosition[1],errorPosition[1]) ^ multiply(errorPosition[0],errorPosition[1])) ^ multiply(multiply(errorPosition[1],errorPosition[1]),errorPosition[1]) ^ multiply(multiply(errorPosition[1],errorPosition[1]),errorPosition[0]));
        errorValue[2] = divide(multiply(errorPosition[1],multiply(syndromeComponent[0],errorPosition[0]) ^ syndromeComponent[1]) ^ multiply(syndromeComponent[1],errorPosition[0]) ^ syndromeComponent[2]  ,  multiply(multiply(errorPosition[2],errorPosition[2]),errorPosition[2]) ^ multiply(multiply(errorPosition[2],errorPosition[2]),errorPosition[1] ^ errorPosition[0]) ^ multiply(multiply(errorPosition[0],errorPosition[1]),errorPosition[2]));
        errorWord[loc[0]] = errorValue[0]; 
        errorWord[loc[1]] = errorValue[1];
        errorWord[loc[2]] = errorValue[2];
      end
    end

    //Decoding the code word
    for(i = 0; i < 15; i = i+1) begin
      codeWord[i] = recievedWord[i] ^ errorWord[i];
    end

    //Seperate the message and pack it
    for (i = 6; i <= 14; i = i + 1) begin
      messageRecieved[4*(i-6) +: 4] = codeWord[i];
    end
  end 

  //Codeword condition when there are no errors
  //! Should be able to compress this
  if(T == 0) begin
    for(i = 0; i < 15; i = i+1) begin
      codeWord[i] = recievedWord[i];
    end
    //Seperate the message and pack it
    for (i = 6; i <= 14; i = i + 1) begin
      messageRecieved[4*(i-6) +: 4] = codeWord[i];
    end
  end

  //Codeword condition when there are more than 3 errors (sends tone message to indicate poor signal)
  if(T == 4) begin
    for(i = 0; i < 15; i = i+1) begin
      codeWord[i] = 1;
    end
  end
  decoderBusy = 0;
end   


  

function [3:0] multiply; //Returns a*b
  input [3:0] a, b;
  begin
    multiply[3] = (a[3]&b[3]) ^ (a[3]&b[0]) ^ (a[2]&b[1]) ^ (a[1]&b[2]) ^ (a[0]&b[3]);
    multiply[2] = (a[3]&b[3]) ^ (a[3]&b[2]) ^ (a[2]&b[3]) ^ (a[2]&b[0]) ^ (a[1]&b[1]) ^ (a[0]&b[2]);
    multiply[1] = (a[3]&b[2]) ^ (a[3]&b[1]) ^ (a[2]&b[3]) ^ (a[2]&b[2]) ^ (a[1]&b[3]) ^ (a[1]&b[0]) ^ (a[0]&b[1]);
    multiply[0] = (a[3]&b[1]) ^ (a[2]&b[2]) ^ (a[1]&b[3]) ^ (a[0]&b[0]);
  end
endfunction

function [3:0] divide; //Returns a*(b^-1) = a/b
  input [3:0] a, b;
  reg [3:0] inv_b;
  begin
    case(b)         
    4'b0001 : inv_b = 4'b0001; //alpha^0 
    4'b0010 : inv_b = 4'b1001; //alpha^1 -> alpha^-1 = alpha^14
    4'b0100 : inv_b = 4'b1101; //alpha^2 -> alpha^-2 = alpha^13
    4'b1000 : inv_b = 4'b1111; //alpha^3 -> alpha^-3
    4'b0011 : inv_b = 4'b1110; //alpha^4 -> alpha^-4
    4'b0110 : inv_b = 4'b0111; //alpha^5 -> alpha^-5
    4'b1100 : inv_b = 4'b1010; //alpha^6 -> alpha^-6
    4'b1011 : inv_b = 4'b0101; //alpha^7 -> alpha^-7
    4'b0101 : inv_b = 4'b1011; //alpha^8 -> alpha^-8
    4'b1010 : inv_b = 4'b1100; //alpha^9 -> alpha^-9
    4'b0111 : inv_b = 4'b0110; //alpha^10 -> alpha^-10
    4'b1110 : inv_b = 4'b0011; //alpha^11 -> alpha^-11
    4'b1111 : inv_b = 4'b1000; //alpha^12 -> alpha^-12
    4'b1101 : inv_b = 4'b0100; //alpha^13 -> alpha^-13
    4'b1001 : inv_b = 4'b0001; //alpha^14 -> alpha^-14
    4'b0000 : inv_b = 4'b0000; //Will result in multiply = 0
    endcase
    divide = multiply(a,inv_b);
  end
endfunction
endmodule

