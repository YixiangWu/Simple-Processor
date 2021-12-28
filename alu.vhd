-- 8-bit alu with addition and subtraction
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity alu is
    port(AddOrSub   : in    std_logic;  -- '0' for addtion and '1' for subtraction
         A, B       : in    std_logic_vector(7 downto 0);
         Result     : out   std_logic_vector(7 downto 0));
end entity alu;

architecture behavior of alu is

begin

    process(AddOrSub, A, B)
    begin
        if AddOrSub = '0' then
            Result <= A + B;
        else
            Result <= A - B;
        end if;
    end process;

end architecture behavior;