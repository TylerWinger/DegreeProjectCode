
`timescale 1 ns/1 ns
// to run the full simulation simulate for 10us
module error_counter_tb ; 

reg clk, enable, reset, in_1 ;
wire [3:0] count;

 error_counter uut_error_counter(
    .clk(clk), .reset(reset), .enable(enable), .in_1(in_1), .count(count)
 );

initial // sets all to 0
	begin 
	clk = 1'b0 ;
	enable = 0 ;
	reset = 0 ;
    in_1 = 0;
	#50 enable = 1 ;
	#100 in_1 = 1;
    end 

always // counter selector
	begin
	enable = 1 ;
	#200 
	in_1 = 1 ;
	#200 
	enable = 0 ;
	#200 
	reset = 1 ;
	#200
	reset = 0 ;
    #200
    enable = 1 ;
    #200
    in_1 = 0 ;
    #200
    enable = 0;
    #200
    reset = 1;
    #200
    reset = 0;
	end   

always // 50 MHz clock signal 
	begin
	#10 clk = ~clk ;
	end
	
endmodule