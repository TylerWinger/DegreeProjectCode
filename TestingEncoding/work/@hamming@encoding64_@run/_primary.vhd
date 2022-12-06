library verilog;
use verilog.vl_types.all;
entity HammingEncoding64_Run is
    port(
        clk             : in     vl_logic;
        dataIn          : in     vl_logic_vector(63 downto 0);
        codeWord        : out    vl_logic_vector(71 downto 0)
    );
end HammingEncoding64_Run;
