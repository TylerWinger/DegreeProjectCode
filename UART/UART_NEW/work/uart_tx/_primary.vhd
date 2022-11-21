library verilog;
use verilog.vl_types.all;
entity uart_tx is
    generic(
        BIT_RATE        : integer := 9600;
        CLK_HZ          : integer := 50000000;
        PAYLOAD_BITS    : integer := 8;
        STOP_BITS       : integer := 1
    );
    port(
        clk             : in     vl_logic;
        resetn          : in     vl_logic;
        uart_txd        : out    vl_logic;
        uart_tx_busy    : out    vl_logic;
        uart_tx_en      : in     vl_logic;
        uart_tx_data    : in     vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of BIT_RATE : constant is 1;
    attribute mti_svvh_generic_type of CLK_HZ : constant is 1;
    attribute mti_svvh_generic_type of PAYLOAD_BITS : constant is 1;
    attribute mti_svvh_generic_type of STOP_BITS : constant is 1;
end uart_tx;
