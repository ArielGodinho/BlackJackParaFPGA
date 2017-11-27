-- VHDL de um Registrador de Deslocamento para a direita

library ieee;
use ieee.std_logic_1164.all;

entity RegistradorDeslocador is
    port(clock      			: in  std_logic; 
         loadRegister       	: in  std_logic; 
         shiftRegister      	: in  std_logic;
         dadoParalelo 			: in  std_logic_vector(6 downto 0);
         saidaSerial   			: out std_logic := '1';					
         conteudoRegistrador	: out std_logic_vector(11 downto 0));
end RegistradorDeslocador;

architecture exemplo of RegistradorDeslocador is
signal IQ				: std_logic_vector(11 downto 0);
signal paridade		: std_logic;

begin
	process (clock, loadRegister, shiftRegister, IQ)
	begin
	
	-- usaremos paridade PAR
	paridade <= dadoParalelo(0) xor dadoParalelo(1) xor dadoParalelo(2) 
				xor dadoParalelo(3) xor dadoParalelo(4) xor dadoParalelo(5) 
				xor dadoParalelo (6);
	
	if (clock'event and clock = '1') then
		if (loadRegister = '1') then 
			IQ(0) <= '1';						-- bit de repouso
			IQ(1) <= '0';						-- start bit
			IQ(8 downto 2) <= dadoParalelo;		-- bits do caractere ASCII
			IQ(9) <= paridade;				-- paridade
			IQ(11 downto 10) <= "11";		-- stop bits
		end if;
		
		if (shiftRegister = '1') then 
			saidaSerial <= IQ(0);
			IQ <= '1' & IQ(11 downto 1);
		end if;
    end if;
    
    conteudoRegistrador <= IQ;     
	end process;
end exemplo;