library verilog;
use verilog.vl_types.all;
entity spi_byte_if is
    port(
        sysClk          : in     vl_logic;
        SCLK            : in     vl_logic;
        MOSI            : in     vl_logic;
        MISO            : out    vl_logic;
        SS              : in     vl_logic;
        tx              : in     vl_logic_vector(7 downto 0);
        rx              : out    vl_logic_vector(7 downto 0);
        rxValid         : out    vl_logic
    );
end spi_byte_if;
