library ieee;
use ieee.std_logic_1164.all;

entity ResultCalculator is
	port(
		clock: in std_logic;
		playerOneCards: in std_logic_vector(59 downto 0);
		playerTwoCards: in std_logic_vector(59 downto 0);
		result: out integer
	);
end ResultCalculator;

architecture arch of ResultCalculator is

	signal 

begin

end arch;