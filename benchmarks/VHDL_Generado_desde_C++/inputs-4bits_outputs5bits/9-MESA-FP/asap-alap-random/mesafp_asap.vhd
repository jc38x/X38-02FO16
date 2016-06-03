-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.16:15:22)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesafp_asap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21: IN unsigned(0 TO 3);
		output1, output2, output3, output4, output5: OUT unsigned(0 TO 4));
END mesafp_asap_entity;

ARCHITECTURE mesafp_asap_description OF mesafp_asap_entity IS
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
	SHARED VARIABLE register18: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register19: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register20: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register21: unsigned(0 TO 4) := "00000";
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
				register2 := input2 + 2;
				register3 := input3 + 3;
				register4 := input4 * 4;
				register5 := input5 + 5;
				register6 := input6 + 6;
				register7 := input7 * 7;
				register8 := input8 * 8;
				register9 := input9 + 9;
				register10 := input10 * 10;
				register11 := input11 * 11;
				register12 := input12 + 12;
				register13 := input13 * 13;
				register14 := input14 * 14;
				register15 := input15 * 15;
				register16 := input16 * 16;
				register17 := input17 * 17;
				register18 := input18 * 18;
				register19 := input19 * 19;
				register20 := input20 * 20;
				register21 := input21 * 21;
			WHEN "00000010" =>
				register1 := register1 + 23;
				register2 := register21 + register2;
				register3 := register17 + register3;
				register4 := register4 + 25;
				register5 := register5 + 27;
				register6 := register19 + register6;
				register7 := register7 + 29;
				register8 := register8 + 31;
				register9 := register15 + register9;
				register10 := register10 + register12;
				register12 := register13 + 33;
			WHEN "00000011" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register2 := register20 + register2;
				register3 := register16 + register3;
				register5 := ((NOT register5) + 1) XOR register5;
				register6 := register18 + register6;
				register9 := register14 + register9;
				register10 := register11 + register10;
			WHEN "00000100" =>
				IF (register5 = 38 or register1 = 38) THEN
					output1 <= register5;
				ELSE
					output1 <= "00110";
				END IF;
				register1 := ((NOT register2) + 1) XOR register2;
				register2 := ((NOT register3) + 1) XOR register3;
				register3 := ((NOT register6) + 1) XOR register6;
				register5 := ((NOT register9) + 1) XOR register9;
				register6 := ((NOT register10) + 1) XOR register10;
			WHEN "00000101" =>
				output2 <= register1(0 TO 1) & register4(0 TO 2);
				register1 := register6 / 2;
			WHEN "00000110" =>
				register3 := register1 * register3;
				register2 := register1 * register2;
				register1 := register1 * register5;
			WHEN "00000111" =>
				output3 <= register3(0 TO 1) & register8(0 TO 2);
				output4 <= register2(0 TO 1) & register7(0 TO 2);
				output5 <= register1(0 TO 1) & register12(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesafp_asap_description;