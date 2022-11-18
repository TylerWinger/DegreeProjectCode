library verilog;
use verilog.vl_types.all;
entity UART_TX is
    generic(
        CLKS_PER_BIT    : integer := 217
    );
    port(
        i_Rst_L         : in     vl_logic;
        i_Clock         : in     vl_logic;
        i_TX_DV         : in     vl_logic;
        i_TX_Byte       : in     vl_logic_vector(7 downto 0);
        o_TX_Active     : out    vl_logic;
        o_TX_Serial     : out    vl_logic;
        o_TX_Done       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLKS_PER_BIT : constant is 1;
end UART_TX;
