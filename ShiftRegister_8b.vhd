library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister_8b is
	port(
	clock, clear, enable : in std_logic;
	inputData			 : in std_logic;
	parity 				 : out std_logic;
	data				 : out std_logic_vector(7 downto 0));
end ShiftRegister_8b;

architecture arch of ShiftRegister_8b is
    signal temp: std_logic_vector(7 downto 0);
    signal temp2: std_logic;
begin
	process (clock, clear, enable)
	begin
		if clear = '1' then
			temp <= "00000000";
		elsif (rising_edge(clock) and enable='1') then
			temp(7 downto 1) <= temp(6 downto 0);
			temp(0) <= inputData;
		end if;
		temp2 <= not (temp(7) xor temp(6) xor temp(5) xor temp(4) xor temp(3) xor temp(2) xor temp(1) xor temp(0));
	end process;
    data <= temp;
    parity <= temp2;
end arch;