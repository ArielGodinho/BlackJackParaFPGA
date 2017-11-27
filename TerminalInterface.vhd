library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity TerminalInterface is
	port(
		clock : in std_logic;
		reset : in std_logic;
		
		-- BlackJack
		
		player0CardsSum      : in  std_logic_vector(13 downto 0);
		player1CardsSum      : in  std_logic_vector(13 downto 0);
		result               : in  std_logic_vector(6 downto 0); 
		dealCardsToPlayer0   : out std_logic;
		dealCardsToPlayer1   : out std_logic;
		stopDealingToPlayer0 : out std_logic;
		stopDealingToPlayer1 : out std_logic;
		
		--UART
		
		dadoRecepcao            : in  std_logic_vector(7 downto 0);
		trasmissaoEmAndadamento : in  std_logic;
		temDadoRecebido         : in  std_logic; 
		transmiteDado           : out std_logic;
		recebeDado              : out std_logic;
		dadoTransmissao         : out std_logic_vector(6 downto 0)
	);
end TerminalInterface;

architecture arch of TerminalInterface is
	
begin
	
end arch;