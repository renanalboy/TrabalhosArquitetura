library verilog;
use verilog.vl_types.all;
entity trin is
    generic(
        n               : integer := 8
    );
    port(
        Y               : in     vl_logic_vector;
        E               : in     vl_logic;
        F               : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of n : constant is 1;
end trin;
