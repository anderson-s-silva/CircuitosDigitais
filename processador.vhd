library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_signed.all;
use ieee.numeric_std.all;
-------------------------------------------------------------------
entity unidadeLogica is 														--cria entidade{
port (address           :  in std_logic_vector (3 DOWNTO 0) ;		--porta 'valor1 e valor2' vetor logico de 7 a 0 (8bits)
      op_code           :  in std_logic_vector (3 DOWNTO 0) ;		--op_code (codigo de operacao) vetor logico de 3 a 0 (4bits)
      en_reg_a          :  in bit;											--endereço registrador a - em bit
		en_reg_b          :  in bit;											--endereço registrador b - em bit
		clk					:  in std_logic;									--clock         
		clk_led           :  out std_logic;									--clock do led
		op_dsp1				:	out std_logic_vector (7 DOWNTO 0) ;		--operacao no display 1
		op_dsp2				:	out std_logic_vector (7 DOWNTO 0) ;		--operacao no display 2
		resultado         :  out std_logic_vector (7 DOWNTO 0));  --resultado da operacao, vetor logico 7 a 0 (8bits)
end unidadeLogica ;																--fim da entidade}

-------------------------------------------------------------------
architecture logic of unidadeLogica is										--implementações do projeto; descreve as relações entre as portas.{
	signal saida: STD_LOGIC_VECTOR(7 DOWNTO 0);							--objeto da arquitetura; saida do tipo vetor logico de 7 a 0 (8bits)
   type mem_t is array (0 to 15) of std_logic_vector(15 downto 0);
	signal mem : mem_t;
	
BEGIN																					--corpo da arquitetura; especifica comportamento da arquitetura
    PROCESS(saida, mem, op_code, address, en_reg_a, en_reg_b, clk)--indica quais são as variáveis e sinais cuja alteração deve levar à reavaliação da saída.{
    VARIABLE data_i		: std_logic_vector(15 DOWNTO 0)	;			--data_i; vetor logico para imput de dados; vai de 15 a 0 (16bits)
	 VARIABLE data_o		: std_logic_vector(15 DOWNTO 0)	;			--data_o; vetor logico para output de dados; vai de 15 a 0 (16bits)
	 VARIABLE valor1		: std_logic_vector(7 DOWNTO 0)	;			--valor1; vetor logico de 7 a 0 (8bits)
	 VARIABLE valor2		: std_logic_vector(7 DOWNTO 0)	;			--valor2; vetor logico de 7 a 0 (8bits)
	 VARIABLE reg_a 		: std_logic_vector(7 DOWNTO 0)	:= "00000000";--registrador a do tipo vetor logico de 7 a 0 (8bits)
	 VARIABLE reg_b	 	: std_logic_vector(7 DOWNTO 0) 	:= "00000000";--registrador b do tipo vetor logico de 7 a 0 (8bits)
	 VARIABLE resto 		: std_logic_vector(7 DOWNTO 0)	;			--resto do tipo variavel, vetor logico 7 a 0 (8bits); usado para calculo
    VARIABLE quociente	: std_logic_vector(7 DOWNTO 0)	;			--quociente do tipo variavel, vetor logico 7 a 0 (8bits); usado para calculo
    
	 BEGIN																			--comeco da descricao das operacoes do processador

			data_i := mem(to_integer(unsigned(address)));
			
			for I in 0 to 7 loop
				valor2(I) := data_i(I);
			end loop;
		   
			for I in 0 to 7 loop
				valor1(I) := data_i(I+8);
			end loop;
				
			if en_reg_a = '0' and en_reg_b = '0' then 						--se o endereco do registrador A esta em '0' e o de B tambem esta em '0' começa as operaçoes porque eu tenho conteudo para trabalhar
				-----------SOMA-----------------
				if (op_code = "0000") then											--se meu codigo de operacao for '0000' entao sera feito uma soma entre valor1 e valor2
					op_dsp1 <= "10100001";											--exibe operacao no display 1
					op_dsp2 <= "10001000";											--exibe operacao no display 2
					saida <= valor1 + valor2;
				-----------SUBTRAÇAO------------	
				elsif (op_code = "0001") then										--se nao, se meu codigo de operacao for '0001' entao sera feito uma subtracao entre valor1 e valor2
					op_dsp1 <= "10000011";											--exibe operacao no display 1
					op_dsp2 <= "10010010";											--exibe operacao no display 2
					saida <= valor1 - valor2;
				-----------MULTIPLICAÇAO--------
				elsif (op_code = "0010") then										--se nao, se meu codigo de operacao for '0010' entao sera feito uma multiplicacao entre valor1 e valor2 (multiplicacao com somas usando for ou recursao)
					op_dsp1 <= "11000110";											--exibe operacao no display 1
					op_dsp2 <= "11110000";											--exibe operacao no display 2
					data_o := valor1 * valor2;
					for I in 0 to 7 loop
						saida(I) <= data_o(I);
					end loop;
				-----------DIVISAO-------------
				elsif (op_code = "0011") then										--se nao, se meu codigo de operacao for '0011' entao sera feito uma divisao entre valor1 e valor2 (divisao com subtracoes usando for ou recursao)
					op_dsp1 <= "11001111";											--exibe operacao no display 1
					op_dsp2 <= "10100001";											--exibe operacao no display 2
					resto := valor1;
					quociente := "00000000";
					for I in 0 to 255 loop
						 resto := resto - valor2;
						 quociente := quociente + 1;
						 if resto < valor2 then
							  exit;
						 end if;
					end loop;
					saida <= quociente;
				----------IGUAL?----------------
				elsif (op_code = "0100") then                            --se nao, se meu codigo de operacao for '0100' entao sera verificado se 'valor1' = 'valor2'
					op_dsp1 <= "11111111";											--exibe operacao no display 1
					op_dsp2 <= "10110111";											--exibe operacao no display 2
					resto := valor1 - valor2;
					if resto = "00000000" then
						saida <= "00000001";
					else
						saida <= "00000000";
					end if;
				---------MAIOR QUE--------------
				elsif (op_code = "0101") then                            --se nao, se meu codigo de operacao for '0101' entao sera verificado se 'valor1' > 'valor2'
					op_dsp1 <= "11111111";											--exibe operacao no display 1
					op_dsp2 <= "10110011";											--exibe operacao no display 2
					resto := valor1 - valor2;
					if resto = "00000000" then
						saida <= "00000000";
					elsif resto(7) = '0' then
						saida <= "00000001";
					else
						saida <= "00000000";
					end if;
				---------MENOR QUE--------------
				elsif (op_code = "0110") then                            --se nao, se meu codigo de operacao for '0011' entao sera verificado se 'valor1' < 'valor2'
					op_dsp1 <= "11111111";											--exibe operacao no display 1
					op_dsp2 <= "10100111";											--exibe operacao no display 2
					resto := valor1 - valor2;
					if resto(7) = '1' then
						saida <= "00000001";
					elsif resto = "00000000" then
						saida <= "00000000";
					else
						saida <= "00000000";
					end if;
				---------MAIOR OU IGUAL---------
				elsif (op_code = "0111") then                            --se nao, se meu codigo de operacao for '0111' entao sera verificado se 'valor1' >= 'valor2'
					op_dsp1 <= "10110111";											--exibe operacao no display 1
					op_dsp2 <= "10110011";											--exibe operacao no display 2
					resto := valor1 - valor2;
					if resto(7) = '0' then
						saida <= "00000001";				
					else
						saida <= "00000000";
					end if;
				---------MENOR OU IGUAL---------
				elsif (op_code = "1000") then                            --se nao, se meu codigo de operacao for '1000' entao sera verificado se 'valor1' <= 'valor2'
					op_dsp1 <= "10110111";											--exibe operacao no display 1
					op_dsp2 <= "10100111";											--exibe operacao no display 2
					resto := valor1 - valor2;
					if resto(7) = '1' or resto = "00000000" then
						saida <= "00000001";				
					else
						saida <= "00000000";
					end if;
				----------DIFERENTE-------------
				elsif (op_code = "1001") then                            --se nao, se meu codigo de operacao for '1001' entao sera verificado se 'valor1' diferente de 'valor2'
					op_dsp1 <= "10110111";											--exibe operacao no display 1
					op_dsp2 <= "11111011";											--exibe operacao no display 2
					resto := valor1 - valor2;
					if resto = "00000000" then
						saida <= "00000000";
					else
						saida <= "00000001";
					end if;
				--OP. MOVE DO REGISTRADOR B PARA O A
				elsif (op_code = "1010") then										--move reg_a <- reg_b
					op_dsp2 <= "10000011";											--exibe operacao no display 2
					op_dsp1 <= "10001000";											--exibe operacao no display 1
					if clk = '0' then													--se o clock esta em 0 começa o move do registrador B para o registrador A
						reg_a := reg_b;
					end if;
				--OP. MOVE DO REGISTRADOR A PARA O B
				elsif (op_code = "1011") then                            --move reg_b <- reg_a
					op_dsp1 <= "10000011";											--exibe operacao no display 1
					op_dsp2 <= "10001000";											--exibe operacao no display 2
					if clk = '0' then													--se o clock esta em 0 começa o move do registrador A para o registrador B
						reg_b := reg_a;
					end if;
				--OP. LOAD DA MEMORIA PARA O REGISTRADOR
				elsif (op_code = "1100") then 									--load (reg <- mem)
					op_dsp1 <= "11000000";											--exibe operacao no display 1
					op_dsp2 <= "11000111";											--exibe operacao no display 2
					if clk = '0' then													--se o clock esta em 0 começa o load da memoria para o registrador
						for I in 0 to 7 loop
							reg_b(I) := data_i(I);
						end loop;
						for I in 0 to 7 loop
							reg_a(I) := data_i(I+8);
						end loop;
					end if;
				--OP. STORE DOS REGISTRADORES PARA A MEMORIA
				elsif (op_code = "1101") then										--store (mem <- reg)
					op_dsp1 <= "10000110";											--exibe operacao no display 1
					op_dsp2 <= "10010010";											--exibe operacao no display 2
					if clk = '0' then													--se o clock esta em 0 sera armazenado o imput de dados no registrador B e no registrador A
						for I in 0 to 7 loop
							data_o(I)   := reg_b(I);
						end loop;
						for I in 0 to 7 loop
							data_o(I+8) := reg_a(I);
						end loop;
						mem(to_integer(unsigned(address))) <= data_o;
					end if;
				end if; 
		   elsif en_reg_a = '1' and en_reg_b = '0' then						--se o endereco do registrador A esta em '1' e o de B esta em '0' sera preciso inserir conteudo no registrador A
				op_dsp1 <= "10001000";												--exibe operacao no display 1
				op_dsp2 <= "11000111";												--exibe operacao no display 2
				if clk = '0' then														--se o clock esta em 0 começa o imput de dados para o registrador A
					for I in 0 to 3 loop
						reg_a(I+4) := op_code(I);
					end loop;
					for I in 0 to 3 loop
						reg_a(I) := address(I);
					end loop;
				end if;
				saida <= reg_a;
			elsif en_reg_a = '0' and en_reg_b = '1' then						--se o endereco do registrador A esta em '0' e o de B esta em '1' sera preciso inserir conteudo no registrador B
				op_dsp1 <= "10000011";												--exibe operacao no display 1
				op_dsp2 <= "11000111";												--exibe operacao no display 2
				if clk = '0' then														--se o clock esta em 0 começa o imput de dados para o registrador B
					for I in 0 to 3 loop
						reg_b(I+4) := op_code(I);
					end loop;
					for I in 0 to 3 loop
						reg_b(I) := address(I);
					end loop;
				end if;
				saida <= reg_b;
			else																			--reset memória, reg_a, reg_b, saida
				op_dsp1 <= "10010010";												--exibe operacao no display 1
				op_dsp2 <= "11001110";												--exibe operacao no display 2
				if clk = '0' then														--se o clock esta em 0 a memoria sera resetada junto dos registradores e da saida 	
					for I in 0 to 15 loop
						mem(I) <= "0000000000000000";
					end loop;
					reg_a := "00000000";
					reg_b := "00000000";
					saida <= "00000000";
				end if;
			end if;
			
			clk_led <= clk;
		   resultado <= saida;
		  
    end PROCESS;																		--fim da descricao das variaveis que influenciam na saida}
end architecture ; 																	--fim da descricao das relacoes entre as portas logicas}
--DOCUMENTACAO--
--------------------------------------------------------------
--MANUAL OPCODE-
--SOMA				-	COD	-	'0000'
--SUBTRACAO			-	COD	-	'0001'
--MULTIPLICACAO	-	COD	-	'0010'
--DIVISAO			-	COD	-	'0011'
--IGUALDADE			-	COD	-	'0100'
--MAIOR QUE			-	COD	-	'0101'
--MENOR QUE			-	COD	-	'0110'
--MAIOR OU IGUAL	-	COD	-	'0111'
--MENOR OU IGUAL	-	COD	-	'1000'
--DIFERENTE			-	COD	-	'1001'
---------------------------------------------------------------
--MANUAL OPCODE EXTRA-
--OP. MOVE DO REGISTRADOR B PARA O A		-	COD	-	'1010'
--OP. MOVE DO REGISTRADOR A PARA O B		-	COD	-	'1011'
--OP. LOAD DA MEMORIA PARA O REGISTRADOR 	-	COD	-	'1100'
--OP. STORE DO REGISTRADOR PARA A MEMORIA	-	COD	-	'1101'
---------------------------------------------------------------
--SWITCHES- 
--NAME-   PINO		-	      FUNÇAO
--SW0 - PIN_C10	-	ENDEREÇO DE MEMORIA
--SW1 - PIN_C11	-	ENDEREÇO DE MEMORIA
--SW2 - PIN_D12	-	ENDEREÇO DE MEMORIA
--SW3 - PIN_C12	-	ENDEREÇO DE MEMORIA
--SW4 - PIN_A12	-	OPCODE
--SW5 - PIN_B12 	-	OPCODE
--SW6 - PIN_A13 	-	OPCODE
--SW7 - PIN_A14	-	OPCODE
--SW8 - PIN_B14	-	SELETOR DE REGISTRADOR
--SW9 - PIN_F15 	-	SELETOR DE REGISTRADOR
--------------------------------------------------------------
--BOTOES- 
--NAME  -  PINO		-	      FUNÇAO
--KEY1  - PIN_A7 		- HABILITAR IMPUT DE DADOS NO REGISTRADOR
--------------------------------------------------------------
--LEDS- 
--NAME  -  PINO		-	      FUNÇAO
--LEDR0 - PIN_A8		- RESULTADO DA OPERAÇAO PROPOSTA
--LEDR1 - PIN_A9     - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR2 - PIN_A10    - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR3 - PIN_B10    - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR4 - PIN_D13    - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR5 - PIN_C13    - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR6 - PIN_E14    - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR7 - PIN_D14    - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR8 - PIN_A11    - RESULTADO DA OPERAÇAO PROPOSTA
--LEDR9 - PIN_B11		- RESULTADO DA OPERAÇAO PROPOSTA
