library verilog;
use verilog.vl_types.all;
entity decodingCont is
    port(
        recievedMessageIn: in     vl_logic_vector(59 downto 0);
        decodeMessage   : in     vl_logic;
        messageOut      : out    vl_logic_vector(35 downto 0);
        decoderBusy     : out    vl_logic
    );
end decodingCont;
