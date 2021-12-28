-- 8-bit register
library ieee;
use ieee.std_logic_1164.all;

entity regn is
    port(Clock, En  : in    std_logic;
         DIn        : in    std_logic_vector(7 downto 0);
         DOut       : out   std_logic_vector(7 downto 0));
end entity regn;

architecture behavior of regn is

begin

    process(Clock, En)
    begin
        if rising_edge(Clock) and En = '1' then
            DOut <= DIn;
        end if;
    end process;

end architecture behavior;