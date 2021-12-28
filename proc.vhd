-- processor
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;

entity proc is
    port(Clock, Reset, Run  : in        std_logic;
         DIn                : in        std_logic_vector(7 downto 0);
        --  State              : out       std_logic_vector(3 downto 0);
         Done               : out       std_logic;
         BusWires           : buffer    std_logic_vector(7 downto 0));
end entity proc;

architecture behavior of proc is

    component regn is
        port(Clock, En  : in    std_logic;
             DIn        : in    std_logic_vector(7 downto 0);
             DOut       : out   std_logic_vector(7 downto 0));
    end component regn;
    component busmux is
        port(DInSelect, GSelect                         : in    std_logic;
             RSelect                                    : in    std_logic_vector(7 downto 0);
             DIn, G, R0, R1, R2, R3, R4, R5, R6, R7     : in    std_logic_vector(7 downto 0);
             BusWires                                   : out   std_logic_vector(7 downto 0));
    end component busmux;
    component alu is
        port(AddOrSub   : in    std_logic;
             A, B       : in    std_logic_vector(7 downto 0);
             Result     : out   std_logic_vector(7 downto 0));
    end component alu;
    component controlunit is
        port(Clock, Reset, Run                                      : in    std_logic;
             IR                                                     : in    std_logic_vector(7 downto 0);
             Done, AddOrSub, DInSelect, GSelect, AEn, GEn, IREn     : out   std_logic;
            --  State                                                  : out   std_logic(3 downto 0);
             REn, RSelect                                           : out   std_logic_vector(7 downto 0));
    end component controlunit;

    signal AddOrSub : std_logic;

    -- registers' enables
    signal AEn, GEn, IREn : std_logic;
    signal REn : std_logic_vector(7 downto 0);

    -- registers' DOuts
    type Registers is array(7 downto 0) of std_logic_vector(7 downto 0);
    signal AOut, AluOut, GOut, IROut : std_logic_vector(7 downto 0);
    signal ROut : Registers;

    -- MUX's selects
    signal DInSelect, GSelect : std_logic;
    signal RSelect : std_logic_vector(7 downto 0);

begin

    R0: regn
        port map(Clock => Clock, En => REn(0), DIn => BusWires, DOut => ROut(0));
    R1: regn
        port map(Clock => Clock, En => REn(1), DIn => BusWires, DOut => ROut(1));
    R2: regn
        port map(Clock => Clock, En => REn(2), DIn => BusWires, DOut => ROut(2));
    R3: regn
        port map(Clock => Clock, En => REn(3), DIn => BusWires, DOut => ROut(3));
    R4: regn
        port map(Clock => Clock, En => REn(4), DIn => BusWires, DOut => ROut(4));
    R5: regn
        port map(Clock => Clock, En => REn(5), DIn => BusWires, DOut => ROut(5));
    R6: regn
        port map(Clock => Clock, En => REn(6), DIn => BusWires, DOut => ROut(6));
    R7: regn
        port map(Clock => Clock, En => REn(7), DIn => BusWires, DOut => ROut(7));
    RA: regn
        port map(Clock => Clock, En => AEn, DIn => BusWires, DOut => AOut);
    RG: regn
        port map(Clock => Clock, En => GEn, DIn => AluOut, DOut => GOut);
    RIR: regn
        port map(Clock => Clock, En => IREn, DIn => DIn, DOut => IROut);

    MUX: busmux
        port map(DInSelect => DInSelect, GSelect => GSelect, RSelect => RSelect,
                 DIn => DIn, G => GOut, R0 => ROut(0), R1 => ROut(1),
                 R2 => ROut(2), R3 => ROut(3), R4 => ROut(4), R5 => ROut(5),
                 R6 => ROut(6), R7 => ROut(7), BusWires => BusWires);

    AS: alu
        port map(AddOrSub => AddOrSub, A => AOut, B => BusWires, Result => AluOut);

    CU: controlunit
        port map(Clock => Clock, Reset => Reset, Run => Run, IR => IROut,
                 Done => Done, AddOrSub => AddOrSub, DInSelect => DInSelect,
                 GSelect => GSelect, AEn => AEn, GEn => GEn, IREn => IREn,
                --  State => State,
                 REn => REn, RSelect => RSelect);

end architecture behavior;