library verilog;
use verilog.vl_types.all;
entity spi_byte is
    port(
        clk50Mhz        : in     vl_logic;
        SCLK            : in     vl_logic;
        MOSI            : in     vl_logic;
        MISO            : out    vl_logic;
        SS              : in     vl_logic;
        LED             : out    vl_logic_vector(1 downto 0);
        clkLocked       : out    vl_logic
    );
end spi_byte;
