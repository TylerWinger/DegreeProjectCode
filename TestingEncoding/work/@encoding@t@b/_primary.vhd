library verilog;
use verilog.vl_types.all;
entity EncodingTB is
    generic(
        CLK_HZ          : integer := 50000000;
        CLK_P           : vl_notype;
        BIT_RATE        : integer := 9600;
        BIT_P           : vl_notype
    );
    port(
        clk             : out    vl_logic;
        uart_rxd        : out    vl_logic;
        reset           : out    vl_logic;
        dataInput       : out    vl_logic_vector(63 downto 0);
        codeWord        : out    vl_logic_vector(71 downto 0);
        dataIn64Done    : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_HZ : constant is 1;
    attribute mti_svvh_generic_type of CLK_P : constant is 3;
    attribute mti_svvh_generic_type of BIT_RATE : constant is 1;
    attribute mti_svvh_generic_type of BIT_P : constant is 3;
end EncodingTB;
