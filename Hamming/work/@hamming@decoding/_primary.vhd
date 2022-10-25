library verilog;
use verilog.vl_types.all;
entity HammingDecoding is
    port(
        channelWord     : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic
    );
end HammingDecoding;
