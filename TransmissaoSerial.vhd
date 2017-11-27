-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity TransmissaoSerial is
	port(		  
		  clock		    		: in  std_logic;
		  reset		    		: in  std_logic;
		  enviar		 		: in  std_logic;
		  dadoParalelo	 		: in  std_logic_vector(6 downto 0);
		  saidaSerial   		: out std_logic;
		  pronto		   		: out std_logic;
		  conteudoRegistrador	: out std_logic_vector(11 downto 0);	-- Depuracao
          subClockRunning 		: out std_logic;
          countDebug			: out std_logic_vector(0 to 3);
		  clockInterno 			: out std_logic;
		  resetCountDebug 		: out std_logic;
		  loadRegisterDebug 	: out std_logic;
		  shiftRegisterDebug 	: out std_logic
	);
end TransmissaoSerial;

architecture exemplo of TransmissaoSerial is 

    component TransmissaoUnidadeControle is
        port (
            clock, reset, enviar : in  std_logic;
            count                : in  std_logic_vector(0 to 3);
            pronto               : out std_logic;
            resetCount           : out std_logic;
            loadRegister         : out std_logic;
            shiftRegister        : out std_logic
        );
    end component TransmissaoUnidadeControle;

    component TransmissaoFluxoDeDados is
        port (
            clock               : in  std_logic;
            reset               : in  std_logic;
            dadoParalelo        : in  std_logic_vector(6 downto 0);
            resetCount 			: in  std_logic;
            loadRegister        : in  std_logic;
            shiftRegister       : in  std_logic;
            count               : out std_logic_vector(0 to 3);
            saidaSerial         : out std_logic;
            clockInterno        : out std_logic;
            conteudoRegistrador : out std_logic_vector(11 downto 0);
		  	subClockRunning 	: out std_logic
        );
    end component TransmissaoFluxoDeDados;

signal sResetCount : std_logic;
signal sLoadRegister : std_logic;
signal sShiftRegister : std_logic;
signal sClockInterno : std_logic;
signal sCount : std_logic_vector(0 to 3);
	
begin 
	
	k1 : TransmissaoUnidadeControle port map (sClockInterno, reset, enviar, sCount, pronto, sResetCount, sLoadRegister, sShiftRegister);
	k2 : TransmissaoFluxoDeDados port map (clock, reset, dadoParalelo, sResetCount, sLoadRegister, sShiftRegister, sCount, saidaSerial, sClockInterno, conteudoRegistrador, subClockRunning);
				

	clockInterno <= sClockInterno;
	countDebug <= sCount;
	resetCountDebug <= sResetCount;
	loadRegisterDebug <= sLoadRegister;
	shiftRegisterDebug <= sShiftRegister;
end exemplo;