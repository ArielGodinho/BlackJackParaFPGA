library ieee;
use ieee.std_logic_1164.all;

entity Deck is
	port(
		topCardTaken: in std_logic;
		topCard: out std_logic_vector(5 downto 0)
	);
end Deck;

architecture arch of Deck is
begin

end arch;