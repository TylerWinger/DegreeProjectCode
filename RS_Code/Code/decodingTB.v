`timescale 1ns/1ps  
  
  module decodingTB;
    reg [3:0] recievedMessage [14:0];
    reg [59:0] recievedMessageIn;
    reg decodeMessage = 0;
    reg [3:0] galoisField [14:0];
    wire decoderBusy;
    wire [35:0] messageOut;

    integer i;

    decodingCont decodingInst(
      .recievedMessageIn(recievedMessageIn),
      .decodeMessage(decodeMessage),
      .decoderBusy(decoderBusy),
      .messageOut(messageOut)
    );

  initial begin
    
    //Establishing GF elements (alpha_i values)
    galoisField[0] = 4'b0001; //alpha^0
    galoisField[1] = 4'b0010; //alpha^1
    galoisField[2] = 4'b0100; //alpha^2
    galoisField[3] = 4'b1000; //alpha^3
    galoisField[4] = 4'b0011; //alpha^4
    galoisField[5] = 4'b0110; //alpha^5
    galoisField[6] = 4'b1100; //alpha^6
    galoisField[7] = 4'b1011; //alpha^7
    galoisField[8] = 4'b0101; //alpha^8
    galoisField[9] = 4'b1010; //alpha^9
    galoisField[10] = 4'b0111; //alpha^10
    galoisField[11] = 4'b1110; //alpha^11
    galoisField[12] = 4'b1111; //alpha^12
    galoisField[13] = 4'b1101; //alpha^13
    galoisField[14] = 4'b1001; //alpha^14
        
    recievedMessage[0] = galoisField[12];
    recievedMessage[1] = galoisField[8];
    recievedMessage[2] = galoisField[3];
    recievedMessage[3] = galoisField[4];
    recievedMessage[4] = galoisField[10];
    recievedMessage[5] = galoisField[8];
    recievedMessage[6] = 0;
    recievedMessage[7] = galoisField[11];
    recievedMessage[8] = galoisField[0];
    recievedMessage[9] = 0;
    recievedMessage[10] = 0;
    recievedMessage[11] = 0;
    recievedMessage[12] = 0;
    recievedMessage[13] = 0;
    recievedMessage[14] = 0;

    for (i = 0; i <= 14; i = i + 1) begin
      recievedMessageIn[4*i +: 4] = recievedMessage[i];
    end

    #1;
    if(!decoderBusy)begin
      decodeMessage = 1;
      #1;
      decodeMessage = 0;
      #1;
    end
    $stop;
  end


    endmodule