
`timescale 1 ns/1 ns
// to run the full simulation simulate for 10us
module signal_gen_tb ; 

reg clk = 0;
reg clk_100 = 0;
reg start = 0;


wire [9:0]count;
wire enable;
wire out_1;
wire out_2;

 signal_gen uut_signal_gen(
	.clk(clk), .clk_100(clk_100), .enable(enable), .out_1(out_1), .out_2(out_2), .start(start), .count(count)
 );

initial begin
    #1000 start = ~start;
    #10 start = ~start;
end

always
    begin
        #3000000 start = ~start;
    end


always // 100 kHz clock signal
    begin
    #2500 clk_100 = ~clk_100 ;
    end

always // 50 MHz clock signal 
	begin
	#10 clk = ~clk ;
	end
	
endmodule