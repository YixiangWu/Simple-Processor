-- present hexadecimal number on a 7-segment display
library ieee;
use ieee.std_logic_1164.all;

entity hexdisplay is
    port(Clock, En      : in    std_logic;
         DIn            : in    std_logic_vector(3 downto 0);
         Hex            : out   std_logic_vector(7 downto 0));
end entity hexdisplay;

architecture behavior of hexdisplay is

begin

    process(Clock, En, DIn)
    begin
        if rising_edge(Clock) then
            if En = '1' then
                case DIn is
                    when "0000" => Hex <= "11000000";  -- 0
                    when "0001" => Hex <= "11111001";  -- 1
                    when "0010" => Hex <= "10100100";  -- 2
                    when "0011" => Hex <= "10110000";  -- 3
                    when "0100" => Hex <= "10011001";  -- 4
                    when "0101" => Hex <= "10010010";  -- 5
                    when "0110" => Hex <= "10000010";  -- 6
                    when "0111" => Hex <= "11111000";  -- 7
                    when "1000" => Hex <= "10000000";  -- 8
                    when "1001" => Hex <= "10010000";  -- 9
                    when "1010" => Hex <= "10001000";  -- A
                    when "1011" => Hex <= "10000011";  -- b
                    when "1100" => Hex <= "11000110";  -- C
                    when "1101" => Hex <= "10100001";  -- d
                    when "1110" => Hex <= "10000110";  -- E
                    when "1111" => Hex <= "10001110";  -- F
                    when others => Hex <= "10111111";  -- -
                end case;
            else
                Hex <= "10111111";
            end if;
        end if;
    end process;

end architecture behavior;