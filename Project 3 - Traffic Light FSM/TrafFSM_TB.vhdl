library IEEE;
use IEEE.std_logic_1164.all;

entity testbench is
end testbench;

architecture test of testbench is
	component FSM is
		port(
		i_CLK	: in std_logic; --FPGA Clock
		i_Reset	: in std_logic; --Reset Button
		i_T_a	: in std_logic; --Sensor A
		i_T_b	: in std_logic;	--Sensor B
		
		o_La	: out std_logic_vector(1 downto 0); --light A
		o_Lb	: out std_logic_vector(1 downto 0) --light B
		--for Lights: 00 = Green, 01 = Yellow, 10 = Red
		);
	end component;
	
	--signal declaration
	signal clk_sig	: std_logic := '0';
		constant clk_period	: time := 100 ns; --simulating a 10mhz clock (meaning that each pulse of the clock enable will be .5s)
	signal sig_i_Reset	: std_logic := '1';
	signal sig_i_T_a	: std_logic := '0';
	signal sig_i_T_b	: std_logic := '0';
	signal sig_o_La		: std_logic_vector(1 downto 0);
	signal sig_o_Lb		: std_logic_vector(1 downto 0);
	
	begin
	FSM_instance: component FSM
		port map (
			i_CLK	=> clk_sig,
			i_Reset	=> sig_i_Reset,
			i_T_a	=> sig_i_T_a,
			i_T_b	=> sig_i_T_b,
			o_La	=> sig_o_La,
			o_Lb	=> sig_o_Lb
			);
	
	process begin --clock process
		clk_sig <= not clk_sig;
		wait for clk_period / 2;
	end process;
	
	process begin 
		wait for 200 ns;
		sig_i_Reset <= '0';
		wait for 2000 ns; --checks that the FSM just loops continuously if there's no traffic 
		sig_i_T_a <= '1'; 
		wait for 600 ns; --checks that FSM stays at state A until the traffic is gone
		sig_i_T_a <= '0';
		sig_i_T_b <= '1';
		wait for 600 ns; --chceks that FSM stays at state C until the traffic is gone
		sig_i_T_b <= '0';
		wait for 300 ns;
		
		assert false report "simulation ended" 
		severity failure;
	end process;
end test;