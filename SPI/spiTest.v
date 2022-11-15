
module spiTest (
        input clk,
    input ss,
    input mosi,
    input sck,
    output miso,
    output reg [7:0] LEDR,
    output reg [1:0] LEDG,
    input rst
);
    wire [7:0] dout;
    wire [7:0] din;

    //Instantiate UUT spiSlave
    spiSlave UUT(
        .clk(clk),
        .rst(rst),
        .ss(ss),
        .mosi(mosi),
        .miso(miso),
        .sck(sck),
        .dout(dout),
        .din(din)
    );

assign dout = din;



always @(posedge clk) begin
    if (rst) begin
        LEDG[0] <= rst;
		if (mosi == 1) begin
            LEDG[1] <= 1'b1;
        end
        LEDR[0] <= (din[0])?1'b1:1'b0;
        LEDR[1] <= (din[1])?1'b1:1'b0;
        LEDR[2] <= (din[2])?1'b1:1'b0;
        LEDR[3] <= (din[3])?1'b1:1'b0;
        LEDR[4] <= (din[4])?1'b1:1'b0;
        LEDR[5] <= (din[5])?1'b1:1'b0;
        LEDR[6] <= (din[6])?1'b1:1'b0;
        LEDR[7] <= (din[7])?1'b1:1'b0;
    end
    else begin
        LEDR[0] <= 1'b0;
        LEDR[1] <= 1'b0;
		  LEDR[2] <= 1'b0;
        LEDR[3] <= 1'b0;
        LEDR[4] <= 1'b0;
        LEDR[5] <= 1'b0;
        LEDR[6] <= 1'b0;
        LEDR[7] <= 1'b0;
        LEDG[0] <= 1'b0;
		  LEDG[1] <= 1'b0;
        
    end

        // if (din == 8'b11111110) begin
        //     LED[0] <= 1'b1;
		// 	end
        // if (spi_dout == 8'b1111110) begin
        //     LED[1] <= 1'b1;
        // end

        // if (rst) begin
		// 	LED[2] <= 1'b1;
        // end


end

endmodule