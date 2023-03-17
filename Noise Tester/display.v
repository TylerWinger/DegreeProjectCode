/*
 This module takes a 4 bit [3:0] output from the BCD module
    and displays it on a sevem segment display
*/

/* 
NOTES: low level logic turns on segments while high level logic turns off segments
user manual pg 28.
*/
module display (clk, ones, tens, hundreds, thousands, HEX0, HEX1, HEX2, HEX3);

input clk;
input [3:0] ones, tens, hundreds, thousands;

output [6:0] HEX0, HEX1, HEX2, HEX3;

reg [6:0] HEX0 = 7'b1000000; // default set to zero
reg [6:0] HEX1 = 7'b1000000;
reg [6:0] HEX2 = 7'b1000000;
reg [6:0] HEX3 = 7'b1000000;

always @(posedge clk)
    begin
        case(ones)
            4'b0000: HEX0 <= 7'b1000000;//0
            4'b0001: HEX0 <= 7'b1111001;//1
            4'b0010: HEX0 <= 7'b0100100;//2
            4'b0011: HEX0 <= 7'b0110000;//3
            4'b0100: HEX0 <= 7'b0011001;//4
            4'b0101: HEX0 <= 7'b0010010;//5
            4'b0110: HEX0 <= 7'b0000010;//6
            4'b0111: HEX0 <= 7'b1111000;//7
            4'b1000: HEX0 <= 7'b0000000;//8
            4'b1001: HEX0 <= 7'b0011000;//9
        endcase
    end

always @(posedge clk)
    begin
        case(tens)
            4'b0000: HEX1 <= 7'b1000000;//0
            4'b0001: HEX1 <= 7'b1111001;//1
            4'b0010: HEX1 <= 7'b0100100;//2
            4'b0011: HEX1 <= 7'b0110000;//3
            4'b0100: HEX1 <= 7'b0011001;//4
            4'b0101: HEX1 <= 7'b0010010;//5
            4'b0110: HEX1 <= 7'b0000010;//6
            4'b0111: HEX1 <= 7'b1111000;//7
            4'b1000: HEX1 <= 7'b0000000;//8
            4'b1001: HEX1 <= 7'b0011000;//9
        endcase
    end

always @(posedge clk)
    begin
        case(hundreds)
            4'b0000: HEX2 <= 7'b1000000;//0
            4'b0001: HEX2 <= 7'b1111001;//1
            4'b0010: HEX2 <= 7'b0100100;//2
            4'b0011: HEX2 <= 7'b0110000;//3
            4'b0100: HEX2 <= 7'b0011001;//4
            4'b0101: HEX2 <= 7'b0010010;//5
            4'b0110: HEX2 <= 7'b0000010;//6
            4'b0111: HEX2 <= 7'b1111000;//7
            4'b1000: HEX2 <= 7'b0000000;//8
            4'b1001: HEX2 <= 7'b0011000;//9
        endcase
    end

always @(posedge clk)
    begin
        case(thousands)
            4'b0000: HEX3 <= 7'b1000000;//0
            4'b0001: HEX3 <= 7'b1111001;//1
            4'b0010: HEX3 <= 7'b0100100;//2
            4'b0011: HEX3 <= 7'b0110000;//3
            4'b0100: HEX3 <= 7'b0011001;//4
            4'b0101: HEX3 <= 7'b0010010;//5
            4'b0110: HEX3 <= 7'b0000010;//6
            4'b0111: HEX3 <= 7'b1111000;//7
            4'b1000: HEX3 <= 7'b0000000;//8
            4'b1001: HEX3 <= 7'b0011000;//9
        endcase
    end



endmodule