library verilog;
use verilog.vl_types.all;
entity sync_1bit is
    port(
        clk             : in     vl_logic;
        sync_in         : in     vl_logic;
        sync_out        : out    vl_logic
    );
end sync_1bit;
