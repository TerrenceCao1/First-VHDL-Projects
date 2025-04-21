library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.math_real.all;

entity count is 
    port(
        i_CLK   :   in std_logic; --100mHz (we wanna get down to 1hz)
        i_Reset :   in std_logic;
        o_SSD   :   out std_logic_vector (1 downto 0); --SSD select 00 = furthest right, 01 = 2nd to right and so on
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
    --both clock enable processes 
    process(i_CLK) begin
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

    --Counting up every second
    process(i_CLK) begin
        if (en_clock_1hz = '1') then
            whole_num <= whole_num + 1;
            s_left <= (whole_num / 1000) mod 10;
            s_midleft <= (whole_num / 100) mod 10;
            s_midright <= (whole_num / 10) mod 10;
            s_right <= whole_num mod 10;
        end if;
    end process;

    --Display num
    process(i_CLK) begin
        if (en_clock_15hz = '1') then 
            case state is 
                when A =>
                    o_SSD <= "00";
                    n_state <= B;
                    --FOR LATER: add the change the "s_current_digit" depending on state
                when B =>
                    o_SSD <= "01";
                    n_state <= C;
                when C =>
                    o_SSD <= "10";
                    n_state <= D;
                when D =>
                    o_SSD <= "11";
                    n_state <= A;
            end case;
        end if;
    end process;

    --FOR LATER: another process for displaying the "s_current_digit" on 
end architecture;