-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.15:39:49)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY jpegsd_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18: IN unsigned(0 TO 3);
		output1, output2, output3: OUT unsigned(0 TO 4));
END jpegsd_random_entity;

ARCHITECTURE jpegsd_random_description OF jpegsd_random_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register2: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register3: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register4: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register5: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register6: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register7: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register8: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register9: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register10: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register11: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register12: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register13: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register14: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register15: unsigned(0 TO 4) := "00000";
BEGIN

	moore_machine: PROCESS(clk, reset)
	BEGIN
		IF reset = '0' THEN
			current_state <= "00000000";
		ELSIF clk = '1' AND clk'event THEN
			IF current_state < 4 THEN
				current_state <= current_state + 1;
			END IF;
		END IF;
	END PROCESS moore_machine;

	operations: PROCESS(current_state)
	BEGIN
		CASE current_state IS
			WHEN "00000001" =>
				register1 := input1 + 1;
			WHEN "00000010" =>
				register2 := input2 + 2;
			WHEN "00000011" =>
				register3 := input3 + 3;
				register4 := ((NOT input4) + 1) XOR input4;
			WHEN "00000100" =>
				register5 := input5 + 5;
				register2 := ((NOT register2) + 1) XOR register2;
				register6 := ((NOT input6) + 1) XOR input6;
				register3 := ((NOT register3) + 1) XOR register3;
			WHEN "00000101" =>
				output1 <= input7 + 11;
			WHEN "00000110" =>
				register7 := input8 + 12;
			WHEN "00000111" =>
				register8 := input9 + 13;
			WHEN "00001000" =>
				register9 := input10 + 14;
			WHEN "00001001" =>
				register10 := input11 + 15;
			WHEN "00001010" =>
				register11 := input12 + 16;
			WHEN "00001011" =>
				register12 := input13 + 17;
				register10 := ((NOT register10) + 1) XOR register10;
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00001100" =>
				register13 := input14 + 22;
				register11 := ((NOT register11) + 1) XOR register11;
				register8 := ((NOT register8) + 1) XOR register8;
			WHEN "00001101" =>
				output2 <= input15 + 27;
				register5 := ((NOT register5) + 1) XOR register5;
				register9 := ((NOT register9) + 1) XOR register9;
				register14 := ((NOT input16) + 1) XOR input16;
				register12 := ((NOT register12) + 1) XOR register12;
			WHEN "00001110" =>
				register15 := input17 + 35;
			WHEN "00001111" =>
				register15 := ((NOT register15) + 1) XOR register15;
				register11 := register11 + register12;
				register12 := ((NOT input18) + 1) XOR input18;
				register7 := ((NOT register7) + 1) XOR register7;
			WHEN "00010000" =>
				register7 := register11 + register7;
			WHEN "00010001" =>
				register7 := register7 + register9;
			WHEN "00010010" =>
				register5 := register12 + register5;
				register9 := ((NOT register13) + 1) XOR register13;
			WHEN "00010011" =>
				register4 := register5 + register4;
			WHEN "00010100" =>
				register4 := register4 + register10;
			WHEN "00010101" =>
				register5 := register4 * 44;
				register6 := register6 + register9;
			WHEN "00010110" =>
				register6 := register6 + register14;
			WHEN "00010111" =>
				register6 := register6 + register8;
			WHEN "00011000" =>
				register1 := register6 + register1;
			WHEN "00011001" =>
				register1 := register1 + register2;
			WHEN "00011010" =>
				register1 := register1 + register3;
			WHEN "00011011" =>
				register1 := register1 + register15;
			WHEN "00011100" =>
				register2 := register1 + 46;
			WHEN "00011101" =>
				register3 := register1 + register2 + register7;
			WHEN "00011110" =>
				register1 := register1 * register2 * register3;
			WHEN "00011111" =>
				register1 := register5 + register1;
			WHEN "00100000" =>
				register1 := register4 + register1;
			WHEN "00100001" =>
				register1 := register1 srl 48;
			WHEN "00100010" =>
				output3 <= register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END jpegsd_random_description;