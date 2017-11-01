library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ResultCalculator is
	port(
		clock: in std_logic;
		playerOneCards: in std_logic_vector(59 downto 0);
		playerTwoCards: in std_logic_vector(59 downto 0);
		result: out integer;
			-- 0 -> game continues
			-- 1 -> player 1 won
			-- 2 -> player 2 won
			-- 3 -> both players lost
		gameFinished: out std_logic;
		debugPlayerOneCardsSum: out integer;
		debugPlayerTwoCardsSum: out integer
	);
end ResultCalculator;

architecture arch of ResultCalculator is
	signal playerOneStillHasCards: std_logic;
	signal playerTwoStillHasCards: std_logic;
	signal playerOneCardsSum: integer;
	signal playerTwoCardsSum: integer;
	signal base: integer;
	signal counter: integer := 0;
begin
	
	process (clock, playerOneCards, playerTwoCards)
	begin
		if (rising_edge(clock)) then
			playerOneCardsSum <= to_integer(unsigned(playerOneCards(5 downto 2))) + to_integer(unsigned(playerOneCards(11 downto 8))) + to_integer(unsigned(playerOneCards(17 downto 14))) + to_integer(unsigned(playerOneCards(23 downto 20)));
			playerTwoCardsSum <= to_integer(unsigned(playerTwoCards(5 downto 2))) + to_integer(unsigned(playerTwoCards(11 downto 8))) + to_integer(unsigned(playerTwoCards(17 downto 14))) + to_integer(unsigned(playerTwoCards(23 downto 20)));
			
		end if;
	end process;

	debugPlayerOneCardsSum <= playerOneCardsSum;
	debugPlayerTwoCardsSum <= playerTwoCardsSum;

end arch;