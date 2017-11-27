-- VHDL de um contador de modulo 16

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity PrinterCounter is
	port(clock : in std_logic;
		clear    : in  std_logic;
		enable   : in  std_logic;
		load     : in  std_logic;
		entrada  : in  std_logic_vector(3 downto 0);
		contagem : out std_logic_vector(3 downto 0);
		fim      : out std_logic);
end PrinterCounter;

architecture exemplo of PrinterCounter is
	signal IQ : unsigned(3 downto 0);
	
	
begin
	process (clock, load, IQ, clear)
	begin
		
		if clock'event and clock = '1' then
			if clear = '1' then 
				IQ <= (others => '0');
			elsif load = '1' then
				IQ <= unsigned(entrada);
			elsif enable = '1' then 
				if IQ >= 15 then
					IQ <= (others => '0');
				else 
					IQ <= IQ + 1;
				end if;
			end if;
		end if;
		
		if IQ = 15 then
			fim <= '1';
		else
			fim <= '0';
		end if;
		
		contagem <= std_logic_vector(IQ);
		
	end process;
end exemplo;
