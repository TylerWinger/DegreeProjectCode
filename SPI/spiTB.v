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
          mosi_q,
          miso_q,
          miso_d,
          mosi_d,
          ss_d,
          ss_q;
    wire [7:0] dout, data_d, data_q;
    reg  [7:0] din = 8'hff;

    integer i = 0;

    //Instantiate UUT spiSlave
    spiSlave UUT(
        .clk(clk),
        .rst(rst),
        .ss(ss),
        .ss_d(ss_d),
        .ss_q(ss_q),
        .mosi(mosi),
        .miso(miso),
        .sck(sck),
        .done(done),
        .din(din),
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
        ss = 1;
        #2
        ss = 0;
    end

    always @(posedge clk) begin
        sck <= !sck;
    end
    always @(negedge sck) begin
        // if (i < 10) begin
        //     mosi <= !mosi;
        //     i <= i + 1;
        // end
        // else ss = 1;
        mosi <= !mosi;
    end



endmodule