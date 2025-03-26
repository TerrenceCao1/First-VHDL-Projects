LIBRARY IEEE;
USE IEEE.Std_logic_1164.all;


entity D_Flip_Flop is 
	port (
		i_D		: in std_logic;
		i_CLK	: in std_logic;
		o_Q		: out std_logic
	);
end D_Flip_Flop;


architecture behavorial of D_Flip_Flop is
	begin 
		process(i_CLK)
		begin
			if(rising_edge(i_CLK)) then
				o_Q <= i_D;
			end if;
		end process;
	end behavorial;

