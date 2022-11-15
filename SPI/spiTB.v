`timescale 100ms/100ms

module spiTB ();
    reg clk`1;
    //reg [7:0] din = 8'b0;
    //reg [7:0] dout = 8'b1;
    reg rst = 1,
        ss = 1,
        sck = 0,
        mosi = 0;
    wire 
          miso,
          done,
          din,
          mosi_q,
          miso_q,
          miso_d,
          mosi_d,
          ss_d;
    wire [7:0] dout, data_d, data_q;

    //Instantiate UUT spiSlave
    spiSlave UUT(
        .clk(clk),
        .rst(rst),
        .ss(ss),
        .mosi(mosi),
        .miso(miso),
        .sck(sck),
        .done(done),
        .din(8'hff),
        .dout(dout),
        .mosi_d(mosi_d),
        .mosi_q(mosi_q),
        .data_d(data_d),
        .data_q(data_q)
    );

    always begin
        clk = 1'b1;
        #0.5;
        clk = 1'b0;
        #0.5;
    end

    initial begin
        #1;
        rst = 0;
        ss = 0;
        #1;
    end

    always @(posedge clk) begin
        sck <= !sck;
        mosi <= ! mosi;
    end



endmodule