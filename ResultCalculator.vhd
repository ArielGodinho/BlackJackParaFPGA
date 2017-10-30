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
		gameFinished: out std_logic
	);
end ResultCalculator;

architecture arch of ResultCalculator is
	signal playerOneStillHasCards: std_logic;
	signal playerTwoStillHasCards: std_logic;
	signal playerOneCardsSum: integer;
	signal playerTwoCardsSum: integer;
	signal base: integer;
begin
	
	process (clock, playerOneCards, playerTwoCards)
	begin
		if (rising_edge(clock))
			base <= 0;
			playerOneCardsSum <= 0;
			playerTwoCardsSum <= 0;
			playerTwoStillHasCards <= playerOneCards(5) or playerOneCards(4) or playerOneCards(3) or playerOneCards(2);
			playerTwoStillHasCards <= playerTwoCards(5) or playerTwoCards(4) or playerTwoCards(3) or playerTwoCards(2);

			checkingCards : while (playerTwoStillHasCards and playerTwoStillHasCards) loop
				playerOneCardsSum <= playerOneCardsSum + to_integer(unsigned(playerOneCards(5+base downto 2+base)));
				playerTwoCardsSum <= playerTwoCardsSum + to_integer(unsigned(playerTwoCards(5+base downto 2+base)));

				if (playerOneCardsSum <= 21 and playerTwoCardsSum <= 21) then
					result <= 0;
					gameFinished <= 0;
				elsif (playerOneCardsSum <= 21 and playerTwoCardsSum > 21) then
					result <= 1;
					gameFinished <= 1;
				elsif (playerOneCardsSum > 21 and playerTwoCardsSum <= 21) then
					result <= 2;
					gameFinished <= 1;
				elsif (playerOneCardsSum > 21 and playerTwoCardsSum > 21) then
					result <= 3;
					gameFinished <= 1;
				end if;

				base <= base + 6;
				playerTwoStillHasCards <= playerOneCards(5+base) or playerOneCards(4+base) or playerOneCards(3+base) or playerOneCards(2+base);
				playerTwoStillHasCards <= playerTwoCards(5+base) or playerTwoCards(4+base) or playerTwoCards(3+base) or playerTwoCards(2+base);
			end loop ; -- checkingCards
		end if;
	end process;

end arch;