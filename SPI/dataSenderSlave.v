

module dataSenderSlave (
    input   clk,
            rst,
            mosi,
            sck,
            [7:0] din,
    output  miso,
            [7:0] dout
);
reg [7:0] dataIn, dataOut;
reg [2:0] bit_ct;

always @(posedge sck) begin
    dataIn <= {din[6:0],mosi}; //read data input and shift
end

always @(negedge sck) begin
    miso <= dataOut[7]; //output MSB

end


endmodule