library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

entity count is 
    port(
        i_CLK   :   in std_logic; --100mHz (we wanna get down to 1hz)
        i_Reset :   in std_logic;
        o_SSD   :   out std_logic_vector (3 downto 0); --SSD select 00 = furthest right, 01 = 2nd to right and so on
        o_LED_Map   : out std_logic_vector (6 downto 0) --which specific segments are outputted to the o_SSD
    );
end entity;

architecture arch of count is
    --clock enable 
    signal en_count_1hz   : natural := 0;
    signal en_clock_1hz   : std_logic := '0';
    signal en_count_15hz: natural := 0;
    signal en_clock_15hz: std_logic := '0'; 

    --num displayed
    signal whole_num    : natural := 0;
    signal s_left       : natural := 0;
    signal s_midleft    : natural := 0;
    signal s_midright   : natural := 0;
    signal s_right      : natural := 0;
    signal s_current_digit  : natural;

    --states for which 7SD to display
    type t_state is (A, B, C, D);
	--A: Right
	--B: MidRight 
	--C: MidLeft
	--D: Left
	signal state	: t_state := A; --current and next state
    signal n_state  : t_state;
	
    begin

    --Counting up every second
    process(i_CLK, i_Reset) begin
        if(i_Reset = '1') then
            en_clock_1hz <= '0';
            en_count_1hz <= 0;
            en_clock_15hz <= '0';
            en_count_15hz <= 0;
            whole_num <= 0;
        
        elsif (en_clock_1hz = '1') then
            whole_num <= whole_num + 1;
            s_left <= (whole_num / 1000) mod 10;
            s_midleft <= (whole_num / 100) mod 10;
            s_midright <= (whole_num / 10) mod 10;
            s_right <= whole_num mod 10;
            if (whole_num = 9999) then
                whole_num <= 0;
            end if;
        end if;
        
        --clock enable
        if(rising_edge(i_CLK)) then
            en_count_1hz <= en_count_1hz + 1;
            en_count_15hz <= en_count_15hz + 1;
            if(en_count_1hz = 99999999) then
                en_clock_1hz <= not en_clock_1hz;
            end if;
            if(en_count_15hz = 4166666) then
                en_clock_15hz <= not en_clock_15hz;
            end if;
        end if;
    end process;

    --select each digit at 15hz
    process(i_CLK) begin
        if (en_clock_15hz = '1') then 
            case state is 
                when A =>
                    o_SSD <= "0001";
                    n_state <= B;
                    s_current_digit <= s_right;
                when B =>
                    o_SSD <= "0010";
                    n_state <= C;
                    s_current_digit <= s_midright;
                when C =>
                    o_SSD <= "0100";
                    n_state <= D;
                    s_current_digit <= s_midleft;
                when D =>
                    o_SSD <= "1000";
                    n_state <= A;
                    s_current_digit <= s_left;
            end case;
            state <= n_state; --loop through all the states at 15hz
        end if;
    end process;

    --function for converting s_current_digit to SSD output
    process(i_CLK) begin
        if (en_clock_15hz = '1') then
            case s_current_digit is
                when 0 => o_LED_Map <= "0000001";
                when 1 => o_LED_Map <= "1001111";
                when 2 => o_LED_Map <= "0010010";
                when 3 => o_LED_Map <= "0000110";
                when 4 => o_LED_Map <= "1001100";
                when 5 => o_LED_Map <= "0100100";
                when 6 => o_LED_Map <= "0100000";
                when 7 => o_LED_Map <= "0001111";
                when 8 => o_LED_Map <= "0000000";
                when 9 => o_LED_Map <= "0000100";
                when others => o_LED_Map <= "1111111"; --if the current digit ends up not being any of these output nothing.
            end case;
        end if;
    end process;
                

end architecture;