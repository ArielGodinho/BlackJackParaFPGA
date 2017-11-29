library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity TopLevelEntity is
	port(
		clock         : in  std_logic;
		reset         : in  std_logic;
		entradaSerial : in  std_logic;
		saidaSerial   : out std_logic;

		debugUartDadoRecepcao: out std_logic_vector(7 downto 0);
		debugHexaRecepcao0           : out std_logic_vector(6 downto 0);
		debugHexaRecepcao1           : out std_logic_vector(6 downto 0)
		debugSubClockRunning: out std_logic
	);
end TopLevelEntity;

architecture arch of TopLevelEntity is
	component Blackjack is
		port (
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
	end component Blackjack;
	
	component UART is
		port (
			clock                   : in  std_logic;
			reset                   : in  std_logic;
			entradaSerial           : in  std_logic;
			transmiteDado           : in  std_logic;
			dadoTransmissao         : in  std_logic_vector(6 downto 0);
			recebeDado              : in  std_logic;
			dadoRecepcao            : out std_logic_vector(7 downto 0);
			paridadeOk              : out std_logic;
			saidaSerial             : out std_logic;
			trasmissaoEmAndadamento : out std_logic;
			temDadoRecebido         : out std_logic;
			hexaInterface0          : out std_logic_vector(6 downto 0);
			hexaInterface1          : out std_logic_vector(6 downto 0);
			hexaRecepcao0           : out std_logic_vector(6 downto 0);
			hexaRecepcao1           : out std_logic_vector(6 downto 0);
			subClockRunning         : out std_logic;
			saidasEstadoRecepcao    : out std_logic_vector(3 downto 0);
			clockInternoRecepcao    : out std_logic;
			countRecepcao           : out std_logic_vector(0 to 3);
			registradorTransmissao  : out std_logic_vector(11 downto 0);
			countTransmissao        : out std_logic_vector(0 to 3);
			clockInternoTransmissao : out std_logic;
			resetCountDebug         : out std_logic;
			loadRegisterDebug       : out std_logic;
			shiftRegisterDebug      : out std_logic;
			dadoRegistrador         : out std_logic_vector(7 downto 0);
			dadoDisplay             : out std_logic_vector(7 downto 0)
		);
	end component UART;
	
	component TerminalInterface is
		port (
			clock                   : in  std_logic;
			reset                   : in  std_logic;
			player0CardsSum         : in  std_logic_vector(13 downto 0);
			player1CardsSum         : in  std_logic_vector(13 downto 0);
			result                  : in  std_logic_vector(6 downto 0);
			nextRound                  : in  std_logic;
			dealCardsToPlayer0      : out std_logic;
			dealCardsToPlayer1      : out std_logic;
			stopDealingToPlayer0    : out std_logic;
			stopDealingToPlayer1    : out std_logic;
			dadoRecepcao            : in  std_logic_vector(7 downto 0);
			trasmissaoEmAndadamento : in  std_logic;
			temDadoRecebido         : in  std_logic;
			transmiteDado           : out std_logic;
			recebeDado              : out std_logic;
			dadoTransmissao         : out std_logic_vector(6 downto 0)
		);
	end component TerminalInterface; 

	signal sDealCardToPlayer0 : std_logic;
	signal sDealCardToPlayer1 : std_logic;
	signal sStopDealingToPlayer0 : std_logic;
	signal sStopDealingToPlayer1 : std_logic;
	signal sPlayer0CardsSum : std_logic_vector(13 downto 0);
	signal sPlayer1CardsSum : std_logic_vector(13 downto 0);
	signal sResult : std_logic_vector(6 downto 0);
	signal sTransmiteDado : std_logic;
	signal sDadoTransmissao : std_logic_vector(6 downto 0);
	signal sRecebeDado : std_logic;
	signal sDadoRecepcao : std_logic_vector(7 downto 0);
	signal sTrasmissaoEmAndadamento : std_logic;
	signal sTemDadoRecebido : std_logic;
	signal sNextRound:std_logic;
	
	signal sHexaRecepcao0           : std_logic_vector(6 downto 0);
	signal sHexaRecepcao1           :  std_logic_vector(6 downto 0);
	signal sSubClockRunning: std_logic;
begin
    bj : Blackjack
        port map (
            clock                => clock,
            reset                => reset,
            dealCardToPlayer0    => sDealCardToPlayer0,
            dealCardToPlayer1    => sDealCardToPlayer1,
            stopDealingToPlayer0 => sStopDealingToPlayer0,
            stopDealingToPlayer1 => sStopDealingToPlayer1,
            debugDealCard        => open,
            debugStopDealing     => open,
            player0CardsSum      => sPlayer0CardsSum,
            player1CardsSum      => sPlayer1CardsSum,
            debugPlayer0CardsSum => open,
            debugPlayer1CardsSum => open,
            lastCardTaken        => open,
            result               => sResult,
            nextRound            => sNextRound,
            playerTurn           => open,
            dealCardsOut         => open,
            calculateResult      => open,
            showResult           => open
        );
    uart1 : UART
        port map (
            clock                   => clock,
            reset                   => reset,
            entradaSerial           => entradaSerial,
            transmiteDado           => '0',
            dadoTransmissao         => sDadoTransmissao,
            recebeDado              => '1',
            dadoRecepcao            => sDadoRecepcao,
            paridadeOk              => open,
            saidaSerial             => saidaSerial,
            trasmissaoEmAndadamento => sTrasmissaoEmAndadamento,
            temDadoRecebido         => sTemDadoRecebido,
            hexaInterface0          => open,
            hexaInterface1          => open,
            hexaRecepcao0           => sHexaRecepcao0,
            hexaRecepcao1           => sHexaRecepcao1,
            subClockRunning         => sSubClockRunning,
            saidasEstadoRecepcao    => open,
            clockInternoRecepcao    => open,
            countRecepcao           => open,
            registradorTransmissao  => open,
            countTransmissao        => open,
            clockInternoTransmissao => open,
            resetCountDebug         => open,
            loadRegisterDebug       => open,
            shiftRegisterDebug      => open,
            dadoRegistrador         => open,
            dadoDisplay             => open
        );	
    interface : TerminalInterface
        port map (
            clock                   => clock,
            reset                   => reset,
            player0CardsSum         => sPlayer0CardsSum,
            player1CardsSum         => sPlayer1CardsSum,
            result                  => sResult,
			nextRound				=> sNextRound,
            dealCardsToPlayer0      => sDealCardToPlayer0,
            dealCardsToPlayer1      => sDealCardToPlayer1,
            stopDealingToPlayer0    => sStopDealingToPlayer0,
            stopDealingToPlayer1    => sStopDealingToPlayer1,
            dadoRecepcao            => sDadoRecepcao,
            trasmissaoEmAndadamento => sTrasmissaoEmAndadamento,
            temDadoRecebido         => sTemDadoRecebido,
            transmiteDado           => sTransmiteDado,
            recebeDado              => sRecebeDado,
            dadoTransmissao         => sDadoTransmissao
        );	

    debugUartDadoRecepcao <= sDadoRecepcao;
	 debugHexaRecepcao0 <= sHexaRecepcao0;
	 debugHexaRecepcao1 <= sHexaRecepcao1;
	 debugSubClockRunning <= sSubClockRunning;
end arch;
