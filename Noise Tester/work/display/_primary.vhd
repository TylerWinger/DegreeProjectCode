library verilog;
use verilog.vl_types.all;
entity display is
    port(
        clk             : in     vl_logic;
        ones            : in     vl_logic_vector(3 downto 0);
        tens            : in     vl_logic_vector(3 downto 0);
        hundreds        : in     vl_logic_vector(3 downto 0);
        thousands       : in     vl_logic_vector(3 downto 0);
        HEX0            : out    vl_logic_vector(6 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0)
    );
end display;
