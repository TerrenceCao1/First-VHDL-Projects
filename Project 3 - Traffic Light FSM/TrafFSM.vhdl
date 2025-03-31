library IEEE;
use IEEE.std_logic_1164.all;


entity FSM is
	port(
		i_CLK	: in std_logic; --FPGA Clock
		i_Reset	: in std_logic; --Reset Button
		i_T_a	: in std_logic; --Sensor A
		i_T_b	: in std_logic;	--Sensor B
		
		o_La	: out std_logic_vector(1 downto 0); --light A
		o_Lb	: out std_logic_vector(1 downto 0) --light B
		--for Lights: 00 = Green, 01 = Yellow, 10 = Red
		);
end FSM;

architecture behavior of FSM is 
	signal clk_enable_counter :	integer := 0; --dividing 1Mhz clock down to .2hz
	signal clk_enabled		  : std_logic := '0'; --enabled clock signal
	
	type t_state is (A, B, C, D);
	--A: La green, Lb red
	--B: La yellow, Lb red 
	--C: La red, Lb green
	--D: La red, Lb yellow 
	signal state, n_state	: t_state; --current and next state
	
	begin
	
	--getting signal generator going
	process(i_CLK) begin
		if(rising_edge(i_CLK)) then
			clk_enable_counter <= clk_enable_counter + 1;
			if(clk_enable_counter = 4999999) then --when the counter gets to 5000000 (1mhz/.2hz) pulse the enabled clk
				clk_enabled <= '1';
				clk_enable_counter <= 0;
			else
				clk_enabled <= '0';
			end if;
		end if;
	end process;
	
	--actually doing the FSM:
	process(i_CLK, i_Reset) begin
		if (i_Reset = '1') then
			state <= A;
		end if;

		case state is
			when A => 
				if (i_T_a = '0') then
					state <= n_state;
				end if;
			when B => 
				state <= n_state;
			when C => 
				if (i_T_b = '0') then
					state <= n_state;
				end if;
			when D => 
				state <= n_state;
			when others => 
				state <= A;
		end case;
	end process;
	
	--state ouputs and logic
	process(state) begin
		case state is
			when A => 
				n_state <= B;
				o_La <= "00";
				o_Lb <= "10";
			when B => 
				n_state <= C;
				o_La <= "01";
				o_Lb <= "10";
			when C => 
				n_state <= D;
				o_La <= "10";
				o_Lb <= "00";
			when D => 
				n_state <= A;
				o_La <= "10";
				o_Lb <= "01";
			when others => 
				n_state <= A;
				o_La <= "00";
				o_Lb <= "10";
		end case;
	end process;
		
end architecture;