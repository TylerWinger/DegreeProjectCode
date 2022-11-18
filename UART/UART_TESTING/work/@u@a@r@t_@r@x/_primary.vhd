library verilog;
use verilog.vl_types.all;
entity UART_RX is
    generic(
        CLKS_PER_BIT    : integer := 217
    );
    port(
        i_Rst_L         : in     vl_logic;
        i_Clock         : in     vl_logic;
        i_RX_Serial     : in     vl_logic;
        o_RX_DV         : out    vl_logic;
        o_RX_Byte       : out    vl_logic_vector(7 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLKS_PER_BIT : constant is 1;
end UART_RX;
