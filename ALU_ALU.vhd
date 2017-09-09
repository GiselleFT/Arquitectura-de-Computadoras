----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:01:04 09/03/2017 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
-- Project Name:   	P1: ALU
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU_ALU is
		GENERIC( N : INTEGER := 4 );
		Port ( A : in  STD_LOGIC_VECTOR (N-1 downto 0);
			B : in  STD_LOGIC_VECTOR (N-1 downto 0);
         BINVERT : in  STD_LOGIC;
			AINVERT : in  STD_LOGIC;
			OP : in  STD_LOGIC_VECTOR (1 downto 0);
         RES : inout  STD_LOGIC_VECTOR (N-1 downto 0);
         CN : out  STD_LOGIC;
			Z : out  STD_LOGIC;
			NEG : out  STD_LOGIC;
			OV : out  STD_LOGIC			
			);
			

end ALU_ALU;

architecture Behavioral of ALU_ALU is
	begin
	
	PALU : PROCESS( A, B, AINVERT, BINVERT, OP)
	VARIABLE MUXB, MUXA, P, G, RESAUX : STD_LOGIC_VECTOR(N-1 DOWNTO 0);-- Variable:=
	VARIABLE C :  STD_LOGIC_VECTOR(N DOWNTO 0);
	VARIABLE PK, T2, T3, PL, ZAUX : STD_LOGIC;
	BEGIN
		C := (OTHERS => '0'); --INICIALIZACION DE ARREGLO
		P := (OTHERS => '0');
		G := (OTHERS => '0');
		C(0) := BINVERT;
		
		FOR I IN 0 TO N-1 LOOP
		MUXA(I):= A(I) XOR AINVERT;
		MUXB(I):= B(I) XOR BINVERT;
			CASE OP IS
				WHEN "00" =>
					RES(I) <= MUXA(I) AND MUXB(I);
				WHEN "01" =>
					RES(I) <= MUXA(I)OR MUXB(I);
				WHEN "10" =>
					RES(I) <= MUXA(I) XOR MUXB(I);
				WHEN OTHERS =>
					P(I) := MUXA(I) XOR MUXB(I);
					G(I) := MUXA(I) AND MUXB(I);
					RES(I) <= MUXA(I) XOR MUXB(I) XOR C(I); --  Señales <=
					--Para Ecuacion Ci+1
					T2 := '0';--Se inicializa en 0 por ser OR
					FOR J IN 0 TO I-1 LOOP
						PK := '1';--Se inicializa en 1 por ser AND
						FOR K IN J+1 TO I LOOP
							PK := PK AND P(K);
						END LOOP;--K
						T2 := T2 OR (G(J) AND PK);
					END LOOP;--J
					
					T3 := C(0);--inicializa AND
					PL := '1';
					FOR L IN 0 TO I LOOP
						PL := PL AND P(L);
					END LOOP;--L
					T3 := T3 AND PL;
					C(I+1) := G(I) OR T2 OR T3; 
			END CASE;
					RESAUX(I) := RES(I);
		END LOOP;--I
		
		--Chequeo de banderas
		CN <= C(N);--BANDERA: Acarreo final
		ZAUX := '1';--Se inicializa ZAUX
		FOR M IN 0 TO N-1 LOOP
			ZAUX := ZAUX NOR RESAUX(M); --BANDERA: Z (Si N es par Z se inicia con 1, si N es impar Z se inicia con 0
		END LOOP;--M 
		Z <= ZAUX;
		NEG <= RESAUX(N-1);--BANDERA: N
		OV <= C(N) XOR C(N-1);
		
	END PROCESS PALU;
end Behavioral;


