library ieee;
use ieee.math_real.all;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity main is
    generic(MemFileName     : string    := "rom.mif";
            MemDepth        : integer   := 16);
    port(MemClock, PCClock, Reset, Run, SysClock    : in    std_logic;
         Done                                       : out   std_logic;
         BusWires, Hex0, Hex1                       : out   std_logic_vector(7 downto 0));
end entity main;

architecture behavior of main is

    component debounce is
        port(SysClock, Button   : in    std_logic;
             Result             : out   std_logic);
    end component debounce;
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
             Hex0, Hex1         : out       std_logic_vector(7 downto 0);
             Done               : buffer    std_logic;
             BusWires           : buffer    std_logic_vector(7 downto 0));
    end component proc;

    -- AddrBits = ceil(log2(MemDepth))
    constant AddrBits : integer := integer(ceil(log2(real(MemDepth))));

    signal Address : std_logic_vector(AddrBits - 1 downto 0);
    signal Word : std_logic_vector(7 downto 0);

    -- debounced clocks
    signal NewMemClock, NewPCClock : std_logic;

begin

    DBMEM: debounce
        port map(SysClock => SysClock, Button => MemClock, Result => NewMemClock);
    DBPC: debounce
        port map(SysClock => SysClock, Button => PCClock, Result => NewPCClock);

    -- a counter that iterates through the addresses to execute instructions in order
    CT: counter
        generic map(AddrBits => AddrBits)
        port map(Clock => NewMemClock, Reset => Reset, DOut => Address);

    MEM: rom
        generic map(MemFileName => MemFileName, MemDepth => MemDepth, 
                    AddrBits => AddrBits, WordWidth => 8)
        port map(Clock => NewMemClock, Address => Address, Word => Word);
    PC: proc
        port map(Clock => NewPCClock, Reset => Reset, Run => Run, DIn => Word,
                 Done => Done, Hex0 => Hex0, Hex1 => Hex1, BusWires => BusWires);

end architecture behavior;