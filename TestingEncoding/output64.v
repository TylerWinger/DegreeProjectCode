module output64 (
    input clk,
    input [71:0] codeWord ,
    input reset,
    wire uart_rx_data,
    wire uart_txd,
    wire uart_tx_en,
    wire uart_tx_busy
);
    reg [1:0] fsm_state;
    reg [3:0] byteCnt;

    //Finite state machine parameters
    parameter IDLE   = 2'b00;
    parameter ACTIVE = 2'b01;
    parameter FINISH = 2'b10;

    //Instantiation of UART TX
    uart_tx uart_tx_Inst(
        .clk(clk),
        .resetn(!reset),
        .uart_txd(uart_txd),
        .uart_tx_en(uart_tx_en),
        .uart_tx_busy(uart_tx_busy),
        .uart_tx_data(uart_tx_data)
    );

      //Finite State Machine
    always @(posedge clk or posedge reset) begin
        if (reset)
            fsm_state <= IDLE;
        else 
            case (fsm_state)
                IDLE :
                    if (send)   fsm_state <= ACTIVE;

                ACTIVE :
                    if (done)   fsm_state <= FINISH;

                FINISH :        fsm_state <= IDLE;

                default:        fsm_state <= IDLE;
            endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            byteCnt <= 4'b0;
            done <= 1'b0;
            send <= 1'b0;
        end
        else if (fsm_state == IDLE) begin
            byteCnt <= 4'b0;
            done <= 1'b0;
        end
        else if (fsm_state == ACTIVE) begin
            
        end
        else if (fsm_state == FINISH) begin
            done <= 1'b1;
            send <= 1'b0;
        end
    end

    always @(codeWord) begin
        send <= 1'b1;
    end

    always @(posedge clk ) begin
        if (fsm_state == ACTIVE)begin
            
        end
    end


endmodule