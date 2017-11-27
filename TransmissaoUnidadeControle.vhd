-- VHDL da Unidade de Controle

library ieee;
use ieee.std_logic_1164.all;

entity TransmissaoUnidadeControle is
   port(clock, reset, enviar	: in std_logic;
    	count 					: in std_logic_vector(0 to 3);

    	pronto					: out std_logic;
    	resetCount 				: out std_logic; 
        loadRegister       		: out std_logic; 
        shiftRegister      		: out std_logic
    );
end TransmissaoUnidadeControle;

architecture exemplo of TransmissaoUnidadeControle is
type tipo_estado is (waiting, transmitting, done);
signal estado : tipo_estado;
   
begin
	process (clock, reset, enviar, count)
	begin   
		if reset = '1' then
			estado <= waiting;	         
		elsif(rising_edge(clock)) then
			case estado is
				when waiting =>			-- Aguarda sinal 1 de inicio da transmissao
					if enviar = '1' then
						estado <= transmitting;
					else
						estado <= waiting;
					end if;

				when transmitting =>		-- espera o contador chegar a 11 para parar de transmitir
					if count = "1100" then
						estado <= done;
					else
						estado <= transmitting;
					end if;
				
				when done =>		-- espera o enviar ser levantado para ir para espera
					if enviar = '0' then
						estado <= waiting;
					else
						estado <= done;
					end if;
						
			end case;
		end if;
	end process;
   
	process (clock, estado)
	begin
		case estado is
			when waiting =>
				pronto <= '1';
				resetCount <= '1';
				loadRegister <= '1';
				shiftRegister <= '0';
			when transmitting =>
				pronto <= '0';
				resetCount <= '0';
				loadRegister <= '0';
				shiftRegister <= '1';
			when done =>
				pronto <= '1';
				resetCount <= '1';
				loadRegister <= '0';
				shiftRegister <= '0';
		end case;
   end process;
end exemplo;