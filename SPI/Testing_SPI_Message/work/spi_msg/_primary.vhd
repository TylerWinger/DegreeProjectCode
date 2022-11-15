library verilog;
use verilog.vl_types.all;
entity spi_msg is
    generic(
        NR_RWREGS       : integer := 4;
        NR_ROREGS       : integer := 12
    );
    port(
        clk50MHz        : in     vl_logic;
        SCLK            : in     vl_logic;
        MOSI            : in     vl_logic;
        MISO            : out    vl_logic;
        SS              : in     vl_logic;
        LED             : out    vl_logic_vector(1 downto 0);
        clkLocked       : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NR_RWREGS : constant is 1;
    attribute mti_svvh_generic_type of NR_ROREGS : constant is 1;
end spi_msg;
