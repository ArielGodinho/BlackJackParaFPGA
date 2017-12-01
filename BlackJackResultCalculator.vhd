library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity BlackJackResultCalculator is
	port(
		clock          : in  std_logic;
		playerOneCards : in  std_logic_vector(59 downto 0);
		playerTwoCards : in  std_logic_vector(59 downto 0);
		player0Stopped: in boolean;
        player1Stopped: in boolean;
		result         : out integer;
		-- 0 -> game continues
		-- 1 -> player 1 won
		-- 2 -> player 2 won
		-- 3 -> both players lost
		gameFinished           : out std_logic;
		debugPlayerOneCardsSum : out integer;
		debugPlayerTwoCardsSum : out integer
	);
end BlackJackResultCalculator;

architecture arch of BlackJackResultCalculator is
	signal playerOneStillHasCards : std_logic;
	signal playerTwoStillHasCards : std_logic;
	signal playerOneCardsSum      : integer;
	signal playerTwoCardsSum      : integer;
	signal base                   : integer;
	signal counter                : integer := 0;
begin
	
	process (clock, playerOneCards, playerTwoCards)
	begin
		if (rising_edge(clock)) then
			playerOneCardsSum <= 0;
			playerTwoCardsSum <= 0;

			playerOneCardsSum <= to_integer(unsigned(playerOneCards(5 downto 2))) + to_integer(unsigned(playerOneCards(11 downto 8))) + to_integer(unsigned(playerOneCards(17 downto 14))) + to_integer(unsigned(playerOneCards(23 downto 20))) + to_integer(unsigned(playerOneCards(29 downto 26))) + to_integer(unsigned(playerOneCards(35 downto 32))) + to_integer(unsigned(playerOneCards(41 downto 38))) + to_integer(unsigned(playerOneCards(47 downto 44))) + to_integer(unsigned(playerOneCards(53 downto 50))) + to_integer(unsigned(playerOneCards(59 downto 56)));
			playerTwoCardsSum <= to_integer(unsigned(playerTwoCards(5 downto 2))) + to_integer(unsigned(playerTwoCards(11 downto 8))) + to_integer(unsigned(playerTwoCards(17 downto 14))) + to_integer(unsigned(playerTwoCards(23 downto 20))) + to_integer(unsigned(playerTwoCards(29 downto 26))) + to_integer(unsigned(playerTwoCards(35 downto 32))) + to_integer(unsigned(playerTwoCards(41 downto 38))) + to_integer(unsigned(playerTwoCards(47 downto 44))) + to_integer(unsigned(playerTwoCards(53 downto 50))) + to_integer(unsigned(playerTwoCards(59 downto 56)));
			
			if (playerOneCardsSum <= 21 and playerTwoCardsSum <= 21) then
				if (playerOneCardsSum < playerTwoCardsSum) then
					result <= 2;
				elsif (playerOneCardsSum > playerTwoCardsSum) then
					result <= 1;
				else
					result <= 0;
				end if;
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

			if (player0Stopped and player1Stopped) then
				gameFinished <= '1';
			end if;
			
		end if;
	end process;
	
	debugPlayerOneCardsSum <= playerOneCardsSum;
	debugPlayerTwoCardsSum <= playerTwoCardsSum;
	
end arch;