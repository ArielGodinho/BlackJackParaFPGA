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
		nextRound				: in std_logic;
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
    component Printer is
        port (
            clock           : in  std_logic;
            reset           : in  std_logic;
            imprime         : in  std_logic;
            fim_transmissao : in  std_logic;
            player0CardsSum : in  std_logic_vector(13 downto 0);
            player1CardsSum : in  std_logic_vector(13 downto 0);
            result          : in  std_logic_vector(6 downto 0);
            transmite_dado  : out std_logic;
            saida           : out std_logic_vector(6 downto 0)
        );
    end component Printer;

	signal sDealCardsToPlayer0   : std_logic;
	signal sDealCardsToPlayer1   : std_logic;
	signal sStopDealingToPlayer0 : std_logic;
	signal sStopDealingToPlayer1 : std_logic;
begin
    printer1 : Printer
        port map (
            clock           => clock,
            reset           => reset,
            imprime         => nextRound,
            fim_transmissao => not trasmissaoEmAndadamento,
            player0CardsSum => player0CardsSum,
            player1CardsSum => player1CardsSum,
            result          => result,
            transmite_dado  => transmiteDado,
            saida           => dadoTransmissao
        );	

	process (clock, reset, dadoRecepcao, temDadoRecebido)
	begin 
		if reset = '1' then
			sDealCardsToPlayer0   <= '0';
			sDealCardsToPlayer1   <= '0';
			sStopDealingToPlayer0 <= '0';
			sStopDealingToPlayer1 <= '0'; 
		elsif(rising_edge(clock)) then
			if temDadoRecebido = '1' then
				case dadoRecepcao is
					when "10000010" => -- A - Deal P0
						sDealCardsToPlayer0 <= '1';
					when "10100110" => -- S - Deal P1
						sDealCardsToPlayer1 <= '1';
					when "10001101" => -- F - Stop P0
						sStopDealingToPlayer0 <= '1';
					when "10001110" => -- G - Stop P1
						sStopDealingToPlayer1 <= '1';
						
					when others => 
						sDealCardsToPlayer0   <= '0';
						sDealCardsToPlayer1   <= '0';
						sStopDealingToPlayer0 <= '0';
						sStopDealingToPlayer1 <= '0'; 
				end case;
			else
				sDealCardsToPlayer0   <= '0';
				sDealCardsToPlayer1   <= '0';
				sStopDealingToPlayer0 <= '0';
				sStopDealingToPlayer1 <= '0'; 
			end if;
		end if;
	end process; 
	dealCardsToPlayer0   <= sDealCardsToPlayer0;
	dealCardsToPlayer1   <= sDealCardsToPlayer1;
	stopDealingToPlayer0 <= sStopDealingToPlayer0;
	stopDealingToPlayer1 <= sStopDealingToPlayer1; 
end arch;