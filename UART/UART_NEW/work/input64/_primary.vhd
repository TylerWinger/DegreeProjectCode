library verilog;
use verilog.vl_types.all;
entity input64 is
    generic(
        IDLE            : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        ACTIVE          : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        FINISH          : vl_logic_vector(0 to 1) := (Hi1, Hi0)
    );
    port(
        clk             : in     vl_logic;
        uart_rx_pin     : in     vl_logic;
        reset           : in     vl_logic;
        fsm_state       : out    vl_logic;
        byteCnt         : out    vl_logic_vector(3 downto 0);
        dataInput       : out    vl_logic_vector(63 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of IDLE : constant is 1;
    attribute mti_svvh_generic_type of ACTIVE : constant is 1;
    attribute mti_svvh_generic_type of FINISH : constant is 1;
end input64;
