library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity Printer is
	port(clock : in std_logic;
		reset           : in  std_logic;
		imprime         : in  std_logic;
		fim_transmissao : in  std_logic;
		player0CardsSum : in  std_logic_vector(13 downto 0);
		player1CardsSum : in  std_logic_vector(13 downto 0);
		result          : in  std_logic_vector(6 downto 0);
		transmite_dado  : out std_logic;
		saida           : out std_logic_vector(6 downto 0);
		debugContagem   : out std_logic_vector(3 downto 0);
		debugEstado     : out std_logic_vector(2 downto 0)
	);
	
	
end Printer;

architecture exemplo of Printer is
	
	type tipo_estado is (inicial, imprime_char, espera, delay, prox_char);
	signal estado : tipo_estado;
	
	
	signal A           : std_logic_vector(6 downto 0) := "1000001";
	signal B           : std_logic_vector(6 downto 0) := "1000010";
	signal C           : std_logic_vector(6 downto 0) := "1000011";
	signal D           : std_logic_vector(6 downto 0) := "1000100";
	signal E           : std_logic_vector(6 downto 0) := "1000101";
	signal F           : std_logic_vector(6 downto 0) := "1000110";
	signal G           : std_logic_vector(6 downto 0) := "1000111";
	signal H           : std_logic_vector(6 downto 0) := "1001000";
	signal I           : std_logic_vector(6 downto 0) := "1001001";
	signal J           : std_logic_vector(6 downto 0) := "1001010";
	signal K           : std_logic_vector(6 downto 0) := "1001011";
	signal L           : std_logic_vector(6 downto 0) := "1001100";
	signal M           : std_logic_vector(6 downto 0) := "1001101";
	signal N           : std_logic_vector(6 downto 0) := "1001110";
	signal O           : std_logic_vector(6 downto 0) := "1001111";
	signal P           : std_logic_vector(6 downto 0) := "1010000";
	signal Q           : std_logic_vector(6 downto 0) := "1010001";
	signal R           : std_logic_vector(6 downto 0) := "1010010";
	signal S           : std_logic_vector(6 downto 0) := "1010011";
	signal T           : std_logic_vector(6 downto 0) := "1010100";
	signal U           : std_logic_vector(6 downto 0) := "1010101";
	signal V           : std_logic_vector(6 downto 0) := "1010110";
	signal W           : std_logic_vector(6 downto 0) := "1010111";
	signal X           : std_logic_vector(6 downto 0) := "1011000";
	signal Y           : std_logic_vector(6 downto 0) := "1011001";
	signal Z           : std_logic_vector(6 downto 0) := "1011010";
	signal ESP         : std_logic_vector(6 downto 0) := "0100000";
	signal DOIS_PONTOS : std_logic_vector(6 downto 0) := "0111010";
	signal CR          : std_logic_vector(6 downto 0) := "0001101";
	signal LF          : std_logic_vector(6 downto 0) := "0001010";
	signal ZERO        : std_logic_vector(6 downto 0) := "0110000";
	signal ONE         : std_logic_vector(6 downto 0) := "0110001";
	signal TWO         : std_logic_vector(6 downto 0) := "0110010";
	signal THREE       : std_logic_vector(6 downto 0) := "0110011";
	signal FOUR        : std_logic_vector(6 downto 0) := "0110100";
	signal FIVE        : std_logic_vector(6 downto 0) := "0110101";
	signal SIX         : std_logic_vector(6 downto 0) := "0110110";
	signal SEVEN       : std_logic_vector(6 downto 0) := "0110111";
	signal EIGHT       : std_logic_vector(6 downto 0) := "0111000";
	signal NINE        : std_logic_vector(6 downto 0) := "0111001";
	
	
	
	
	component PrinterCounter is
		port(clock : in std_logic;
			clear    : in  std_logic;
			enable   : in  std_logic;
			contagem : out std_logic_vector(3 downto 0);
			fim      : out std_logic);
	end component;
	
	
	signal conta, fim_conta : std_logic;
	signal contagem         : std_logic_vector(3 downto 0);
	signal delayCount       : integer := 0;
	
