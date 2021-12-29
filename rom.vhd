-- rom
library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity rom is
    generic(MemFileName     : string;
            MemDepth        : integer;   -- amount of words stored in total
            AddrBits        : integer;   -- required bits to store all the words
            WordWidth       : integer);  -- bits in each words
    port(Clock      : in    std_logic;
         Address    : in    std_logic_vector(AddrBits - 1 downto 0);
         Word       : out   std_logic_vector(WordWidth - 1 downto 0));
end entity rom;

architecture behavior of rom is

    type RomType is array(MemDepth - 1 downto 0) of std_logic_vector(WordWidth - 1 downto 0);
    signal Memory : RomType;
    attribute ram_init_file : string;
    attribute ram_init_file of Memory : signal is MemFileName;

begin

    process(Clock, Address)
    begin
        if rising_edge(Clock) then
            Word <= Memory(to_integer(unsigned(Address)));
        end if;
    end process;

end architecture behavior;