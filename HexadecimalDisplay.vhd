library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity HexadecimalDisplay is
    port(
    	data : in std_logic_vector(3 downto 0);
		segs : out std_logic_vector(6 downto 0)
	);
end HexadecimalDisplay;

architecture arch of HexadecimalDisplay is
begin
    process (data) is
    begin
	    case data is			
			when "0000" => segs <= "1000000"; -- 0
			when "0001" => segs <= "1111001"; -- 1
			when "0010" => segs <= "0100100"; -- 2
			when "0011" => segs <= "0110000"; -- 3
			when "0100" => segs <= "0011001"; -- 4
			when "0101" => segs <= "0010010"; -- 5
			when "0110" => segs <= "0000010"; -- 6
			when "0111" => segs <= "1111000"; -- 7
			when "1000" => segs <= "0000000"; -- 8
			when "1001" => segs <= "0011000"; -- 9
			when "1010" => segs <= "0001000"; -- A
			when "1011" => segs <= "0000011"; -- b
			when "1100" => segs <= "1000110"; -- c
			when "1101" => segs <= "0100001"; -- d
			when "1110" => segs <= "0000110"; -- E
			when others => segs <= "0001110"; -- F
	    end case;
    end process;
end arch;