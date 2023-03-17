library verilog;
use verilog.vl_types.all;
entity clk_gen_100khz is
    port(
        clk             : in     vl_logic;
        clk_100         : out    vl_logic
    );
end clk_gen_100khz;
