library verilog;
use verilog.vl_types.all;
entity signal_gen is
    port(
        clk             : in     vl_logic;
        clk_100         : in     vl_logic;
        clk_200         : in     vl_logic;
        enable          : out    vl_logic;
        out_1           : out    vl_logic;
        out_2           : out    vl_logic;
        start           : in     vl_logic
    );
end signal_gen;
