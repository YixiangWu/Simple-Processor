-- control unit
library ieee;
use ieee.std_logic_1164.all;

entity controlunit is
    port(Clock, Reset, Run                                      : in    std_logic;
         IR                                                     : in    std_logic_vector(7 downto 0);
         Done, AddOrSub, DInSelect, GSelect, AEn, GEn, IREn     : out   std_logic;
        --  State                                                  : out   std_logic(3 downto 0);
         REn, RSelect                                           : out   std_logic_vector(7 downto 0));
end entity controlunit;

architecture behavior of controlunit is

    component decoder is
        port(DIn    : in    std_logic_vector(2 downto 0);
             DOut   : out   std_logic_vector(7 downto 0));
    end component decoder;

    -- FSM States
    type StateTpye is (Idle, Move, Calculate, MoveAgain);
    signal PresentState, NextState : StateTpye;

    signal I : std_logic_vector(1 downto 0);       -- 2-bit operation instruction code
    signal Rx, Ry : std_logic_vector(7 downto 0);  -- one-hot register instruction codes

begin

    -- handle the 8-bit instruction in IR
    -- IR : II XXX YYY
    -- II = 2-bit operation instruction,
    -- XXX = 3-bit registerX instruction .
    -- YYY = 3-bit registerY instruction

    -- get the 2-bit operation instruction
    I <= IR(7 downto 6);
    -- convert 3-bit register instructions to one-hot register instructions
    DecoderX: decoder
        port map(DIn => IR(5 downto 3), DOut => Rx);
    DecoderY: decoder
        port map(DIn => IR(2 downto 0), DOut => Ry);

    -- finite state machine

    StateTransition: process(Clock, Reset, NextState)
    begin
        if Reset = '0' then
            PresentState <= Idle;
        elsif rising_edge(Clock) then
            PresentState <= NextState;
        end if;
    end process StateTransition;

    NextStateLogic: process(Run, PresentState)
    begin
        case PresentState is
            when Idle => 
                if Run = '0' then
                    NextState <= Idle;
                    -- State <= "0000";
                else
                    NextState <= Move;
                    -- State <= "0001";
                end if;
            when Move =>
                -- if the instruction involve using the alu
                if I = "10" or I = "11" then
                    NextState <= Calculate;
                else
                    NextState <= Idle;
                end if;
                -- State <= "0010";
            when Calculate =>
                NextState <= MoveAgain;
                -- State <= "0100";
            when others =>
                NextState <= Idle;
                -- State <= "0000";
        end case;
    end process NextStateLogic;

    ExecuteInstruction: process(PresentState, I, Rx, Ry)
    -- Instruction Table
    --     II: Instruction    XXX, YYY     : Detail Instruction
    --     00: mv              Rx, Ry      : Rx <- Ry
    --     01: mvi             Rx, #D      : Rx <- DIn
    --     10: add             Rx, Ry      : Rx <- Rx + Ry
    --     11: sub             Rx, Ry      : Rx <- Rx - Ry
    begin
        -- reset values
        Done <= '0';
        AddOrSub <= '0';
        DInSelect <= '0';
        GSelect <= '0';
        IREn <= '0';
        AEn <= '0';
        GEn <= '0';
        REn <= "00000000";
        RSelect <= "00000000";
        
        case PresentState is
            when Idle =>
                -- store DIn in IR
                IREn <= '1';
            when Move =>
                case I is
                    when "00" =>  -- Rx <- Ry
                        -- transfer the data from Ry to Rx
                        RSelect <= Ry;
                        REn <= Rx;
                        Done <= '1';
                    when "01" =>  -- Rx <- DIn
                        -- transfer the data from DIn to Rx
                        DInSelect <= '1';
                        REn <= Rx;
                        Done <= '1';
                    when "10" =>  -- Rx <- Rx + Ry
                        -- transfer the data from Rx to the register, A, and
                        -- wait for the data from Ry to perform the addition
                        RSelect <= Rx;
                        AEn <= '1';
                    when "11" =>  -- Rx <- Rx - Ry
                        -- transfer the data from Rx to the register, A, and
                        -- wait for the data from Ry to perform the subtraction
                        RSelect <= Rx;
                        AEn <= '1';
                    when others =>
                        Done <= '0';
                end case;
            when Calculate =>
                case I is
                    when "10" =>  -- Rx <- Rx + Ry
                        -- transfer the data from Ry to the alu, and
                        -- store the sum of Rx and Ry in the register, G
                        RSelect <= Ry;
                        GEn <= '1';
                    when "11" =>  -- Rx <- Rx - Ry
                        -- transfer the data from Ry to the alu, and
                        -- store the difference between Rx and Ry in the register, G
                        RSelect <= Ry;
                        AddOrSub <= '1';  -- switch to subtract mode
                        GEn <= '1';
                    when others =>
                        Done <= '0';
                end case;
            when MoveAgain =>
                case I is
                    when "10" =>  -- Rx <- Rx + Ry
                        -- transfer the data from G to Rx
                        GSelect <= '1';
                        REn <= Rx;
                        Done <= '1';
                    when "11" =>  -- Rx <- Rx - Ry
                        -- transfer the data from G to Rx
                        GSelect <= '1';
                        REn <= Rx;
                        Done <= '1';
                    when others =>
                        Done <= '0';
                end case;
        end case;
    end process ExecuteInstruction;

end architecture behavior;


-- 3 to 8 decoder
library ieee;
use ieee.std_logic_1164.all;

entity decoder is
    port(DIn    : in    std_logic_vector(2 downto 0);
         DOut   : out   std_logic_vector(7 downto 0));
end entity decoder;

architecture behavior of decoder is

begin

    process(DIn)
    begin
        case DIn is
            when "000" => DOut <= "00000001";
            when "001" => DOut <= "00000010";
            when "010" => DOut <= "00000100";
            when "011" => DOut <= "00001000";
            when "100" => DOut <= "00010000";
            when "101" => DOut <= "00100000";
            when "110" => DOut <= "01000000";
            when "111" => DOut <= "10000000";
            when others => DOut <= "00000000";
        end case;
    end process;

end architecture behavior;