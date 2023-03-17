/*
 This module generates a 100kHz clock off a 50MHz clock signal
*/
module clk_gen_100khz (clk, clk_100);

input clk;

output clk_100;

reg [10:0] count =11'b0;
reg clk_100 =0;

// ------ Design implementation -----

// Counter
always @(posedge clk)
begin
    if (count >= 250)
    begin
        count = 0;
        clk_100 <= ~clk_100;
    end
   if (count <250) 
	begin
    count <= count + 1'b1;
	end
end


endmodule