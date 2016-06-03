-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.16:15:41)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesafp_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21: IN unsigned(0 TO 3);
		output1, output2, output3, output4, output5: OUT unsigned(0 TO 4));
END mesafp_random_entity;

ARCHITECTURE mesafp_random_description OF mesafp_random_entity IS
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
	SHARED VARIABLE register16: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register17: unsigned(0 TO 4) := "00000";
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
				register2 := input2 * 2;
				register3 := input3 * 3;
			WHEN "00000010" =>
				register2 := register2 + 5;
				register4 := input4 * 6;
				register5 := input5 * 7;
			WHEN "00000011" =>
				register4 := register4 + 9;
				register6 := input6 * 10;
				register7 := input7 + 11;
				register8 := input8 * 12;
				register9 := input9 * 13;
				register10 := input10 + 14;
				register11 := input11 + 15;
				register12 := input12 * 16;
			WHEN "00000100" =>
				register8 := register8 + 18;
				register13 := input13 * 19;
				register11 := register12 + register11;
				register12 := input14 + 20;
				register14 := input15 + 21;
				register15 := input16 + 22;
				register16 := input17 * 23;
			WHEN "00000101" =>
				register12 := register12 + 25;
				register17 := input18 * 26;
				register10 := register13 + register10;
			WHEN "00000110" =>
				register13 := register17 + register15;
				register15 := input19 * 27;
				register5 := register5 + 29;
				register17 := input20 * 30;
				register6 := register6 + register10;
				register10 := input21 * 31;
				register9 := register9 + register14;
				register11 := register16 + register11;
			WHEN "00000111" =>
				register11 := ((NOT register11) + 1) XOR register11;
			WHEN "00001000" =>
				output1 <= register11(0 TO 1) & register8(0 TO 2);
				register7 := register10 + register7;
				register8 := register15 + register13;
			WHEN "00001001" =>
				register7 := register17 + register7;
				register6 := ((NOT register6) + 1) XOR register6;
				register3 := register3 + register9;
			WHEN "00001010" =>
				register7 := ((NOT register7) + 1) XOR register7;
				register6 := register6 / 2;
				register3 := ((NOT register3) + 1) XOR register3;
				register8 := ((NOT register8) + 1) XOR register8;
			WHEN "00001011" =>
				register7 := register6 * register7;
			WHEN "00001100" =>
				output2 <= register7(0 TO 1) & register5(0 TO 2);
				register5 := register6 * register8;
				register7 := ((NOT register12) + 1) XOR register12;
			WHEN "00001101" =>
				output3 <= register5(0 TO 1) & register4(0 TO 2);
				register3 := register6 * register3;
			WHEN "00001110" =>
				output4 <= register3(0 TO 1) & register2(0 TO 2);
				register1 := register1 + 51;
			WHEN "00001111" =>
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00010000" =>
				IF (register7 = 54 or register1 = 54) THEN
					output5 <= register7;
				ELSE
					output5 <= "10110";
				END IF;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesafp_random_description;