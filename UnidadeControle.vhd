-- VHDL da Unidade de Controle

library ieee;
use ieee.std_logic_1164.all;

entity UnidadeControle is
   port(clock, dados, reset : in std_logic;
        subClockRunning : in std_logic;
    	count: in std_logic_vector(0 to 3);
        control    : out  std_logic_vector(3 downto 0));  -- resetClock|resetCounter|resetRegister|enableRegister
end UnidadeControle;

architecture exemplo of UnidadeControle is
type tipo_estado is (waiting, preparing, receiving, verifying);
signal estado   : tipo_estado;
   
begin
	process (clock, estado, reset, dados, subClockRunning)
	begin   
		if reset = '1' then
			estado <= waiting;
	         
		elsif (clock'event and clock = '1') then
			case estado is
				when waiting =>			-- Aguarda sinal 0 de inicio dos dados
					if dados = '0' then
						estado <= preparing;
					else
						estado <= waiting;
					end if;

				when preparing =>		-- Espera o Gerador de Clock resetar
					if subClockRunning = '1' then
						estado <= receiving;
					else
						estado <= preparing;
					end if;
	               
				when receiving =>		-- Recebe os dados seriais, armazenando no Registrador Deslocador
					if count = "1001" then
						estado <= verifying;
					else
						estado <= receiving;
					end if;
	                              
				when verifying => 				-- Fim da recepcao serial
				if count = "1011" then
					estado <= waiting;
				else
					estado <= verifying;
				end if;
						
			end case;
		end if;
	end process;
   
	process (clock, estado)
	begin
		case estado is
			when waiting =>
				control <= "1100";
			when preparing =>
				control <= "0010";
			when receiving =>
				control <= "0001";
			when verifying =>
				control <= "0000";
		end case;
   end process;
end exemplo;