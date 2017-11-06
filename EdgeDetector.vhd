library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EdgeDetector is
	Port (
		clock    : in  STD_LOGIC;
		signalIn : in  STD_LOGIC;
		output   : out STD_LOGIC
	);
end EdgeDetector;

architecture arch of EdgeDetector is
	signal signal_d : STD_LOGIC;
begin
	process(clock)
	begin
		if rising_edge(clock) then
			signal_d <= signalIn;
		end if;
	end process;
	output <= (not signal_d) and signalIn;
end arch;
