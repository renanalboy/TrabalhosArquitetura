library verilog;
use verilog.vl_types.all;
entity swap is
    port(
        Data            : in     vl_logic_vector(7 downto 0);
        Resetn          : in     vl_logic;
        w               : in     vl_logic;
        Clock           : in     vl_logic;
        Extern          : in     vl_logic;
        RinExt          : in     vl_logic_vector(1 to 4)
    );
end swap;
