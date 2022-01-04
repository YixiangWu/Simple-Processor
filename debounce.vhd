-- button debouncing
library ieee;
use ieee.std_logic_1164.all;

entity debounce is
    -- CountMax = system clock frequency (Hz) * time input must remain stable (ms) / 1000
    -- CountMax = 50_000_000 * 10 / 1000
    generic(CountMax : integer := 500_000);
    port(SysClock   : in    std_logic;   -- system clock
         Button     : in    std_logic;   -- button input to be debounced
         Result     : out   std_logic);  -- debounced result
end entity debounce;

architecture behavior of debounce is

    type StateType is (Idle, Active);
    signal State : StateType := Idle;

    signal Inputs : std_logic_vector(1 downto 0);
    signal IsStableInput : std_logic;

begin

    process(SysClock)
        variable Count : integer range 0 to CountMax;
    begin
        if rising_edge(SysClock) then

            -- check for both stable active-low and stable active-high
            Inputs(0) <= Button;
            Inputs(1) <= Inputs(0);
            IsStableInput <= Inputs(0) xnor Inputs(1);

            case State is
                when Idle =>
                    if IsStableInput = '1' then
                        State <= Active;
                        Count := 0;
                    end if;
                when Active =>
                    if IsStableInput = '0' then
                        State <= Idle;
                    elsif Count < CountMax then
                        Count := Count + 1;
                    else
                        Result <= Inputs(1);
                        State <= Idle;
                    end if;
            end case;
        end if;
    end process;

end architecture behavior;