-- counter
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity counter is
    generic(AddrBits    : integer);
    port(Clock, Reset   : in        std_logic;
         DOut           : buffer    std_logic_vector(AddrBits - 1 downto 0));
end entity counter;

architecture behavior of counter is

begin

    process(Clock, Reset)
    begin
        if Reset = '0' then
            DOut <= (others => '0');
        elsif rising_edge(Clock) then
            DOut <= DOut + '1';
        end if;
    end process;

end architecture behavior;