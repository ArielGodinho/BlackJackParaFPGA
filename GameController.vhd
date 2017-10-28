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
        gameEndded          : out std_logic;
        nextRound           : out std_logic;
        --Debug
        player0Cards        : out array(0 to 9) of Card;
        player1Cards        : out array(0 to 9) of Card
    );
end GameController;

architecture arch of GameController is
    type Player is record
        stopped             : boolean;
        cardCount           : integer;
        cards               : array(0 to 9) of Card;
    end record Player;

    type Card is record
        value               : std_logic_vector(3 downto 0);
        suit                : std_logic_vector(1 downto 0);
    end record Player;

    constant c_Player : Player := (
        stopped => false,
        cardCount => 0,
        cards => (others => c_Card)
    );
    constant c_Card : Card := (
        value => "0000",
        suit => "00"
    ); 

    signal player0 : Player := c_Player;
    signal player1 : Player := c_Player;
    signal topCard : Card := c_Card;


begin
    process(clock, reset, playerTurn)
    begin 
        if reset='1' then
            player0 <= c_Player;
            player1 <= c_Player;
        elsif rising_edge(clock) then
            topCard.suit = "01";
            topCard.value = "1100";

            if dealCards = '1' then         --Dealing the initial cards
                if playerTurn = '0' then
                    player0.cards(player0.cardCount) <= topCard;
                    player0.cardCount <= player0.cardCount + 1;
                else
                    player1.cards(player1.cardCount) <= topCard;
                    player1.cardCount <= player1.cardCount + 1;
                end if;
            elsif doEndTurn = '1' then      -- Calculate endturn


            elsif playerTurn = '0' then     -- Player 0 turn's
                

            elsif playerTurn = '1' then     -- Player 1 turn's


            end if;

        end if;
    end process;
    player0Cards <= player0.cards;
    player1Cards <= player1.cards;
end arch;


                --player0.cards(11 downto 8) <= player0.cards(53 downto 0);

--                player0CardValue <= to_integer(unsigned(player0.cards(5 downto 2))) + to_integer(unsigned(player0.cards(11 downto 8)));
--                player1CardValue <= to_integer(unsigned(player1.cards(5 downto 2))) + to_integer(unsigned(player1.cards(11 downto 8)));