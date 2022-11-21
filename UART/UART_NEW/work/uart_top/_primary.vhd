library verilog;
use verilog.vl_types.all;
entity uart_top is
    port(
        clk             : in     vl_logic;
        RX              : in     vl_logic;
        TX              : out    vl_logic
    );
end uart_top;
