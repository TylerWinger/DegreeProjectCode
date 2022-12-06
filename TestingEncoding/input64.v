module input64 (
    input clk, //50MHz clock
    input uart_rx_pin, //Hardware pin connected to UART_RX
    input reset, //Reset pin active high
    output reg [63:0] dataInput, //8bytes of data from UART
    output reg dataIn64Done //Pulses high when dataInput is new (only in ACTIVE mode)
);
    
    wire [7:0] uart_rx_data;
    reg [1:0] fsm_state;
    reg [3:0] byteCnt; //Counting the number of byte recieved from UART
    
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