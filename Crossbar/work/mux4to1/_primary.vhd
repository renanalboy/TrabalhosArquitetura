library verilog;
use verilog.vl_types.all;
entity mux4to1 is
    port(
        w0              : in     vl_logic_vector(7 downto 0);
        w1              : in     vl_logic_vector(7 downto 0);
        w2              : in     vl_logic_vector(7 downto 0);
        w3              : in     vl_logic_vector(7 downto 0);
        S               : in     vl_logic_vector(1 to 2);
        f               : out    vl_logic_vector(7 downto 0)
    );
end mux4to1;
