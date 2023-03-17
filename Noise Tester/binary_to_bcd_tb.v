
`timescale 1 ns/1 ns
// to run the full simulation simulate for 10us
module binary_to_bcd_tb;

reg clk =0;
reg [9:0] value =0;

wire [3:0] ones;
wire [3:0] tens;
wire [3:0] hundreds;
wire [3:0] thousands;

binary_to_bcd uutbinary_to_bcd(
    clk, value, ones, tens, hundreds, thousands
);

initial
begin
    #1000 value =3;
    #1000 value =33;
    #1000 value =333;
    #1000 value =1011;
    #1000 value =1000;
end


always // 50 MHz clock signal 
	begin
	#10 clk = ~clk ;
	end

endmodule