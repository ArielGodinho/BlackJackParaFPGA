library ieee;
use ieee.std_logic_1164.all;

entity Blackjack is
	port(
		clock: in std_logic;
		reset: in std_logic;
		dealCardToPlayer0: in std_logic;
		dealCardToPlayer1: in std_logic;
		stopDealingToPlayer0: in std_logic;
		stopDealingToPlayer1: in std_logic;
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
			gameFinished: out std_logic;
			debugPlayerOneCardsSum: out integer;
			debugPlayerTwoCardsSum: out integer
		);
	end component ResultCalculator;

	component HexadecimalDisplay is
		port(
	    	data : in std_logic_vector(3 downto 0);
			segs : out std_logic_vector(6 downto 0)
		);
	end component HexadecimalDisplay;

	signal sDealCardsOut: std_logic;
	signal sPlayerTurn: std_logic;
	signal sNextRound: std_logic;
	signal sPlayer0cards: std_logic_vector(59 downto 0);
	signal sPlayer1cards: std_logic_vector(59 downto 0);
	signal sGameFinished: std_logic;
	signal sCalculateResult: std_logic;
	signal sShowResult: std_logic;
	signal sResult: integer;
	signal sDealNewCard: std_logic := (not sPlayerTurn and dealCardToPlayer0) or (sPlayerTurn and dealCardToPlayer1);
	signal sStopDealing: std_logic := (not sPlayerTurn and stopDealingToPlayer0) or (sPlayerTurn and stopDealingToPlayer1);

begin

	k1: GameController port map (clock, reset, sDealCardsOut, sPlayerTurn, sCalculateResult, sDealNewCard, sStopDealing, sNextRound, sPlayer0cards, sPlayer1cards);
	k2: ControlUnit port map (clock, reset, '1', sNextRound, '1', sNextRound, sGameFinished, sPlayerTurn, sDealCardsOut, sCalculateResult, sShowResult);
	k3: ResultCalculator port map (clock, sPlayer0cards, sPlayer1cards, sResult, sGameFinished);

end arch;