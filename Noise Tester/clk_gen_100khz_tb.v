
`timescale 1 ns/1 ns
// to run the full simulation simulate for 10us
module clk_gen_100khz_tb; 

reg clk;
wire clk_100;
wire [17:0] count;

 clk_gen_100khz uut_clk_gen_100khz(
	.clk(clk), .clk_100(clk_100), .count(count)
 );

initial // sets all to 0
	begin 
	clk = 0 ;
    end 

always // 50 MHz clock signal 
	begin
	#10 clk = ~clk ;
	end
	
endmodule