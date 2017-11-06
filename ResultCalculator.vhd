library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity ResultCalculator is
	port(
		clock          : in  std_logic;
		playerOneCards : in  std_logic_vector(59 downto 0);
		playerTwoCards : in  std_logic_vector(59 downto 0);
		result         : out integer;
		-- 0 -> game continues
		-- 1 -> player 1 won
		-- 2 -> player 2 won
		-- 3 -> both players lost
		gameFinished           : out std_logic;
		debugPlayerOneCardsSum : out integer;
		debugPlayerTwoCardsSum : out integer
	);
end ResultCalculator;

architecture arch of ResultCalculator is
	signal playerOneStillHasCards : std_logic;
	signal playerTwoStillHasCards : std_logic;
	signal playerOneCardsSum      : integer;
	signal playerTwoCardsSum      : integer;
	signal base                   : integer;
	signal counter                : integer := 0;
	
	function getCorrectValue (cardValue : std_logic_vector(3 downto 0)) return integer is
		variable cardValueInt               : integer := 0;
	begin
		cardValueInt := to_integer(unsigned(cardValue));
		if (cardValueInt > 10) then
			return 10;
		else
			return cardValueInt;
		end if;
	end getCorrectValue;
	
begin
	
	process (clock, playerOneCards, playerTwoCards)
	begin
		if (rising_edge(clock)) then
			playerOneCardsSum <= 0;
			playerTwoCardsSum <= 0;

			playerOneCardsSum <= getCorrectValue(playerOneCards(5 downto 2)) + getCorrectValue(playerOneCards(11 downto 8)) + getCorrectValue(playerOneCards(17 downto 14)) + getCorrectValue(playerOneCards(23 downto 20)) + getCorrectValue(playerOneCards(29 downto 26)) + getCorrectValue(playerOneCards(35 downto 32)) + getCorrectValue(playerOneCards(41 downto 38)) + getCorrectValue(playerOneCards(47 downto 44)) + getCorrectValue(playerOneCards(53 downto 50)) + getCorrectValue(playerOneCards(59 downto 56));
			playerTwoCardsSum <= getCorrectValue(playerTwoCards(5 downto 2)) + getCorrectValue(playerTwoCards(11 downto 8)) + getCorrectValue(playerTwoCards(17 downto 14)) + getCorrectValue(playerTwoCards(23 downto 20)) + getCorrectValue(playerTwoCards(29 downto 26)) + getCorrectValue(playerTwoCards(35 downto 32)) + getCorrectValue(playerTwoCards(41 downto 38)) + getCorrectValue(playerTwoCards(47 downto 44)) + getCorrectValue(playerTwoCards(53 downto 50)) + getCorrectValue(playerTwoCards(59 downto 56));
			
			if (playerOneCardsSum <= 21 and playerTwoCardsSum <= 21) then
				result <= 0;
				gameFinished <= '0';
			elsif (playerOneCardsSum <= 21 and playerTwoCardsSum > 21) then
				result <= 1;
				gameFinished <= '1';
			elsif (playerOneCardsSum > 21 and playerTwoCardsSum <= 21) then
				result <= 2;
				gameFinished <= '1';
			elsif (playerOneCardsSum > 21 and playerTwoCardsSum > 21) then
				result <= 3;
				gameFinished <= '1';
			end if;
			
		end if;
	end process;
	
	debugPlayerOneCardsSum <= playerOneCardsSum;
	debugPlayerTwoCardsSum <= playerTwoCardsSum;
	
end arch;