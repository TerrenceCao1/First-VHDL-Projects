library IEEE; use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture test of testbench is
    component blink is
        port(
            i_CLK   : in std_logic;
            o_LED   : out std_logic
        );
    end component;

    --signal declaration
    signal clk_sig  : std_logic := '0';
        constant clk_period : time := 1 ms; --1000hz clk 
    signal o_LED_sig    : std_logic := '0';
    
    begin 
    blink_instance: component blink
        port map (
            i_CLK => clk_sig,
            o_LED => o_LED_sig
        );
    
    process begin
        clk_sig <= not clk_sig;
        wait for clk_period / 2;
    end process;

    process begin
        wait for 5 sec;

        assert false report "simulation ended" severity failure;

    end process;
end test;