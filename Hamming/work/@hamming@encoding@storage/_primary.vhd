library verilog;
use verilog.vl_types.all;
entity HammingEncodingStorage is
    port(
        clk             : in     vl_logic;
        dataIn          : in     vl_logic_vector(10 downto 0);
        codeWordOut     : out    vl_logic_vector(15 downto 0)
    );
end HammingEncodingStorage;