begin
	
		cont : PrinterCounter port map(clock, '0', conta, contagem, fim_conta);
	debugContagem <= contagem;
	
	process (clock, fim_transmissao)
	begin
		
		
		if reset = '1' then
			estado     <= inicial;
			delayCount <= 0;
			
		elsif (clock'event and clock = '1') then
			case estado is
				when inicial => 
					if imprime = '1' then
						estado <= imprime_char;
					end if;
					
				when imprime_char => 
					estado <= espera;
					
				when espera => 
					if fim_transmissao = '1' then
						estado     <= delay;
						delayCount <= 0;
					end if;
					
				when delay => 
					if delayCount = 50 then
						estado <= prox_char;
					else
						delayCount <= delayCount + 1;
					end if;
					
				when prox_char => 
					if fim_conta = '1' then
						estado <= inicial;
					else
						estado <= imprime_char;
					end if;
					
					
			end case;
			
		end if;
		
		
	end process;
	
	
	process (estado)
	begin
		case estado is
			when inicial => 
				transmite_dado <= '0';
				conta          <= '0';
				debugEstado    <= "000";
				
			when imprime_char => 
				transmite_dado <= '1';
				conta          <= '0';
				debugEstado    <= "001";
			when espera => 
				transmite_dado <= '0';
				conta          <= '0';
				debugEstado    <= "010";
				
			when delay => 
				transmite_dado <= '0';
				conta          <= '0';
				debugEstado    <= "011";
				
			when prox_char => 
				transmite_dado <= '0';
				conta          <= '1';
				debugEstado    <= "100";
		end case;
	end process;
	
	
	process(contagem)
	begin
		if unsigned(contagem) = 0 then
			if result = "1000000" then
				saida <= ZERO;
			elsif result = "1111001" then
				saida <= ONE;
			elsif result = "0100100" then
				saida <= TWO;
			elsif result = "0110000" then
				saida <= THREE;
			end if;
			
		elsif unsigned(contagem) = 1 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 2 then
			if player0CardsSum(13 downto 7) = "1000000" then
				saida <= ZERO;
			elsif player0CardsSum(13 downto 7) = "1111001" then
				saida <= ONE;
			elsif player0CardsSum(13 downto 7) = "0100100" then
				saida <= TWO;
			elsif player0CardsSum(13 downto 7) = "0110000" then
				saida <= THREE;
			elsif player0CardsSum(13 downto 7) = "0011001" then
				saida <= FOUR;
			elsif player0CardsSum(13 downto 7) = "0010010" then
				saida <= FIVE;
			elsif player0CardsSum(13 downto 7) = "0000010" then
				saida <= SIX;
			elsif player0CardsSum(13 downto 7) = "1111000" then
				saida <= SEVEN;
			elsif player0CardsSum(13 downto 7) = "0000000" then
				saida <= EIGHT;
			elsif player0CardsSum(13 downto 7) = "0011000" then
				saida <= NINE;
			elsif player0CardsSum(13 downto 7) = "0001000" then
				saida <= A;
			elsif player0CardsSum(13 downto 7) = "0000011" then
				saida <= B;
			elsif player0CardsSum(13 downto 7) = "1000110" then
				saida <= C;
			elsif player0CardsSum(13 downto 7) = "0100001" then
				saida <= D;
			elsif player0CardsSum(13 downto 7) = "0000110" then
				saida <= E;
			elsif player0CardsSum(13 downto 7) = "0001110" then
				saida <= F;
			end if;
			
		elsif unsigned(contagem) = 3 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 4 then
			if player0CardsSum(6 downto 0) = "1000000" then
				saida <= ZERO;
			elsif player0CardsSum(6 downto 0) = "1111001" then
				saida <= ONE;
			elsif player0CardsSum(6 downto 0) = "0100100" then
				saida <= TWO;
			elsif player0CardsSum(13 downto 0) = "0110000" then
				saida <= THREE;
			elsif player0CardsSum(6 downto 0) = "0011001" then
				saida <= FOUR;
			elsif player0CardsSum(6 downto 0) = "0010010" then
				saida <= FIVE;
			elsif player0CardsSum(6 downto 0) = "0000010" then
				saida <= SIX;
			elsif player0CardsSum(6 downto 0) = "1111000" then
				saida <= SEVEN;
			elsif player0CardsSum(6 downto 0) = "0000000" then
				saida <= EIGHT;
			elsif player0CardsSum(6 downto 0) = "0011000" then
				saida <= NINE;
			elsif player0CardsSum(6 downto 0) = "0001000" then
				saida <= A;
			elsif player0CardsSum(6 downto 0) = "0000011" then
				saida <= B;
			elsif player0CardsSum(6 downto 0) = "1000110" then
				saida <= C;
			elsif player0CardsSum(6 downto 0) = "0100001" then
				saida <= D;
			elsif player0CardsSum(6 downto 0) = "0000110" then
				saida <= E;
			elsif player0CardsSum(6 downto 0) = "0001110" then
				saida <= F;
			end if;
			
		elsif unsigned(contagem) = 5 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 6 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 7 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 8 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 9 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 10 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 11 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 12 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 13 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 14 then
			saida <= CR;
			
		elsif unsigned(contagem) = 15 then
			saida <= LF;
			
		end if;
		
		
	end process;
	
end exemplo;
