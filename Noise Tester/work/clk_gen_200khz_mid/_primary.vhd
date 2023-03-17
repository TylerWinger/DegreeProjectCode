library verilog;
use verilog.vl_types.all;
entity clk_gen_200khz_mid is
    port(
        clk             : in     vl_logic;
        clk_200_mid     : out    vl_logic
    );
end clk_gen_200khz_mid;
