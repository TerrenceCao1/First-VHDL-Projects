library ieee;
use ieee.std_logic_1164.all;


entity and_gate_test_bench is
end and_gate_test_bench;


architecture test of and_gate_test_bench is
	component and_gate
	port (
		input_1		: in std_logic;
		input_2		: in std_logic;
		and_result	: out std_logic
	);
	end component;
	
	signal input1,input2,output :std_logic;
begin
	gate_and: and_gate port map(input_1 => input1, input_2 => input2, and_result => output);
	
	process begin
	input1 <= 'X';
	input2 <= 'X';
	wait for 1 ns;
	
	input1 <= '0';
	input2 <= '0';
	wait for 1 ns;
	
	input1 <= '0';
	input2 <= '1';
	wait for 1 ns;
	
	input1 <= '1';
	input2 <= '0';
	wait for 1 ns;
	
	input1 <= '1';
	input2 <= '1';
	wait for 1 ns;
	
	assert false report "Executed Testbench";
	wait;
	end process;
end test;