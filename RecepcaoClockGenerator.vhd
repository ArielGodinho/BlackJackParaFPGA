library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity RecepcaoClockGenerator is
	generic(
		M: integer := 50000000/1200     -- modulo do contador real
		--M : integer := 32 -- modulo do contador waveform
	);
	port (
		clk, reset                 : in  std_logic;
		clock_out, subClockRunning : out std_logic);
end RecepcaoClockGenerator;

architecture arch of RecepcaoClockGenerator is
	signal count     : integer   := 0;
	signal halfClock : std_logic := '1';
	signal tick      : std_logic := '0';
	signal running   : std_logic := '0';
begin
	
	process(clk,reset)
	begin
		if(reset = '1') then
			count     <= 0;
			halfClock <= '1';
			tick      <= '0';
			running   <= '0';
		elsif(rising_edge(clk)) then
			count <= count+1;
			tick  <= '0';
			
			if (halfClock = '1' and count = M/2) then
				running   <= '1';
				tick      <= '1';
				halfClock <= '0';
				count     <= 0;
			end if;
			
			if (running = '1' and count = M) then
				tick  <= '1';
				count <= 0;
			end if;
		end if;
	end process;
	
	clock_out       <= running and tick;
	subClockRunning <= running;
end arch;