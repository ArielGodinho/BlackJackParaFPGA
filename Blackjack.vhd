library ieee;
use ieee.std_logic_1164.all;

entity Blackjack is
	port(
		clock: in std_logic;
		reset: in std_logic;
		dealCardsToPlayerOne: in std_logic;
		dealCardsToPlayerTwo: in std_logic;
		player0Stopped: in std_logic;
		player1Stopped: in std_logic;
		player0CardsSum: out std_logic_vector(13 downto 0);
		player1CardsSum: out std_logic_vector(13 downto 0);
		lastCardTaken: out std_logic_vector(5 downto 0);
		result: out std_logic_vector(6 downto 0)
	);
end Blackjack;

architecture arch of Blackjack is

	component GameController is
        port (
            clock: in std_logic;
            reset: in std_logic;
            dealCards: in std_logic;
            playerTurn: in std_logic;
            doEndTurn: in std_logic;
            dealNewCard: in std_logic;
            stopDealing: in std_logic;
            nextRound: out std_logic;
            player0Cards: out std_logic_vector(59 downto 0);
            player1Cards: out std_logic_vector(59 downto 0)
        );
    end component GameController;

    component ControlUnit is
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
	end component ControlUnit;

	component ResultCalculator is
		port(
			clock: in std_logic;
			playerOneCards: in std_logic_vector(59 downto 0);
			playerTwoCards: in std_logic_vector(59 downto 0);
			result: out integer;
			gameFinished: out std_logic
		);
	end component ResultCalculator;

	component HexadecimalDisplay is
		port(
	    	data : in std_logic_vector(3 downto 0);
			segs : out std_logic_vector(6 downto 0)
		);
	end component HexadecimalDisplay;

begin

end arch;