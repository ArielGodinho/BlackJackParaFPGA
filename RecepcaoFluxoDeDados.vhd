-- VHDL do Fluxo de Dados

library ieee;
use ieee.std_logic_1164.all;

entity RecepcaoFluxoDeDados is
	port(clock         : in  std_logic;
		resetClock, resetCounter, resetRegister, enableRegister       : in  std_logic;		
		dado_serial   : in  std_logic;
		subClockRunning   : out  std_logic;
	    count 		:  out std_logic_vector(0 to 3);
		parity 				 : out std_logic;
	    hexa1 : out std_logic_vector(6 downto 0);
	    hexa0 : out std_logic_vector(6 downto 0);
		dado_paralelo : out std_logic_vector(7 downto 0); -- Depuracao
		clockInterno : out std_logic); -- Depuracao
end RecepcaoFluxoDeDados;

architecture exemplo of RecepcaoFluxoDeDados is
	
	component ShiftRegister_8b is
		port (
			clock, clear, enable : in  std_logic;
			inputData            : in  std_logic;
			parity 				 : out std_logic;
			data                 : out std_logic_vector(7 downto 0)
		);
	end component ShiftRegister_8b;
	
	component Counter_4b is
		port (
			clock  : in  std_logic;
			reset  : in  std_logic;
			count : out std_logic_vector(0 to 3)
		);
	end component Counter_4b;
	
	component RecepcaoClockGenerator is
		port (
			clk, reset                 : in  std_logic;
			clock_out, subClockRunning : out std_logic
		);
	end component RecepcaoClockGenerator;

    component HexadecimalDisplay is
        port (
            data : in  std_logic_vector(3 downto 0);
				segs : out std_logic_vector(6 downto 0));
    end component HexadecimalDisplay;
	
	
	signal sDadoParalelo : std_logic_vector(7 downto 0);
	signal sHex1 : std_logic_vector(3 downto 0);
	signal sHex0 : std_logic_vector(3 downto 0);
	signal sClockInterno : std_logic;
	
begin
	sHex1 <= '0' & sDadoParalelo(1) & sDadoParalelo(2) & sDadoParalelo(3);
	sHex0 <= sDadoParalelo(4) & sDadoParalelo(5) & sDadoParalelo(6) & sDadoParalelo(7);

	g1 : ShiftRegister_8b port map (sClockInterno, resetRegister, enableRegister, dado_serial, parity, sDadoParalelo);
	g2 : Counter_4b port map (sClockInterno, resetCounter, count);
	g3 : RecepcaoClockGenerator port map (clock, resetClock, sClockInterno, subClockRunning);
	g4 : HexadecimalDisplay port map (sHex1, hexa1);
	g5 : HexadecimalDisplay port map (sHex0, hexa0);
	
	dado_paralelo <= sDadoParalelo;
	clockInterno <= sClockInterno;
end exemplo;

