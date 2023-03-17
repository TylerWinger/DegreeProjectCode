
module binary_to_bcd(clk, value, ones, tens, hundreds, thousands);

input clk ;
input [9:0] value; //this will only work for 1000. needs more digits for higher

output [3:0] ones;
output [3:0] tens;
output [3:0] hundreds;
output [3:0] thousands;

reg [3:0] ones =0;
reg [3:0] tens =0;
reg [3:0] hundreds =0;
reg [3:0] thousands =0;

reg [3:0] i =0;
reg [25:0] shift =0;
// temporary registers
reg [3:0] temp_ones =0;
reg [3:0] temp_tens =0;
reg [3:0] temp_hundreds =0;
reg [3:0] temp_thousands =0;

// store [9:0] old_value until [9:0] old_value changes 
reg [9:0] old_value = 10'd0;

always @(posedge clk)
	begin
	// if value changes only then go into this if statment 
		if (i==0 & (old_value != value ))
			begin
			shift = 26'd0; // initialize shift registure to 0
			// assign the current value to the old_value
			old_value = value;
			// put 8-bit counter value into lower 8bits of the shift register 
			shift[9:0] = value;
			temp_thousands = shift[25:22];
			temp_hundreds = shift[21:18];
			temp_tens = shift[17:14];
			temp_ones = shift[13:10];
			i = i+1;
			end
			
		if (i<11 & i>0)
			begin
			// check if temp ones, tens, or hundreds are greater or equal 5
			if (temp_thousands >=5) temp_thousands = temp_thousands+3;
			if (temp_hundreds >=5) temp_hundreds = temp_hundreds+3;
			if (temp_tens >=5) temp_tens = temp_tens+3;
			if (temp_ones >=5) temp_ones = temp_ones+3;
			// put hundreds tens and ones into shift register 
			shift [25:10] = {temp_thousands, temp_hundreds, temp_tens, temp_ones};
			// then shift left by 1
			shift = shift <<1;
			// now set the new values to remporary hundreds, tens, and ones again
			temp_thousands = shift[25:22];
			temp_hundreds = shift[21:18];
			temp_tens = shift[17:14];
			temp_ones = shift[13:10];
			i = i+1; // repeat until i =11
			end
			
		if (i == 11)
			begin
			i=0;
			// assign temporary values to the actual outputs after binary to BCD conversion is complete
			ones = temp_ones;
			tens = temp_tens;
			hundreds = temp_hundreds;
			thousands = temp_thousands;
			end
	end
endmodule