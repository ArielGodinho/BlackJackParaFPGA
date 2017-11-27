-- Contador 4-bits - (0 to 15)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Counter_4b is
port( clock: in std_logic;
    reset: in std_logic;
    count: out std_logic_vector(0 to 3));
end Counter_4b;

architecture arch of Counter_4b is
    signal temp: std_logic_vector(0 to 3);
begin
    process(clock, reset)
    begin   
    if reset='1' then
        temp <= "0000";
    elsif(rising_edge(clock)) then
        temp <= temp + 1;
    end if;
    end process;
    count <= temp;
end arch;