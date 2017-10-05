library verilog;
use verilog.vl_types.all;
entity shiftr is
    generic(
        m               : integer := 2
    );
    port(
        Resetn          : in     vl_logic;
        w               : in     vl_logic;
        Clock           : in     vl_logic;
        S               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of m : constant is 1;
end shiftr;
