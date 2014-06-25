library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity debug_top is
port(
	clk:in std_logic;
	rst:in std_logic;
	vsync: in std_logic;
	no_frame_read: in std_logic;
	pktend : in std_logic;
	jpg_busy : in std_logic;
	write_img: in std_logic;
	sw	: in std_logic_vector(7 downto 0);
	uart_en : out std_logic;
	uart_byte: out std_logic_vector(7 downto 0)
);
end debug_top;

architecture Behavioral of debug_top is

COMPONENT counters
	PORT(
		clk : IN std_logic;
		clk_ms : IN std_logic;
		clk_1hz : IN std_logic;
		rst : IN std_logic;
		vsync : IN std_logic;
		no_frame_read : IN std_logic;
		write_img : IN std_logic;
		pktend : IN std_logic;
		jpg_busy : IN std_logic;          
		proc_time : OUT std_logic_vector(7 downto 0);
		frame_write_time : OUT std_logic_vector(7 downto 0);
		frame_rate : OUT std_logic_vector(7 downto 0);
		in_frame_rate : OUT std_logic_vector(7 downto 0);
		frame_drop_cnt : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
		
	signal prescaler : unsigned (27 downto 0);
	signal prescaler1 : unsigned (17 downto 0);
	signal clk_ms : std_logic;
	signal clk_1hz   : std_logic;
	signal proc_time  : std_logic_vector(7 downto 0);
	signal frame_write_time : std_logic_vector(7 downto 0);
	signal frame_rate : std_logic_vector(7 downto 0);
	signal in_frame_rate: std_logic_vector(7 downto 0);
	signal frame_drop_cnt : std_logic_vector(7 downto 0);
	signal switch_case : std_logic_vector(2 downto 0);
	signal send, send_q: std_logic;

begin
	clk_gen:process(clk,rst)
	begin
		if rst='1' then
			clk_1hz<='0';
			prescaler<=(others=>'0');
		elsif rising_edge(clk) then
			if prescaler=X"2FAF080" then
				prescaler <= (others=>'0');
				clk_1hz   <= not clk_1hz;	
			else
				prescaler <= prescaler + "1";
			end if;
			if prescaler1=X"C350" then
				prescaler1<=(others=>'0');
				clk_ms	<= not clk_ms;
			else
				prescaler1 <= prescaler1 + "1"; 
			end if;
		end if;
	end process clk_gen;
	
	switch_case<=sw(2 downto 0);
	
	output_selector: process(switch_case, in_frame_rate,frame_rate,frame_write_time,proc_time,frame_drop_cnt)
	begin
			case switch_case is
				when "000" => uart_byte <= in_frame_rate;
				when "001" => uart_byte <= frame_rate;
				when "010" => uart_byte <= frame_write_time;
				when "011" => uart_byte <= proc_time;
				when "100" => uart_byte <= frame_drop_cnt;
				when OTHERS => uart_byte <=X"FF";
			end case;
	end process;
	
	send<=clk_1hz;
	uart_send: process(clk,rst)
	begin
		if rst='1' then
			uart_en<='0';
		elsif rising_edge(clk) then
			uart_en<='0';
			send_q<=send;
			if send_q='0' and send='1' then
				uart_en<='1';
			end if;
		end if;
	end process;
	
	
Inst_counters: counters PORT MAP(
		clk => clk,
		clk_ms => clk_ms,
		clk_1hz => clk_1hz,
		rst => rst,
		vsync => vsync,
		no_frame_read => no_frame_read,
		write_img => write_img,
		pktend => pktend,
		jpg_busy => jpg_busy,
		proc_time => proc_time,
		frame_write_time => frame_write_time,
		frame_rate => frame_rate,
		in_frame_rate => in_frame_rate,
		frame_drop_cnt => frame_drop_cnt
	);
	
end Behavioral;

