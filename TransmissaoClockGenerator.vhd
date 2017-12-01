library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
 
entity TransmissaoClockGenerator is
	generic(
	      -- M: integer := 41667     -- modulo do contador real
			M: integer := 32     -- modulo do contador waveform
	   );
	port (
		clk, reset: in std_logic;
		clock_out, subClockRunning : out std_logic);
end TransmissaoClockGenerator;
 
architecture arch of TransmissaoClockGenerator is
	signal count: integer := 0;
	signal tick : std_logic := '0';
	signal running : std_logic := '1';
begin
 
process(clk,reset)
begin
	if(reset = '1') then
		count <= 0;
		tick <= '0';
		running <= '1';
	elsif(rising_edge(clk)) then
		count <= count+1;
		tick <= '0';

		if (running = '1' and count = M) then
			tick <= '1';
			count <= 0;
		end if;
	end if;
end process;
 
	clock_out <= running and tick;
	subClockRunning <= running;
end arch;