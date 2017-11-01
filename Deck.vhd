library ieee;
use ieee.std_logic_1164.all;

entity Deck is
	port(
		clock: in std_logic;
		shuffleDeck: in std_logic;
		topCardTaken: in std_logic;
		topCard: out std_logic_vector(5 downto 0)
	);
end Deck;

architecture arch of Deck is
	type deck_type is array (0 to 51) of std_logic_vector(5 downto 0);
	type integer_vector is array (0 to 51) of integer;
	constant deck: deck_type := (
		"000100", "001000", "001100", "010000", "010100", "011000", "011100", "100000", "100100", "101000", "101100", "110000", "110100",
		"000101", "001001", "001101", "010001", "010101", "011001", "011101", "100001", "100101", "101001", "101101", "110001", "110101",
		"000110", "001010", "001110", "010010", "010110", "011010", "011110", "100010", "100110", "101010", "101110", "110010", "110110",
		"000111", "001011", "001111", "010011", "010111", "011011", "011111", "100011", "100111", "101011", "101111", "110011", "110111"
	);
	signal currentCard: integer := 0;
begin
	process(clock, topCardTaken)
	begin
		if (rising_edge(clock)) then
			if (topCardTaken = '1') then
				currentCard <= currentCard + 1;
			end if;
		end if;
	end process;

	topCard <= deck(currentCard);
end arch;











