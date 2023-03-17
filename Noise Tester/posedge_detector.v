/*
 This module will be used to sync the start and reset buttons to 
 the clk signal
*/
module posedge_detector(clk, in, out, reset);

input clk ;
input in ;
input reset ;
output out ;

reg delay_sig =0;

always @(posedge clk) 
	begin
		if (reset)
		begin
		delay_sig <= 0 ;		
		end
		else
		begin
		delay_sig <= in ;
		end
	end

assign out = in & ~delay_sig;

endmodule 