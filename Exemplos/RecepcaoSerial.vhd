-- VHDL do Sistema Digital

library ieee;
use ieee.std_logic_1164.all;

entity RecepcaoSerial is
	port( reset 			: in std_logic;
		clock         		: in  std_logic;
		dado_serial   		: in  std_logic;
		paridade      		: out std_logic;
	    hexa1 				: out std_logic_vector(6 downto 0);
	    hexa0 				: out std_logic_vector(6 downto 0);
        subClockRunning 	: out std_logic;							-- Depuracao
		dado_paralelo 		: out std_logic_vector(7 downto 0); -- Depuracao
		saidas_estado 		: out std_logic_vector(3 downto 0); -- Depuracao
		clockInterno  		: out std_logic; 							-- Depuracao
		count  		  		: out std_logic_vector(0 to 3)); 	-- Depuracao
end RecepcaoSerial;

architecture exemplo of RecepcaoSerial is 
	
	component UnidadeControle is
	   port(clock, dados, reset : in std_logic;
	        subClockRunning : in std_logic;
	    	count: in std_logic_vector(0 to 3);
	        control    : out  std_logic_vector(3 downto 0));  -- resetClock|resetCounter|resetRegister|enableRegister
	end component UnidadeControle;
	
    component FluxoDeDados is
        port (
            clock                                                   : in  std_logic;
            resetClock, resetCounter, resetRegister, enableRegister : in  std_logic;
            dado_serial                                             : in  std_logic;
            subClockRunning                                         : out std_logic;
	    	count 													: out std_logic_vector(0 to 3);
			parity 				 									: out std_logic;
		    hexa1 													: out std_logic_vector(6 downto 0);
		    hexa0 													: out std_logic_vector(6 downto 0);
			dado_paralelo 											: out std_logic_vector(7 downto 0); -- Depuracao
			clockInterno 											: out std_logic); -- Depuracao
    end component FluxoDeDados;
	
	signal sCount : std_logic_vector(0 to 3);
	signal sControl : std_logic_vector(3 downto 0);
	signal sSubClockRunning : std_logic;
	
begin 
	
	k1 : UnidadeControle port map (clock, dado_serial, reset, sSubClockRunning, sCount, sControl);
	k2 : FluxoDeDados port map (clock, sControl(3), sControl(2), sControl(1), sControl(0), dado_serial, sSubClockRunning, sCount, paridade, hexa1, hexa0, dado_paralelo, clockInterno);

	saidas_estado <= sControl;
	count <= sCount;
	subClockRunning <= sSubClockRunning;
end exemplo;