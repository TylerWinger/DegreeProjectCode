/*
 This module generates a 100kHz clock off a 50MHz clock signal
 This clock is offset so the counter that is sampeling the output of 
 the XOR gate is dead center of the signal that is sent
*/
module clk_gen_200khz (clk, clk_200);

input clk;

output clk_200;

reg [10:0] count = 11'b0;
reg clk_200 =0;

// ------ Design implementation -----

// Counter
always @(posedge clk)
begin
    if (count >= 125)
    begin
        count = 0;
        clk_200 <= ~clk_200;
    end
   if (count <125)
	begin
	count <= count + 1'b1;
	end
end


endmodule