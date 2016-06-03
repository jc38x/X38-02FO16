-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.16:15:32)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesafp_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21: IN unsigned(0 TO 3);
		output1, output2, output3, output4, output5: OUT unsigned(0 TO 4));
END mesafp_alap_entity;

ARCHITECTURE mesafp_alap_description OF mesafp_alap_entity IS
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
				register3 := input3 + 3;
				register4 := input4 * 4;
				register5 := input5 + 5;
				register6 := input6 * 6;
				register7 := input7 + 7;
				register8 := input8 * 8;
			WHEN "00000010" =>
				register1 := register2 + register1;
				register2 := input9 * 9;
				register3 := register4 + register3;
				register4 := input10 * 10;
				register9 := input11 + 11;
				register10 := input12 * 12;
				register5 := register6 + register5;
				register6 := input13 * 13;
				register7 := register8 + register7;
			WHEN "00000011" =>
				register8 := input14 * 14;
				register1 := register2 + register1;
				register2 := register4 + register3;
				register3 := input15 + 15;
				register4 := input16 + 16;
				register9 := register10 + register9;
				register10 := input17 * 17;
				register5 := register6 + register5;
			WHEN "00000100" =>
				register6 := register8 + register7;
				register1 := ((NOT register1) + 1) XOR register1;
				register7 := input18 * 20;
				register2 := ((NOT register2) + 1) XOR register2;
				register3 := register3 + 24;
				register4 := register4 + 26;
				register8 := input19 * 27;
				register9 := register10 + register9;
				register10 := input20 * 28;
				register5 := ((NOT register5) + 1) XOR register5;
				register11 := input21 * 31;
			WHEN "00000101" =>
				register6 := ((NOT register6) + 1) XOR register6;
				register1 := register1 / 2;
				register7 := register7 + 37;
			WHEN "00000110" =>
				register2 := register1 * register2;
				register3 := ((NOT register3) + 1) XOR register3;
				register4 := ((NOT register4) + 1) XOR register4;
				register8 := register8 + 43;
				register9 := ((NOT register9) + 1) XOR register9;
				register10 := register10 + 47;
				register5 := register1 * register5;
				register11 := register11 + 49;
				register1 := register1 * register6;
			WHEN "00000111" =>
				output1 <= register2(0 TO 1) & register7(0 TO 2);
				IF (register4 = 51 or register3 = 51) THEN
					output2 <= register4;
				ELSE
					output2 <= "10011";
				END IF;
				output3 <= register9(0 TO 1) & register8(0 TO 2);
				output4 <= register5(0 TO 1) & register10(0 TO 2);
				output5 <= register1(0 TO 1) & register11(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesafp_alap_description;