-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-13.07:37:23)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mpegmv_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14: IN unsigned(0 TO 3);
		output1, output2, output3: OUT unsigned(0 TO 4));
END mpegmv_random_entity;

ARCHITECTURE mpegmv_random_description OF mpegmv_random_entity IS
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
				register1 := input1 * 1;
				register2 := input2 * 2;
				register3 := input3 * 3;
				register4 := input4 * 4;
				register5 := input5 * 5;
				register6 := input6 * 6;
				register7 := input7 * 7;
				register8 := input8 * 8;
				register9 := input9 * 9;
			WHEN "00000010" =>
				register10 := input10 * 10;
			WHEN "00000011" =>
				register10 := register10 + 12;
			WHEN "00000100" =>
				register9 := register9 + register10;
				register10 := input11 * 13;
				register11 := input12 * 14;
				register12 := input13 * 15;
			WHEN "00000101" =>
				register11 := register11 + 17;
				register3 := register3 + 19;
				register4 := register4 + 21;
				register13 := input14 * 22;
				register6 := register6 + register9;
			WHEN "00000110" =>
				register2 := register2 + register11;
				register4 := register10 + register4;
			WHEN "00000111" =>
				register2 := register5 + register2;
				register5 := register12 + 24;
				register1 := register1 + register4;
				register3 := register7 + register3;
			WHEN "00001000" =>
				output1 <= register13 + register5;
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00001001" =>
				output2 <= register1(0 TO 1) & register6(0 TO 2);
				register1 := register8 + register3;
			WHEN "00001010" =>
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00001011" =>
				output3 <= register1(0 TO 1) & register2(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mpegmv_random_description;