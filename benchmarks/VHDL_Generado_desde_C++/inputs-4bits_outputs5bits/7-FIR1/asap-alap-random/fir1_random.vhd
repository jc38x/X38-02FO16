-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.15:19:46)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY fir1_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22: IN unsigned(0 TO 3);
		output1: OUT unsigned(0 TO 4));
END fir1_random_entity;

ARCHITECTURE fir1_random_description OF fir1_random_entity IS
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
				register1 := input1 and input1;
				register2 := input2 and input2;
				register3 := input3 and input3;
				register4 := input4 and input4;
				register5 := input5 and input5;
				register6 := input6 and input6;
				register7 := input7 and input7;
				register8 := input8 and input8;
				register9 := input9 and input9;
				register10 := input10 and input10;
			WHEN "00000010" =>
				register11 := input11 and input11;
				register12 := input12 and input12;
				register13 := input13 and input13;
				register14 := input14 and input14;
				register6 := register6 * register10;
				register10 := input15 and input15;
				register15 := input16 and input16;
				register8 := register9 * register8;
				register9 := input17 and input17;
				register16 := input18 and input18;
				register17 := input19 and input19;
			WHEN "00000011" =>
				register14 := register14 * register17;
				register1 := register1 * register2;
				register2 := register4 * register13;
				register4 := input20 and input20;
				register13 := input21 and input21;
				register7 := register7 * register16;
			WHEN "00000100" =>
				register13 := register15 * register13;
				register4 := register10 * register4;
			WHEN "00000101" =>
				register1 := register1 + register13;
				register3 := register3 * register9;
			WHEN "00000110" =>
				register3 := register4 + register3;
				register4 := register5 * register12;
			WHEN "00000111" =>
				register3 := register3 + register4;
			WHEN "00001000" =>
				register3 := register6 + register3;
			WHEN "00001001" =>
				register1 := register1 + register3;
				register3 := input22 and input22;
			WHEN "00001010" =>
				register3 := register11 * register3;
			WHEN "00001011" =>
				register3 := register3 + register7;
			WHEN "00001100" =>
				register1 := register1 + register2;
			WHEN "00001101" =>
				register1 := register3 + register1;
			WHEN "00001110" =>
				register1 := register1 + register14;
			WHEN "00001111" =>
				register1 := register8 + register1;
			WHEN "00010000" =>
				output1 <= register1 and register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END fir1_random_description;