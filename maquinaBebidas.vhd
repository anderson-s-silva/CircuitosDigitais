LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;                  -- Biblioteca de funções Padrão 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY Maquininha_Bebida IS PORT ( 				 -- Estrutura 
	entrada: IN  STD_LOGIC_VECTOR(7 DOWNTO 0); -- Vetor com 8 entradas para moedas
	opcao:   OUT STD_LOGIC_VECTOR(1 DOWNTO 0); -- Vetor com opções disponiveis após entrada das moedas
	escolha: IN  STD_LOGIC_VECTOR(1 DOWNTO 0); -- Escolha final da bebida
	disp1:   OUT STD_LOGIC_VECTOR(6 DOWNTO 0); -- Saidas das placas dos Displays
	disp2:   OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
	disp3:   OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
	disp4:   OUT STD_LOGIC_VECTOR(6 DOWNTO 0); 
	disp5:   OUT STD_LOGIC_VECTOR(6 DOWNTO 0));
END Maquininha_Bebida;

ARCHITECTURE Maquina OF Maquininha_Bebida IS  -- Criando a maquina
TYPE estados IS (est_0,est_agua,est_tudo);    -- Dividindo em 3 estados, inicial o qual não é possivel pedir nada, o segundo o qual é possivel pedir agua, e o terceiro onde é possivel pedir qualquer um dos dois
SIGNAL estado: estados;                       -- Criação de sinal que irá indicar qual é a situação atual da maquina

BEGIN
	PROCESS(entrada, escolha)                  -- Função que entrada com as moedinhas e escolha do usuario	
	VARIABLE moedinhas: INTEGER;               -- Contador de moedas 
	BEGIN
		moedinhas := 0;
		
		for I in 0 to 3 loop                    -- Verificação de moedas de 50 centavos
			if (entrada(I) = '1') then
				moedinhas := moedinhas + 5;
			end if;
		end loop;
		for I in 4 to 7 loop                    -- Verificação de moedas de 1 real
			if (entrada(I) = '1') then
				moedinhas := moedinhas + 10;
			end if;
		end loop;

		IF(moedinhas < 15) THEN                 -- Estado Inicial o quão o valor não atinge nenhum dos dois itens 
			estado<= est_0;
		ELSIF(moedinhas >= 15 and moedinhas < 20) THEN 
			estado<= est_agua;
		ELSIF(moedinhas >= 20) THEN
			estado<= est_tudo;
		END IF;
		
		CASE estado IS
			WHEN est_0 =>                        -- 0
				opcao <= "00";                    -- Dois Leds de opções iriam manter desligados 
				IF(moedinhas = 0) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "1111111"; 
					disp2 <= "1111111";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 5) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "1111111"; 
					disp2 <= "0010010";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 10) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "1111001"; 
					disp2 <= "1000000";
					disp1 <= "1000000";
				END IF;
				
				
			WHEN est_agua =>                     -- 1,50
				opcao <= "01";                    -- Irá ascender led da direita que seria a opção agua disponivel
				IF(moedinhas = 15) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "1111001"; 
					disp2 <= "0010010";
					disp1 <= "1000000";
				END IF;
				IF(escolha(0) = '0' AND escolha(1) = '1') THEN --Apenas agua
					disp5 <= "1111111";
					disp4 <= "0001000";
					disp3 <= "0000010";
					disp2 <= "1000001";
					disp1 <= "0001000";
				END IF;
			WHEN est_tudo =>                     --2 Reais ou mais
				opcao <= "11";                    -- Irá ascender ambas as opções
				
				IF(moedinhas = 20) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0100100"; 
					disp2 <= "1000000";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 25) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0100100"; 
					disp2 <= "0010010";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 30) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0110000"; 
					disp2 <= "1000000";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 35) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0110000"; 
					disp2 <= "0010010";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 40) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0011001"; 
					disp2 <= "1000000";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 45) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0011001"; 
					disp2 <= "0010010";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 50) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0010010"; 
					disp2 <= "1000000";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 55) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0010010"; 
					disp2 <= "0010010";
					disp1 <= "1000000";
				END IF;
				IF(moedinhas = 60) THEN
					disp5 <= "1111111";
					disp4 <= "1111111";
					disp3 <= "0000010"; 
					disp2 <= "1000000";
					disp1 <= "1000000";
				END IF;
				IF(escolha(0) = '0' AND escolha(1) = '1') THEN --Agua
					opcao <= "01";
					disp5 <= "1111111";
					disp4 <= "0001000";
					disp3 <= "0000010";
					disp2 <= "1000001";
					disp1 <= "0001000";
				ELSIF(escolha(0) = '1' AND escolha(1) = '0') THEN --Refri
					opcao <= "10";
					disp5 <= "1001110";
					disp4 <= "0000110";
					disp3 <= "0001110";
					disp2 <= "1001110";
					disp1 <= "1111001";
				END IF;
		END CASE;
	END PROCESS;	
END ARCHITECTURE Maquina; 
