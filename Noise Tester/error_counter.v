/*
 This module counts the number of errors by counting
 the output of the XOR gate
*/
module error_counter (clk, reset, enable, in_1, count);

input clk;
input in_1; //signal from XOR gate, this is the errors to count
input reset;
input enable;

output [9:0] count;

reg [9:0] count =0;

// ------ Design implementation -----

always @(posedge clk )
begin
    if (reset)
    begin
		count <= 0;
    end
    if (enable & in_1 )
    begin
		count <= count + 1'b1;
    end
end

endmodule