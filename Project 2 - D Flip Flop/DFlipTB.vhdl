library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is 
end testbench;

architecture test of testbench is
	component D_Flip_Flop is 
	port (
		i_D		: in std_logic;
		i_CLK	: in std_logic;
		o_Q		: out std_logic
	);
	end component;
	
	--signal declaration
	signal i_D_sig : std_logic := '0';
	signal o_Q_sig : std_logic;
	
	--make a clock signal (pulsing every ns or so)
	signal clk_sig : std_logic := '0';
	constant clk_period : time := 10 ns; 
	
	begin
	DFlip: D_Flip_Flop port map(
		i_D => i_D_sig,
		i_CLK => clk_sig,
		o_Q => o_Q_sig
		);
	
	process begin
		clk_sig <= not clk_sig;
		wait for clk_period / 2;
	end process;
	
	--change D at times that aren't synced to the clock
	process begin
		i_D_sig <= '1';
		wait for 3 ns;
		
		i_D_sig <= '0';
		wait for 8 ns;
				
		i_D_sig <= '1';
		wait for 15 ns;

		i_D_sig <= '0';
		wait for 5 ns;
		
		assert false report "Executed Testbench";
		wait;
	end process;
	
end test;