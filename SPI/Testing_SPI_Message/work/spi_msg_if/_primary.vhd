library verilog;
use verilog.vl_types.all;
entity spi_msg_if is
    generic(
        NR_RWREGS       : integer := 4;
        NR_ROREGS       : integer := 12
    );
    port(
        sysClk          : in     vl_logic;
        tx              : out    vl_logic_vector(7 downto 0);
        rx              : in     vl_logic_vector(7 downto 0);
        rxValid         : in     vl_logic;
        rwRegs          : out    vl_logic_vector;
        roRegs          : in     vl_logic_vector;
        wrRegs          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of NR_RWREGS : constant is 1;
    attribute mti_svvh_generic_type of NR_ROREGS : constant is 1;
end spi_msg_if;
