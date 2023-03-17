library verilog;
use verilog.vl_types.all;
entity error_counter is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        enable          : in     vl_logic;
        in_1            : in     vl_logic;
        count           : out    vl_logic_vector(9 downto 0)
    );
end error_counter;
