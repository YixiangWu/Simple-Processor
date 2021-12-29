library ieee;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity main is
    generic(MemFileName     : string    := "rom.mif";
            MemDepth        : integer   := 16);
    port(MemClock, PCClock, Reset, Run  : in    std_logic;
         Done                           : out   std_logic;
         BusWires                       : out   std_logic_vector(7 downto 0));
end entity main;

architecture behavior of main is

    component counter is
        generic(AddrBits : integer);
        port(Clock, Reset   : in        std_logic;
             DOut           : buffer    std_logic_vector(AddrBits - 1 downto 0));
    end component counter;
    component rom is
        generic(MemFileName                     : string;
                MemDepth, AddrBits, WordWidth   : integer);
        port(Clock      : in    std_logic;
             Address    : in    std_logic_vector(AddrBits - 1 downto 0);
             Word       : out   std_logic_vector(WordWidth - 1 downto 0));
    end component rom;
    component proc is
        port(Clock, Reset, Run  : in        std_logic;
             DIn                : in        std_logic_vector(7 downto 0);
             Done               : out       std_logic;
             BusWires           : buffer    std_logic_vector(7 downto 0));
    end component proc;

    -- AddrBits = ceil(log2(MemDepth))
    constant AddrBits : integer := integer(ceil(log2(real(MemDepth))));

    signal Address : std_logic_vector(AddrBits - 1 downto 0);
    signal Word : std_logic_vector(7 downto 0);

begin

    -- a counter that iterates through the addresses to execute instructions in order
    CT: counter
        generic map(AddrBits => AddrBits)
        port map(Clock => MemClock, Reset => Reset, DOut => Address);

    MEM: rom
        generic map(MemFileName => MemFileName, MemDepth => MemDepth, 
                    AddrBits => AddrBits, WordWidth => 8)
        port map(Clock => MemClock, Address => Address, Word => Word);
    PC: proc
        port map(Clock => PCClock, Reset => Reset, Run => Run, DIn => Word,
                 Done => Done, BusWires => BusWires);

end architecture behavior;