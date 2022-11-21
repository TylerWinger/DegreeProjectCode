library verilog;
use verilog.vl_types.all;
entity impl_top_tb is
    generic(
        CLK_HZ          : integer := 50000000;
        BIT_RATE        : integer := 9600;
        PAYLOAD_BITS    : integer := 8
    );
    port(
        clk             : in     vl_logic;
        sw_0            : in     vl_logic;
        uart_rxd        : in     vl_logic;
        uart_txd        : out    vl_logic;
        led             : out    vl_logic_vector(7 downto 0);
        uart_rx_valid   : out    vl_logic;
        uart_rx_en      : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_HZ : constant is 1;
    attribute mti_svvh_generic_type of BIT_RATE : constant is 1;
    attribute mti_svvh_generic_type of PAYLOAD_BITS : constant is 1;
end impl_top_tb;
