library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture test of testbench is
    component count is 
        port(
            i_CLK       : in std_logic; --100mHz (we wanna get down to 1hz)
            i_Reset     : in std_logic;
            o_SSD       : out std_logic_vector (3 downto 0); --SSD select 00 = furthest right, 01 = 2nd to right and so on
            o_LED_Map   : out std_logic_vector (6 downto 0) --which specific segments are outputted to the o_SSD
        );
    end component;

    signal s_i_CLK      : std_logic := '0';
        constant clk_period : time := 10 ns;
    signal s_i_Reset    : std_logic := '0';
    signal s_o_SSD      : std_logic_vector (3 downto 0);
    signal s_o_LED_Map  : std_logic_vector (6 downto 0);

    --clock enable signals
    signal s_enCLK_1hz    : std_logic := '0';
    signal s_enCLK_15hz   : std_logic := '0';

    begin
    count_instance: component count
        port map (
            i_CLK => s_i_CLK,
            i_Reset => s_i_Reset,
            o_SSD => s_o_SSD,
            o_LED_Map => s_o_LED_Map
        );
    
    process begin
        s_i_CLK <= not s_i_CLK;
        wait for clk_period / 2;
    end process;

    process(s_i_CLK) 
        variable counter1hz    : integer := 0;
        variable counter15hz   : integer := 0;
    begin
        if rising_edge(s_i_CLK) then
            if counter1hz = 99999 then
                s_enCLK_1hz <= not s_enCLK_1hz;
            end if;
            if counter15hz = 4166 then
                s_enCLK_15hz <= not s_enCLK_15hz;
            end if;
            counter1hz := counter1hz + 1;
            counter15hz := counter15hz + 1;
        end if;
    end process;
    
    process begin
        s_i_Reset <= '1';
        wait for 20 ns;
        s_i_Reset <= '0';
        wait for 5 ms;

        assert false report "simulation ended" 
		severity failure;
    end process;


end architecture;