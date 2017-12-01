library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity Blackjack is
	port(
		clock                : in  std_logic;
		reset                : in  std_logic;
		dealCardToPlayer0    : in  std_logic;
		dealCardToPlayer1    : in  std_logic;
		stopDealingToPlayer0 : in  std_logic;
		stopDealingToPlayer1 : in  std_logic; 
		debugDealCard        : out std_logic;
		debugStopDealing     : out std_logic;
		player0CardsSum      : out std_logic_vector(13 downto 0);
		player1CardsSum      : out std_logic_vector(13 downto 0);
		debugPlayer0CardsSum : out integer;
		debugPlayer1CardsSum : out integer;
		lastCardTaken        : out std_logic_vector(5 downto 0);
		result               : out std_logic_vector(6 downto 0);
		nextRound            : out std_logic;
		playerTurn           : out std_logic;
		dealCardsOut         : out std_logic;
		calculateResult      : out std_logic;
		showResult           : out std_logic
	);
end Blackjack;

architecture arch of Blackjack is
	
	component BlackJackGameController is
		port (
			clock        : in  std_logic;
			reset        : in  std_logic;
			dealCards    : in  std_logic;
			playerTurn   : in  std_logic;
			doEndTurn    : in  std_logic;
			dealNewCard  : in  std_logic;
			stopDealing  : in  std_logic;
			nextRound    : out std_logic;
			player0Cards : out std_logic_vector(59 downto 0);
			player1Cards : out std_logic_vector(59 downto 0);
			debugTopCard : out std_logic_vector(5 downto 0);
			player0Stopped: out boolean;
	        player1Stopped: out boolean
		);
	end component BlackJackGameController;
	
	component BlackJackControlUnit is
		port(
			clock           : in  std_logic;
			reset           : in  std_logic;
			dealCardsIn     : in  std_logic;
			nextTurn        : in  std_logic;
			endGame         : in  std_logic;
			gameBegan       : in  std_logic;
			gameFinished    : in  std_logic;
			playerTurn      : out std_logic;
			dealCardsOut    : out std_logic;
			calculateResult : out std_logic;
			showResult      : out std_logic
		);
	end component BlackJackControlUnit;
	
	component BlackJackResultCalculator is
		port(
			clock                  : in  std_logic;
			playerOneCards         : in  std_logic_vector(59 downto 0);
			playerTwoCards         : in  std_logic_vector(59 downto 0);
			player0Stopped: in boolean;
	        player1Stopped: in boolean;
			result                 : out integer;
			gameFinished           : out std_logic;
			debugPlayerOneCardsSum : out integer;
			debugPlayerTwoCardsSum : out integer
		);
	end component BlackJackResultCalculator;
	
	component HexadecimalDisplay is
		port(
			data : in  std_logic_vector(3 downto 0);
			segs : out std_logic_vector(6 downto 0)
		);
	end component HexadecimalDisplay;
	
	component EdgeDetector is
		port (
			clock    : in  STD_LOGIC;
			signalIn : in  STD_LOGIC;
			output   : out STD_LOGIC
		);
	end component EdgeDetector; 
	
	signal sDealCardsOut         : std_logic;
	signal sPlayerTurn           : std_logic;
	signal sNextRound            : std_logic;
	signal sPlayer0cards         : std_logic_vector(59 downto 0);
	signal sPlayer1cards         : std_logic_vector(59 downto 0);
	signal sGameFinished         : std_logic;
	signal sCalculateResult      : std_logic;
	signal sShowResult           : std_logic;
	signal sResultInt            : integer;
	signal sResult               : std_logic_vector(3 downto 0) := std_logic_vector(to_unsigned(sResultInt, 4));
	signal sDealCardToPlayer0    : std_logic                    := '0';
	signal sDealCardToPlayer1    : std_logic                    := '0';
	signal sStopDealingToPlayer0 : std_logic                    := '0';
	signal sStopDealingToPlayer1 : std_logic                    := '0';
	signal sDealNewCard          : std_logic;
	signal sStopDealing          : std_logic;
	signal sPlayer0CardsSumInt   : integer;
	signal sPlayer1CardsSumInt   : integer;
	signal sPlayer0CardsSum      : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(sPlayer0CardsSumInt, 8));
	signal sPlayer1CardsSum      : std_logic_vector(7 downto 0) := std_logic_vector(to_unsigned(sPlayer1CardsSumInt, 8));
	signal sPlayer0Stopped: boolean;
    signal sPlayer1Stopped: boolean;
	
begin
		e0 : EdgeDetector port map (clock, dealCardToPlayer0, sDealCardToPlayer0);
		e1 : EdgeDetector port map (clock, dealCardToPlayer1, sDealCardToPlayer1);
		e2 : EdgeDetector port map (clock, stopDealingToPlayer0, sStopDealingToPlayer0);
		e3 : EdgeDetector port map (clock, stopDealingToPlayer1, sStopDealingToPlayer1);
	
	sDealNewCard <= (not sPlayerTurn and sDealCardToPlayer0) or (sPlayerTurn and sDealCardToPlayer1);
	sStopDealing <= (not sPlayerTurn and sStopDealingToPlayer0) or (sPlayerTurn and sStopDealingToPlayer1);
	
		k1 : BlackJackGameController port map (clock, reset, sDealCardsOut, sPlayerTurn, sCalculateResult, sDealNewCard, sStopDealing, sNextRound, sPlayer0cards, sPlayer1cards, lastCardTaken, sPlayer0Stopped, sPlayer1Stopped);
		k2 : BlackJackControlUnit port map (clock, reset, '1', sNextRound, reset, sNextRound, sGameFinished, sPlayerTurn, sDealCardsOut, sCalculateResult, sShowResult);
		k3 : BlackJackResultCalculator port map (clock, sPlayer0cards, sPlayer1cards, sPlayer0Stopped, sPlayer1Stopped, sResultInt, sGameFinished, sPlayer0CardsSumInt, sPlayer1CardsSumInt);
	
	sPlayer0CardsSum <= std_logic_vector(to_unsigned(sPlayer0CardsSumInt, 8));
	sPlayer1CardsSum <= std_logic_vector(to_unsigned(sPlayer1CardsSumInt, 8)); 
	sResult          <= std_logic_vector(to_unsigned(sResultInt, 4));
	
		h0 : HexadecimalDisplay port map (sPlayer0CardsSum(3 downto 0), player0CardsSum(6 downto 0));
		h1 : HexadecimalDisplay port map (sPlayer0CardsSum(7 downto 4), player0CardsSum(13 downto 7));
		h2 : HexadecimalDisplay port map (sPlayer1CardsSum(3 downto 0), player1CardsSum(6 downto 0));
		h3 : HexadecimalDisplay port map (sPlayer1CardsSum(7 downto 4), player1CardsSum(13 downto 7));
	
		h4 : HexadecimalDisplay port map (sResult, result);
	
	playerTurn           <= sPlayerTurn;
	dealCardsOut         <= sDealCardsOut;
	calculateResult      <= sCalculateResult;
	showResult           <= sShowResult;
	nextRound            <= sNextRound;
	debugPlayer0CardsSum <= sPlayer0CardsSumInt;
	debugPlayer1CardsSum <= sPlayer1CardsSumInt;
end arch;








