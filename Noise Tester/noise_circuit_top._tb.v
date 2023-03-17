
`timescale 1 ns/1 ns
// to run the full simulation simulate for 10us
module noise_test_top_tb ; 

reg clk = 0;
reg start = 0;
reg reset = 0;

wire pin_1;
wire pin_2;
wire [6:0] HEX0, HEX1, HEX2, HEX3;

 noise_test_top uut_noise_test_top(
	.clk(clk), .start(start), .reset(reset), .pin_1(pin_1), .pin_2(pin_2), .HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2), .HEX3(HEX3)
 );

initial 
    begin
        #100 start = ~start;
        #20 start = ~start;
    end

initial
begin
    #20000000 reset = ~reset;
end

always
    begin
        #5500000 start = ~start ;
    end

always // 50 MHz clock signal 
	begin
	#10 clk = ~clk ;
	end
	
endmodule

