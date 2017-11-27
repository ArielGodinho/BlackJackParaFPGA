-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity UART is
	port(
		--Inputs
		clock         			: in  std_logic;
		reset 					: in  std_logic;

		entradaSerial  			: in  std_logic;

		transmiteDado			: in  std_logic;
		dadoTransmissao			: in  std_logic_vector(6 downto 0);

		recebeDado				: in  std_logic;
		--Outputs
		dadoRecepcao 			: out std_logic_vector(7 downto 0);
		paridadeOk     			: out std_logic;

		saidaSerial  			: out std_logic;
		trasmissaoEmAndadamento	: out std_logic;

		temDadoRecebido			: out std_logic;
		--Debug
		hexaInterface0			: out std_logic_vector(6 downto 0);
		hexaInterface1			: out std_logic_vector(6 downto 0);
		hexaRecepcao0			: out std_logic_vector(6 downto 0);
		hexaRecepcao1			: out std_logic_vector(6 downto 0);		
		subClockRunning 		: out std_logic;
		saidasEstadoRecepcao 	: out std_logic_vector(3 downto 0);
		clockInternoRecepcao	: out std_logic;
		countRecepcao  		  	: out std_logic_vector(0 to 3);
		registradorTransmissao	: out std_logic_vector(11 downto 0);
		countTransmissao		: out std_logic_vector(0 to 3);
		clockInternoTransmissao	: out std_logic;
		resetCountDebug 		: out std_logic;
		loadRegisterDebug 		: out std_logic;
		shiftRegisterDebug 		: out std_logic;
		dadoRegistrador			: out std_logic_vector(7 downto 0);
		dadoDisplay 			: out std_logic_vector(7 downto 0)
	);
end UART;

architecture arch of UART is         	

    component TransmissaoSerial is
        port (
            clock               : in  std_logic;
            reset               : in  std_logic;
            enviar              : in  std_logic;
            dadoParalelo        : in  std_logic_vector(6 downto 0);
            saidaSerial         : out std_logic;
            pronto              : out std_logic;
            conteudoRegistrador : out std_logic_vector(11 downto 0);
            subClockRunning     : out std_logic;
            countDebug          : out std_logic_vector(0 to 3);
            clockInterno        : out std_logic;
            resetCountDebug     : out std_logic;
            loadRegisterDebug   : out std_logic;
            shiftRegisterDebug  : out std_logic
        );
    end component TransmissaoSerial;

    component RecepcaoSerial is
        port (
            reset           : in  std_logic;
            clock           : in  std_logic;
            dado_serial     : in  std_logic;
            paridade        : out std_logic;
            hexa1           : out std_logic_vector(6 downto 0);
            hexa0           : out std_logic_vector(6 downto 0);
            subClockRunning : out std_logic;
            dado_paralelo   : out std_logic_vector(7 downto 0);
            saidas_estado   : out std_logic_vector(3 downto 0);
            clockInterno    : out std_logic;
            count           : out std_logic_vector(0 to 3)
        );
    end component RecepcaoSerial;
	
    component HexadecimalDisplay is
        port (
            data : in  std_logic_vector(3 downto 0);
            segs : out std_logic_vector(6 downto 0)
        );
    end component HexadecimalDisplay;    


	--Signals Desligados
	signal sSubClockRunning : std_logic;
	--Signals
	signal sPronto : std_logic;

	signal sSaidasRecepcao : std_logic_vector(3 downto 0);
	signal sDadoFoiRecebido : std_logic;
	signal sTemDadoRecebido : std_logic := '0';

	signal sDadoParaleloRecepcao : std_logic_vector(7 downto 0);
	signal sDadoParaleloInterface : std_logic_vector(7 downto 0);
	signal sDadoParaleloDisplay : std_logic_vector(7 downto 0);
	signal sHex1 : std_logic_vector(3 downto 0);
	signal sHex0 : std_logic_vector(3 downto 0);
	
begin 
	g4 : HexadecimalDisplay port map (sHex1, hexaInterface1);
	g5 : HexadecimalDisplay port map (sHex0, hexaInterface0);

	k1 : TransmissaoSerial port map (clock, reset, transmiteDado, dadoTransmissao, saidaSerial, sPronto, registradorTransmissao, sSubClockRunning, countTransmissao, clockInternoTransmissao, resetCountDebug, loadRegisterDebug, shiftRegisterDebug);
	k2 : RecepcaoSerial port map (reset, clock, entradaSerial, paridadeOk, hexaRecepcao1, hexaRecepcao0, subClockRunning, sDadoParaleloRecepcao, sSaidasRecepcao, clockInternoRecepcao, countRecepcao);

	sDadoFoiRecebido <= not (sSaidasRecepcao(3) or sSaidasRecepcao(2) or sSaidasRecepcao(1) or sSaidasRecepcao(0));


	process (clock, sDadoFoiRecebido, sTemDadoRecebido, recebeDado)
		begin
		if rising_edge(clock) then
				if sDadoFoiRecebido = '1' and sTemDadoRecebido = '0' then
					sDadoParaleloInterface <= sDadoParaleloRecepcao;
					sTemDadoRecebido <= '1';
				end if;

				if recebeDado = '1' and sTemDadoRecebido = '1' then
					sDadoParaleloDisplay <= sDadoParaleloInterface;
					sTemDadoRecebido <= '0';
				end if;
		end if;
	end process;


	saidasEstadoRecepcao <= sSaidasRecepcao;
	temDadoRecebido <= sTemDadoRecebido;
	dadoRecepcao <= sDadoParaleloRecepcao;

	trasmissaoEmAndadamento <= not sPronto;


	sHex1 <= '0' & sDadoParaleloDisplay(1) & sDadoParaleloDisplay(2) & sDadoParaleloDisplay(3);
	sHex0 <= sDadoParaleloDisplay(4) & sDadoParaleloDisplay(5) & sDadoParaleloDisplay(6) & sDadoParaleloDisplay(7);
	dadoRegistrador <= sDadoParaleloInterface;
	dadoDisplay <= sDadoParaleloDisplay;
end arch;