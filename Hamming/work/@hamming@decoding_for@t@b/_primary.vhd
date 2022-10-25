library verilog;
use verilog.vl_types.all;
entity HammingDecoding_forTB is
    port(
        channelWord     : in     vl_logic_vector(15 downto 0);
        clk             : in     vl_logic;
        dataOut         : out    vl_logic_vector(10 downto 0)
    );
end HammingDecoding_forTB;
