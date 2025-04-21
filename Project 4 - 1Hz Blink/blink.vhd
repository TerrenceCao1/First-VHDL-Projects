library IEEE; use IEEE.std_logic_1164.all;

entity blink is 
    port(
        i_CLK   : in std_logic;
        o_LED   : out std_logic
    );

end blink;

architecture arch of blink is
--clock enable going from 100mHz to 1Hz 
    signal enable_clock_count   : integer := 0;
    signal enabled_clock    : std_logic := '0';

    begin 
    --counting up to 999 for the enabled clock 
    process(i_CLK) begin
        if(rising_edge(i_CLK)) then
            enable_clock_count <= enable_clock_count + 1;
            if(enable_clock_count = 99999999) then
                enabled_clock <= not enabled_clock;
                enable_clock_count <= 0;
            end if;
        end if;
    end process;

    process(i_CLK) begin
        if(enabled_clock = '1') then
            o_LED <= enabled_clock;
        end if;
    end process;

end architecture;
