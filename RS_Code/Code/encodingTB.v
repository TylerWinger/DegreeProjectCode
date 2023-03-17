`timescale 1ns/1ps //time unit = 20ns, precision = 200ps


module encodingTB;
    reg [35:0] message = 0;
    reg clk;
    reg encodeMessage = 0;
    wire [59:0] encodedMessage;
    wire encoderBusy;
    integer i;

    encodingContV2 encodingContV2Inst (
        .message(message),
        .encodedMessage(encodedMessage),
        .encoderBusy(encoderBusy),
        .encodeMessage(encodeMessage)

    );
    task outputMessage2; //alpha^11*X
      begin
        message[7] = 1'b1;
        message[6] = 1'b1;
        message[5] = 1'b1;
        message[4] = 1'b0;
        message[3] = 1'b0;
        message[2] = 1'b0;
        message[1] = 1'b0;
        message[0] = 1'b0;
      end
    endtask
        task outputMessage1; //alpha^3*X+alpha^10
      begin
        message[7] = 1'b1;
        message[6] = 1'b0;
        message[5] = 1'b0;
        message[4] = 1'b0;
        message[3] = 1'b0;
        message[2] = 1'b1;
        message[1] = 1'b1;
        message[0] = 1'b1;
      end
    endtask



    initial clk = 0;
    always #10 clk = ~clk; //50MHz clk

    initial begin
      #1;
      if (!encoderBusy) begin
        outputMessage1;
        encodeMessage = ~encodeMessage;
        #1;
        $stop;
      end  
      if (!encoderBusy) begin
        outputMessage2;
        encodeMessage = ~encodeMessage;
        #1;
      end  
      $stop;  
    end
endmodule

