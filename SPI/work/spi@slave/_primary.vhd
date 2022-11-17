library verilog;
use verilog.vl_types.all;
entity spiSlave is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ss              : in     vl_logic;
        mosi            : in     vl_logic;
        miso            : out    vl_logic;
        sck             : in     vl_logic;
        done            : out    vl_logic;
        din             : in     vl_logic_vector(7 downto 0);
        dout            : out    vl_logic_vector(7 downto 0);
        mosi_d          : out    vl_logic;
        mosi_q          : out    vl_logic;
        data_d          : out    vl_logic_vector(7 downto 0);
        data_q          : out    vl_logic_vector(7 downto 0);
        ss_d            : out    vl_logic;
        ss_q            : out    vl_logic
    );
end spiSlave;
