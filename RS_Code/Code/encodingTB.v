`timescale 1ns/1ps //time unit = 20ns, precision = 200ps


module encodingTB;
    reg [35:0] message = 0;
    reg clk;
    reg encodeMessage = 0;
    wire [59:0] codeWordVector;
    wire encoderBusy;
    integer i;

    encodingCont encodingContInst (
        .message(message),
        .clk(clk),
        .codeWordVector(codeWordVector),
        .encoderBusy(encoderBusy),
        .encodeMessage(encodeMessage)
    );
    task outputMessage;
      begin
        message[7] = 1'b1;
        message[6] = 1'b1;
        message[5] = 1'b1;
        message[4] = 1'b0;
      end
    endtask



    initial clk = 0;
    always #10 clk = ~clk; //50MHz clk

    initial begin
        outputMessage;
        encodeMessage = 1;
    end
endmodule

