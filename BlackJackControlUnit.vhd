library ieee;
use ieee.std_logic_1164.all;

entity BlackJackControlUnit is
	port(
		clock: in std_logic;
		reset: in std_logic;
		dealCardsIn: in std_logic;
		nextTurn: in std_logic;
		endGame: in std_logic;
		gameBegan: in std_logic;
		gameFinished: in std_logic;
		playerTurn: out std_logic;
		dealCardsOut: out std_logic;
		calculateResult: out std_logic;
		showResult: out std_logic;
		trainning: in std_logic;
		cardGiven: in std_logic
	);
end BlackJackControlUnit;

architecture arch of BlackJackControlUnit is

	type state_type is (start, dealingCards, firstPlayerTurn, secondPlayerTurn, calculatingResult, waiting, showingResult, givingCard1, givingCard2);
	signal state: state_type;

begin
	process (clock, state, reset, endGame, gameBegan, gameFinished, nextTurn, dealCardsIn)
	begin
		if reset = '1' then
			state <= start;

		elsif (rising_edge(clock)) then
			case state is
				when start =>
					if dealCardsIn = '1' then
						state <= dealingCards;
					else
						state <= start;
					end if;

				when dealingCards =>
					if trainning = '0' then
						state <= firstPlayerTurn;
					else
						state <= givingCard1;
					end if;

				when givingCard1 =>
					if cardGiven = '1' then
						state <= firstPlayerTurn;
					else
						state <= givingCard1;
					end if;

				when firstPlayerTurn =>
					if (nextTurn = '1' and trainning = '0') then
						state <= secondPlayerTurn;
					elsif (nextTurn = '1' and trainning = '1') then
						state <= givingCard2;
					else
						state <= firstPlayerTurn;
					end if;

				when givingCard2 =>
					if cardGiven = '1' then
						state <= secondPlayerTurn;
					else
						state <= givingCard2;
					end if;

				when secondPlayerTurn =>
					if nextTurn = '1' then
						state <= waiting;
					else
						state <= secondPlayerTurn;
					end if;

				when waiting =>
						state <= calculatingResult;

				when calculatingResult =>
					if gameFinished = '1' then
						state <= showingResult;
					else
						state <= firstPlayerTurn;
					end if;

				when showingResult =>
					if endGame = '1' then
						state <= start;
					else
						state <= showingResult;
					end if;
			end case;
		end if;
	end process;

	process (clock, state)
	begin
		case state is
			when start =>
				playerTurn <= '0';
				dealCardsOut <= '0';
				calculateResult <= '0';
				showResult <= '0';

			when dealingCards =>
				playerTurn <= '0';
				dealCardsOut <= '1';
				calculateResult <= '0';
				showResult <= '0';

			when firstPlayerTurn =>
				playerTurn <= '0';
				dealCardsOut <= '0';
				calculateResult <= '0';
				showResult <= '0';

			when secondPlayerTurn =>
				playerTurn <= '1';
				dealCardsOut <= '0';
				calculateResult <= '0';
				showResult <= '0';

			when waiting =>
				playerTurn <= '0';
				dealCardsOut <= '0';
				calculateResult <= '1';
				showResult <= '0';

			when calculatingResult =>
				playerTurn <= '0';
				dealCardsOut <= '0';
				calculateResult <= '1';
				showResult <= '0';

			when showingResult =>
				playerTurn <= '0';
				dealCardsOut <= '0';
				calculateResult <= '0';
				showResult <= '1';
		end case;
	end process;

end arch ; -- archControlUnit

















