library verilog;
use verilog.vl_types.all;
entity binary_to_bcd is
    port(
        clk             : in     vl_logic;
        value           : in     vl_logic_vector(9 downto 0);
        ones            : out    vl_logic_vector(3 downto 0);
        tens            : out    vl_logic_vector(3 downto 0);
        hundreds        : out    vl_logic_vector(3 downto 0);
        thousands       : out    vl_logic_vector(3 downto 0)
    );
end binary_to_bcd;
