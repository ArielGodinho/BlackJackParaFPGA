library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity imprime_vencedor is
	port(clock : in std_logic;
		reset           : in  std_logic;
		imprime         : in  std_logic;
		fim_transmissao : in  std_logic;
		player0CardsSum : in  std_logic_vector(13 downto 0);
		player1CardsSum : in  std_logic_vector(13 downto 0);
		result          : in  std_logic_vector(6 downto 0);
		transmite_dado  : out std_logic;
		saida           : out std_logic_vector(6 downto 0)
	);
	
	
end imprime_vencedor;

architecture exemplo of imprime_vencedor is
	
	type tipo_estado is (inicial, imprime_char, espera, prox_char, final);
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
	
	
	
	
	component PrinterCounter is
		port(clock : in std_logic;
			tick     : in  std_logic;
			clear    : in  std_logic;
			enable   : in  std_logic;
			contagem : out std_logic_vector(3 downto 0);
			fim      : out std_logic);
	end component;
	
	
	signal conta, fim_conta : std_logic;
	signal contagem         : std_logic_vector(3 downto 0);
	
begin
	
		cont : PrinterCounter port map(clock, '1', reset, conta, contagem, fim_conta);
	
	process (clock, fim_transmissao)
	begin
		
		
		if reset = '1' then
			estado <= inicial;
			
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
						estado <= prox_char;
					end if;
					
				when prox_char => 
					if fim_conta = '1' then
						estado <= final;
					else
						estado <= imprime_char;
					end if;
					
				when final => 
					
					
			end case;
			
		end if;
		
		
	end process;
	
	
	process (estado)
	begin
		case estado is
			when inicial => 
				transmite_dado <= '0';
				conta          <= '0';
				
			when imprime_char => 
				transmite_dado <= '1';
				conta          <= '0';
			when espera => 
				transmite_dado <= '0';
				conta          <= '0';
				
			when prox_char => 
				transmite_dado <= '0';
				conta          <= '1';
				
			when final => 
				transmite_dado <= '0';
				conta          <= '0';
		end case;
	end process;
	
	
	process(contagem)
	begin
		if unsigned(contagem) = 0 then
			saida <= O;
			
		elsif unsigned(contagem) = 1 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 2 then
			saida <= V;
			
		elsif unsigned(contagem) = 3 then
			saida <= E;
			
		elsif unsigned(contagem) = 4 then
			saida <= N;
			
		elsif unsigned(contagem) = 5 then
			saida <= C;
			
		elsif unsigned(contagem) = 6 then
			saida <= E;
			
		elsif unsigned(contagem) = 7 then
			saida <= D;
			
		elsif unsigned(contagem) = 8 then
			saida <= O;
			
		elsif unsigned(contagem) = 9 then
			saida <= R;
			
		elsif unsigned(contagem) = 10 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 11 then
			saida <= E;
			
		elsif unsigned(contagem) = 12 then
			saida <= H;
			
		elsif unsigned(contagem) = 13 then
			saida <= DOIS_PONTOS;
			
		elsif unsigned(contagem) = 14 then
			saida <= ESP;
			
		elsif unsigned(contagem) = 15 then
			saida <= CR;
			
		elsif unsigned(contagem) = 15 then
			saida <= LF;
			
		end if;
		
		
	end process;
	
end exemplo;
