/*
 This module exicutes the XOR function on the two inputs
 and outputs the result
*/
module X_OR (in_1, in_2, out_1);

input in_1;
input in_2;

output out_1;

// ------ Design implementation -----

// XOR Gate
assign out_1 = in_1 ^ in_2;

endmodule