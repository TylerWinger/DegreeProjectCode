`timescale 1ns/1ns


module input64_TB (
    output reg clk,
    output reg uart_rxd,
    output reg reset ,
    wire [1:0] fsm_state,
    wire [3:0] byteCnt,
    wire [63:0] dataInput,
    wire [7:0] uart_rx_data,
    wire dataIn64Done
);
    reg [7:0] uart_DataIn [0:7];
    integer i;

    //Clock
    parameter CLK_HZ = 50000000;
    parameter CLK_P = 1000000000 / CLK_HZ;
    always begin #(CLK_P/2) assign clk = ~clk; end
    //UART bit rate
    parameter BIT_RATE = 9600;
    parameter BIT_P = (1000000000/BIT_RATE);
      
    initial begin
        reset = 1'b1;
        clk = 1'b0;
        uart_rxd = 1'b1;
        #480;
        reset = 1'b0;

        uart_DataIn[0] = 8'b10101010;
        uart_DataIn[1] = 8'b10101010;
        uart_DataIn[2] = 8'b11111111;
        uart_DataIn[3] = 8'b10101010;
        uart_DataIn[4] = 8'b10101010;
        uart_DataIn[5] = 8'b00000000;
        uart_DataIn[6] = 8'b10101010;
        uart_DataIn[7] = 8'b10101010;

        #10;

        repeat (8)begin
            send_byte(8'hAA); //activate the fsm
        end
        $display("Activate fsm")
        for (i = 0; i < 8; i = i + 1) begin
            send_byte(uart_DataIn[i]);
            $display("Sending data...");
        end
        repeat (8)begin
            send_byte(8'h55); //idle the fsm
        end  
        $display("Idle fsm");

    end

    input64 input64_Inst(
        .clk(clk),
        .uart_rx_pin(uart_rxd),
        .reset(reset),
        .fsm_state(fsm_state),
        .byteCnt(byteCnt),
        .dataInput(dataInput),
        .uart_rx_data(uart_rx_data),
        .dataIn64Done(dataIn64Done)
    );

    // Sends a single byte down the UART line.
    task send_byte;
        input [7:0] to_send;
        integer i;
        begin
            //$display("Sending byte: %d at time %d", to_send, $time);

            #BIT_P;  uart_rxd = 1'b0;
            for(i=0; i < 8; i = i+1) begin
                #BIT_P;  uart_rxd = to_send[i];

                //$display("    Bit: %d at time %d", i, $time);
            end
            #BIT_P;  uart_rxd = 1'b1;
            #1000;
        end
    endtask
endmodule

//-------------------------------------------------------------------------------------------------------

module input64 (
    input clk, //50MHz clock
    input uart_rx_pin, //Hardware pin connected to UART_RX
    input reset, //Reset pin active low
    output reg [1:0] fsm_state,
    output reg [3:0] byteCnt, //Counting the number of byte recieved from UART
    output reg [63:0] dataInput, //8bytes of data from UART
    output reg dataIn64Done, //Pulses high when dataInput is new (only in ACTIVE mode)
    wire [7:0] uart_rx_data
);

    //Finite state machine parameters
    parameter IDLE   = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter FINISH = 2'b10;

    //Instantiation of UART RX
    uart_rx #() i_uart_rx(
    .clk          (clk          ), // Top level system clock input.
    .resetn       (!reset      ), // Asynchronous active low reset.
    .uart_rxd     (uart_rx_pin  ), // UART Recieve pin.
    .uart_rx_en   (1'b1         ), // Recieve enable
    .uart_rx_break(uart_rx_break), // Did we get a BREAK message?
    .uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
    .uart_rx_data (uart_rx_data )  // The recieved data.
    );


    //Finite State Machine
    always @(posedge clk or posedge reset) begin
        if (reset)
            fsm_state <= IDLE;
        else 
            case (fsm_state)
                IDLE :
                    if (dataInput == 64'hAAAAAAAAAAAAAAAA)                    fsm_state <= ACTIVE;

                ACTIVE :
                    if (byteCnt == 4'd8 && dataInput == 64'h5555555555555555) fsm_state <= IDLE;
                    else if (byteCnt == 4'd8)                                 fsm_state <= FINISH;

                FINISH :                                                      fsm_state <= ACTIVE;

                default:                                                      fsm_state <= IDLE;
            endcase
    end

// Run everytime a byte is recieved
    always @(posedge uart_rx_valid) begin
        if (fsm_state == IDLE) begin
            dataInput <= {dataInput, uart_rx_data};
        end
        if (fsm_state == ACTIVE) begin
            if (byteCnt < 8) begin
                dataInput <= {dataInput, uart_rx_data};
                byteCnt <= byteCnt + 1'b1;
            end
        end

    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            dataIn64Done <= 1'b0;
            byteCnt <= 4'b0;
        end
        else if (fsm_state == IDLE) begin
            byteCnt <= 4'b0;
            dataIn64Done <= 1'b0;
        end
        else if (fsm_state == ACTIVE) begin
            dataIn64Done <= 1'b0;
        end        
        else if (fsm_state == FINISH) begin
            dataIn64Done <= 1'b1;
            byteCnt <= 4'b0;
        end 
    end

    always @(posedge dataIn64Done) begin
        $display("data input done");
    end

endmodule