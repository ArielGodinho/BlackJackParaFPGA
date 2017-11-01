library ieee;
use ieee.std_logic_1164.all;

entity ControlUnit is
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
		showResult: out std_logic
	);
end ControlUnit;

architecture arch of ControlUnit is

	type state_type is (start, dealingCards, firstPlayerTurn, secondPlayerTurn, calculatingResult, showingResult);
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
						state <= firstPlayerTurn;
					

				when firstPlayerTurn =>
					if nextTurn = '1' then
						state <= secondPlayerTurn;
					else
						state <= firstPlayerTurn;
					end if;

				when secondPlayerTurn =>
					if nextTurn = '1' then
						state <= calculatingResult;
					else
						state <= secondPlayerTurn;
					end if;

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

















