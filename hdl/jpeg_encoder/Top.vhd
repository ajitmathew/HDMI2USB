LIBRARY IEEE;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;		 
USE ieee.std_logic_unsigned.all;

entity top is
port(
		clk: in std_logic;
		clk1: in std_logic;
		led: out std_logic_vector(7 downto 0);
		rst: in std_logic
);
end top;



architecture rtl of top is
signal cnt1,cnt3: integer range 0 to 1000050;
signal cnt2,cnt4,cnt5: integer range 0 to 200;
signal cnt_en: std_logic;

begin

process(clk,rst)
begin
	if rising_edge(clk) then
		if rst='1' then
			cnt1<=0;
			cnt2<=0;
			cnt_en<='1';
		else
			cnt1<=cnt1+1;
			if cnt1=1000000 then
				cnt2<=cnt2+1;
				cnt1<=0;
				if cnt2=99 then
					cnt_en<=not(cnt_en);
				end if;
				if cnt2=100 then
					cnt1<=0;
					cnt2<=0;
				end if;
			end if;
		end if;
	end if;
end process;

process(clk1,rst,clk)
begin
		if rst='1' then
			cnt3<=0;
			cnt4<=0;
		else
			if cnt2=100 then
				if rising_edge(clk) then
					cnt3<=0;
				end if;
			else
				if cnt_en='1' and rising_edge(clk1) then
					cnt3<=cnt3+1;
				end if;
			end if;
		end if;
		
end process;


cnt5<=cnt3;
process(cnt_en)
begin
	if falling_edge(cnt_en) then
		if cnt5<10 then
			led<="00000000";
		elsif cnt5<15 then
			led<="00000001";
		elsif cnt5<20 then
			led<="00000010";
		elsif cnt5<25 then
			led<="00000100";
		elsif cnt5<35 then
			led<="00001000";
		elsif cnt5<40 then
			led<="00010000";
		elsif cnt5<55 then
			led<="00100000";
		elsif cnt5<100 then
			led<="01000000";
		else
			led<="10000000";
		end if;
	end if;
end process;
end rtl;