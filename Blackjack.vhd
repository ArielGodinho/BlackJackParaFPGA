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

	signal 

begin

end arch;