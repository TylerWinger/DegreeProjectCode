module encodingDecodingTB;
    reg [35:0] messageOut = 0;
    reg [3:0] message [8:0];
    reg clk;
    reg encodeMessage = 0;
    reg decodeMessage = 0;
    reg [3:0] galoisField [14:0];
    reg [59:0] recievedWordIn;
    reg [3:0] recievedWord [14:0];
    reg [3:0] errorWord [14:0];
    reg [59:0] errorPacked;
    wire [59:0] encodedMessage;
    wire encoderBusy;
    wire [35:0] messageRecievedIn;
    reg [3:0] messageRecieved [8:0];

    integer i;

    encodingContV2 encodingContV2Inst (
        .message(messageOut),
        .encodedMessage(encodedMessage),
        .encodeMessage(encodeMessage),
        .encoderBusy(encoderBusy)
    );
    
    decodingCont decodingInst(
      .recievedWordIn(recievedWordIn),
      .decodeMessage(decodeMessage),
      .decoderBusy(decoderBusy),
      .messageRecieved(messageRecievedIn)
    );

    task outputMessage1; //alpha^11*X
      begin
        message[0] = galoisField[6];
        message[1] = galoisField[9];
        message[2] = galoisField[1];
        message[3] = galoisField[9];
        message[4] = galoisField[2];
        message[5] = galoisField[0];
        message[6] = galoisField[5];
        message[7] = galoisField[12];
        message[8] = galoisField[7];

      //Pack message
      for (i = 0; i <= 14; i = i + 1) begin
        messageOut[4*i +: 4] = message[i];
      end
      end
    endtask


    task addError;
      begin
      	 errorWord[0] = 0;
        errorWord[1] = 0;
        errorWord[2] = 0;
        errorWord[3] = 4'b0011;
        errorWord[4] = 0;
        errorWord[5] = 0;
        errorWord[6] = 4'b0101;
        errorWord[7] = 1;
        errorWord[8] = 0;
        errorWord[9] = 0;
        errorWord[10] = 0;
        errorWord[11] = 4'b1010;
        errorWord[12] = 0;
        errorWord[13] = 0;
        errorWord[14] = 0;
        
      //Pack errorWord
      for (i = 0; i <= 14; i = i + 1) begin
        errorPacked[4*i +: 4] = errorWord[i];
      end

        recievedWordIn = encodedMessage ^ errorPacked;
        for (i = 0; i <= 14 ;i = i + 1) begin
          recievedWord[i] = recievedWordIn[4*i +: 4];
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
      if (!encoderBusy) begin
        outputMessage1;
        encodeMessage = ~encodeMessage;
        #1;

        //$stop;
      end  
      if (!decoderBusy) begin
        addError;
        decodeMessage = ~decodeMessage;
        #1;
      end  
      for (i = 0; i <= 14 ;i = i + 1) begin
        messageRecieved[i] = messageRecievedIn[4*i +: 4];
     	end
     	$stop;
    end
endmodule

