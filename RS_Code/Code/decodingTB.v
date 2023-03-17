`timescale 1ns/1ps  
  
  module decodingTB;
    reg [3:0] recievedWord [14:0];
    reg [59:0] recievedWordIn;
    reg decodeMessage = 0;
    reg [3:0] galoisField [14:0];
    wire decoderBusy;
    wire [35:0] messageRecieved;

    integer i;

    decodingCont decodingInst(
      .recievedWordIn(recievedWordIn),
      .decodeMessage(decodeMessage),
      .decoderBusy(decoderBusy),
      .messageRecieved(messageRecieved)
    );

  task outputrecievedWord1;
    begin
      recievedWord[0] = galoisField[12];
      recievedWord[1] = galoisField[8];
      recievedWord[2] = galoisField[3];//error
      recievedWord[3] = galoisField[4];
      recievedWord[4] = galoisField[10];
      recievedWord[5] = galoisField[8];
      recievedWord[6] = 0;
      recievedWord[7] = galoisField[11];
      recievedWord[8] = 0; //galoisField[0];//error
      recievedWord[9] = 0;
      recievedWord[10] = galoisField[3];//error
      recievedWord[11] = 0;
      recievedWord[12] = 0;
      recievedWord[13] = 0;
      recievedWord[14] = 0;

      //Pack recieved message
      for (i = 0; i <= 14; i = i + 1) begin
        recievedWordIn[4*i +: 4] = recievedWord[i];
      end
    end
  endtask

    task outputrecievedWord2;
    begin
      recievedWord[0] = galoisField[12];
      recievedWord[1] = galoisField[8];
      recievedWord[2] = galoisField[3]; //error
      recievedWord[3] = galoisField[4];
      recievedWord[4] = galoisField[10];
      recievedWord[5] = galoisField[8];
      recievedWord[6] = 0;
      recievedWord[7] = galoisField[11];
      recievedWord[8] = galoisField[0]; //error
      recievedWord[9] = galoisField[1]; //error
      recievedWord[10] = 0;
      recievedWord[11] = 0;
      recievedWord[12] = 0;
      recievedWord[13] = 0;
      recievedWord[14] = 0;

      //Pack recieved message
      for (i = 0; i <= 14; i = i + 1) begin
        recievedWordIn[4*i +: 4] = recievedWord[i];
      end
    end
  endtask


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

    #1;
    if(!decoderBusy)begin
      outputrecievedWord1;
      decodeMessage = 1;
      #1;
      decodeMessage = 0;
      #1;
    end
    $stop;
    if(!decoderBusy)begin
      outputrecievedWord2;
      decodeMessage = 1;
      #1;
      decodeMessage = 0;
      #1;
    end
    $stop;
  end
endmodule