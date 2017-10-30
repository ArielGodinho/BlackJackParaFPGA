--Game Controller
--Scope:
--  Controlling Plays
--  Player status management
--  Giving Cards
--  Game Ending

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 

entity GameController is
    port(
        clock               : in std_logic;
        reset               : in std_logic;

        dealCards           : in std_logic;
        playerTurn          : in std_logic;
        doEndTurn           : in std_logic;

        dealNewCard         : in std_logic;
        stopDealing         : in std_logic;

--      count               : out std_logic_vector(0 to 3);
        --Output
        nextRound           : out std_logic;
        --Debug
        player0Cards        : out std_logic_vector(59 downto 0);
        player1Cards        : out std_logic_vector(59 downto 0);
        debugTopCard        : out std_logic_vector(5 downto 0)
    );
end GameController;

architecture arch of GameController is
    component Deck is
        port (
            clock        : in  std_logic;
            shuffleDeck  : in  std_logic;
            topCardTaken : in  std_logic;
            topCard      : out std_logic_vector(5 downto 0)
        );
    end component Deck;    

    type Player is record
        stopped             : boolean;
        cardCount           : integer;
        cards               : std_logic_vector(59 downto 0);
    end record Player;  

    constant c_Player : Player := (
        stopped => false,
        cardCount => 0,
        cards => (others => '0')
    );

    signal player0 : Player := c_Player;
    signal player1 : Player := c_Player;
    signal sShuffleDeck : std_logic := '0';
    signal sNextCard : std_logic := '0';
    signal sNextRound : std_logic := '0';
    signal sTopCard : std_logic_vector(5 downto 0);

begin

    d1 : Deck port map (clock, sShuffleDeck, sNextCard, sTopCard);

    process(clock, reset, dealCards, playerTurn, doEndTurn, dealNewCard, stopDealing)
    begin

        if reset='1' then
            player0 <= c_Player;
            player1 <= c_Player;
        elsif rising_edge(clock) then		  
			  if sNextRound = '1' then
					sNextRound <= '0';
					sNextCard <= '0';
			  end if;
			  
            if dealCards = '1' then         --Dealing the initial cards
                player0.cards(11 downto 6) <= "101000";
                player0.cards(5 downto 0) <= "001001";
                player1.cards(11 downto 6) <= "001110";
                player1.cards(5 downto 0) <= "100011";
                player0.cardCount <= 2;
                player1.cardCount <= 2;
                sNextRound <= '1';              
            elsif doEndTurn = '1' then      -- Calculate endturn


            elsif playerTurn = '0' and not player0.stopped then     -- Player 0 turn's
                if dealNewCard = '1' then
                    player0.cards(59 downto 6) <= player0.cards(53 downto 0);
                    player0.cards(5 downto 0) <= sTopCard;
                    player0.cardCount <= player0.cardCount;
                    sNextCard <= '1';
                    sNextRound <= '1';
                elsif stopDealing = '1' then
                    player0.stopped <= true;
                    sNextRound <= '1';       
                end if;

            elsif playerTurn = '1' and not player1.stopped then     -- Player 1 turn's
                if dealNewCard = '1' then
                    player1.cards(59 downto 6) <= player1.cards(53 downto 0);
                    player1.cards(5 downto 0) <= sTopCard;
                    player1.cardCount <= player1.cardCount;
                    sNextCard <= '1';
                    sNextRound <= '1';
                elsif stopDealing = '1' then
                    player1.stopped <= true;
                    sNextRound <= '1';       
                end if;

            end if;

        end if;
    end process;
    player0Cards <= player0.cards;
    player1Cards <= player1.cards;
	nextRound <= sNextRound;
    debugTopCard <= sTopCard;
end arch;


                --player0.cards(11 downto 8) <= player0.cards(53 downto 0);

--                player0CardValue <= to_integer(unsigned(player0.cards(5 downto 2))) + to_integer(unsigned(player0.cards(11 downto 8)));
--                player1CardValue <= to_integer(unsigned(player1.cards(5 downto 2))) + to_integer(unsigned(player1.cards(11 downto 8)));