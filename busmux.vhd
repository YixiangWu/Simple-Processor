-- multiplexer that transfers specified data to the BusWires
library ieee;
use ieee.std_logic_1164.all;

entity busmux is
    port(DInSelect, GSelect                         : in    std_logic;
         RSelect                                    : in    std_logic_vector(7 downto 0);
         DIn, G, R0, R1, R2, R3, R4, R5, R6, R7     : in    std_logic_vector(7 downto 0);
         BusWires                                   : out   std_logic_vector(7 downto 0));
end entity busmux;

architecture behavior of busmux is

    signal Sel : std_logic_vector(9 downto 0);

begin

    Sel <= DInSelect & GSelect & RSelect;

    process(Sel, DIn, G, R0, R1, R2, R3, R4, R5, R6, R7)
    begin
        if Sel = "0000000001" then
            BusWires <= R0;
        elsif Sel = "0000000010" then
            BusWires <= R1;
        elsif Sel = "0000000100" then
            BusWires <= R2;
        elsif Sel = "0000001000" then
            BusWires <= R3;
        elsif Sel = "0000010000" then
            BusWires <= R4;
        elsif Sel = "0000100000" then
            BusWires <= R5;
        elsif Sel = "0001000000" then
            BusWires <= R6;
        elsif Sel = "0010000000" then
            BusWires <= R7;
        elsif Sel = "0100000000" then
            BusWires <= G;
        else
            BusWires <= DIn;
        end if;
    end process;

end architecture behavior;