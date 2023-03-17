library verilog;
use verilog.vl_types.all;
entity encodingContV2 is
    port(
        message         : in     vl_logic_vector(35 downto 0);
        encodeMessage   : in     vl_logic;
        encodedMessage  : out    vl_logic_vector(59 downto 0);
        encoderBusy     : out    vl_logic
    );
end encodingContV2;
