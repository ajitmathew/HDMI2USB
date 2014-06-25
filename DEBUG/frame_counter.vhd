library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.all;		 
USE ieee.std_logic_unsigned.all;


entity frame_counter is
port(
	clk: in std_logic;
	rst: in std_logic;
	vsync: in std_logic;
	frame_count: out std_logic_vector(7 downto 0)
);	
end frame_counter;

architecture Behavioral of frame_counter is
signal frame_count_s: std_logic_vector(7 downto 0);
begin
	frame_count<=frame_count_s;
	frame_counter:process(rst,vsync)
		begin
			if rst='1' then
				frame_count_s<=(others=>'0');
			elsif rising_edge(vsync) then
				frame_count_s<=frame_count_s+1;
			end if;
		end process;
	
end Behavioral;

