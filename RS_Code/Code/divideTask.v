module divideTB;
  reg [3:0] dividend = 4'b0111; //a^10
  reg [3:0] divisor =  4'b0110; //a^4
  reg [4:0] answer;

initial divide(dividend, divisor, answer);

task divide; //Check bit4 for division by zero error
    input [3:0] dividend, divisor;
    output [4:0] quotient;
    reg [3:0] Idivisor; //inverse divisor
    begin
        if (divisor == 4'b0000) quotient = 5'b10000;

        //Find inverse of the divisor
        else    case (divisor)
                4'b0000 : Idivisor = 4'b0000;
                4'b0001 : Idivisor = 4'b0001; //a^0 
                4'b0010 : Idivisor = 4'b1001; //a^1 -> a^-1 = a^14
                4'b0100 : Idivisor = 4'b1101; //a^2 -> a^-2 = a^13
                4'b1000 : Idivisor = 4'b1111; //a^3 -> a^-3
                4'b0011 : Idivisor = 4'b1110; //a^4 -> a^-4
                4'b0110 : Idivisor = 4'b0111; //a^5 -> a^-5
                4'b1100 : Idivisor = 4'b1010; //a^6 -> a^-6
                4'b1011 : Idivisor = 4'b0101; //a^7 -> a^-7
                4'b0101 : Idivisor = 4'b1011; //a^8 -> a^-8
                4'b1010 : Idivisor = 4'b1100; //a^9 -> a^-9
                4'b0111 : Idivisor = 4'b0110; //a^10 -> a^-10
                4'b1110 : Idivisor = 4'b0011; //a^11 -> a^-11
                4'b1111 : Idivisor = 4'b1000; //a^12 -> a^-12
                4'b1101 : Idivisor = 4'b0100; //a^13 -> a^-13
                4'b1001 : Idivisor = 4'b0001; //a^14 -> a^-14
                default: Idivisor = 4'b0000;
            endcase
            // Mulitply dividend by the inverse divisor
            quotient[3] = (dividend[0]&Idivisor[3]) ^ (dividend[1]&Idivisor[2]) ^ (dividend[2]&Idivisor[1]) ^ (dividend[3]&Idivisor[0]) ^ (dividend[3]&Idivisor[3]);
            quotient[2] = (dividend[0]&Idivisor[2]) ^ (dividend[1]&Idivisor[1]) ^ (dividend[2]&Idivisor[0]) ^ (dividend[3]&Idivisor[3]) ^ (dividend[3]&Idivisor[2]) ^ (dividend[2]&Idivisor[3]);
            quotient[1] = (dividend[0]&Idivisor[1]) ^ (dividend[1]&Idivisor[0]) ^ (dividend[3]&Idivisor[2]) ^ (dividend[2]&Idivisor[3]) ^ (dividend[1]&Idivisor[3]) ^ (dividend[2]&Idivisor[2]) ^ (dividend[3]&Idivisor[1]);
            quotient[0] = (dividend[0]&Idivisor[0]) ^ (dividend[1]&Idivisor[3]) ^ (dividend[2]&Idivisor[2]) ^ (dividend[3]&Idivisor[1]);
    end
endtask   
endmodule