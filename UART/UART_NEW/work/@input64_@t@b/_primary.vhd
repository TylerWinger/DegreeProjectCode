library verilog;
use verilog.vl_types.all;
entity Input64_TB is
    generic(
        CLK_HZ          : integer := 50000000;
        CLK_P           : vl_notype
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of CLK_HZ : constant is 1;
    attribute mti_svvh_generic_type of CLK_P : constant is 3;
end Input64_TB;
