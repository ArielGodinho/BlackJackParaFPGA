-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity TransmissaoFluxoDeDados is
	port(
		  clock					: in  std_logic;
		  reset					: in  std_logic;
		  dadoParalelo			: in  std_logic_vector(6 downto 0);
          resetCount 			: in  std_logic;
		  loadRegister			: in  std_logic;
		  shiftRegister			: in  std_logic;
		  count					: out std_logic_vector(0 to 3);
		  saidaSerial			: out std_logic;
		  clockInterno 			: out std_logic;
		  conteudoRegistrador	: out std_logic_vector(11 downto 0);
		  subClockRunning 		: out std_logic);
end TransmissaoFluxoDeDados;

architecture exemplo of TransmissaoFluxoDeDados is

    component TransmissaoClockGenerator is
        generic (
            M : integer := 41667
        );
        port (
            clk, reset                 : in  std_logic;
            clock_out, subClockRunning : out std_logic
        );
    end component TransmissaoClockGenerator;

    component RegistradorDeslocador is
        port (
            clock               : in  std_logic;
            loadRegister        : in  std_logic;
            shiftRegister       : in  std_logic;
            dadoParalelo        : in  std_logic_vector(6 downto 0);
            saidaSerial         : out std_logic := '1';
            conteudoRegistrador : out std_logic_vector(11 downto 0)
        );
    end component RegistradorDeslocador;	

    component Counter_4b is
        port (
            clock : in  std_logic;
            reset : in  std_logic;
            count : out std_logic_vector(0 to 3)
        );
    end component Counter_4b;	
	
signal s3 : std_logic_vector(3 downto 0);
signal sClockInterno : std_logic;

begin
	g1 : RegistradorDeslocador port map (sClockInterno, loadRegister, shiftRegister, dadoParalelo, saidaSerial, conteudoRegistrador);
	g2 : Counter_4b port map (sClockInterno, resetCount, count);
	g3 : TransmissaoClockGenerator port map (clock, reset, sClockInterno, subClockRunning);

	clockInterno <= sClockInterno;
end exemplo;