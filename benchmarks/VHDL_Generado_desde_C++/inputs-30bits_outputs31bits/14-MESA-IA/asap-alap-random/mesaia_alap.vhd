-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.13:54:59)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesaia_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31, input32, input33, input34, input35, input36, input37, input38, input39, input40, input41, input42, input43, input44, input45, input46, input47, input48: IN unsigned(0 TO 30);
		output1, output2, output3, output4: OUT unsigned(0 TO 31));
END mesaia_alap_entity;

ARCHITECTURE mesaia_alap_description OF mesaia_alap_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register6: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register7: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register8: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register9: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register10: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register11: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register12: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register13: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register14: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register15: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register16: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register17: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register18: unsigned(0 TO 31) := "0000000000000000000000000000000";
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
				register9 := input9 + 9;
				register10 := input10 * 10;
				register11 := input11 + 11;
				register12 := input12 * 12;
				register13 := input13 + 13;
				register14 := input14 * 14;
				register15 := input15 + 15;
				register16 := input16 * 16;
			WHEN "00000010" =>
				register1 := register2 + register1;
				register2 := input17 * 17;
				register3 := register4 + register3;
				register4 := input18 * 18;
				register5 := register6 + register5;
				register6 := input19 * 19;
				register7 := register8 + register7;
				register8 := input20 * 20;
				register9 := register10 + register9;
				register10 := input21 * 21;
				register11 := register12 + register11;
				register12 := input22 * 22;
				register13 := register14 + register13;
				register14 := input23 * 23;
				register15 := register16 + register15;
				register16 := input24 * 24;
			WHEN "00000011" =>
				register1 := register2 + register1;
				register2 := register4 + register3;
				register3 := input25 + 25;
				register4 := input26 * 26;
				register5 := register6 + register5;
				register6 := register8 + register7;
				register7 := input27 + 27;
				register8 := input28 * 28;
				register9 := register10 + register9;
				register10 := register12 + register11;
				register11 := input29 + 29;
				register12 := input30 * 30;
				register13 := register14 + register13;
				register14 := register16 + register15;
				register15 := input31 + 31;
				register16 := input32 * 32;
			WHEN "00000100" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register2 := ((NOT register2) + 1) XOR register2;
				register3 := register4 + register3;
				register4 := input33 * 37;
				register5 := ((NOT register5) + 1) XOR register5;
				register6 := ((NOT register6) + 1) XOR register6;
				register7 := register8 + register7;
				register8 := input34 * 42;
				register9 := ((NOT register9) + 1) XOR register9;
				register10 := ((NOT register10) + 1) XOR register10;
				register11 := register12 + register11;
				register12 := input35 * 47;
				register13 := ((NOT register13) + 1) XOR register13;
				register14 := ((NOT register14) + 1) XOR register14;
				register15 := register16 + register15;
				register16 := input36 * 52;
				register17 := input37 + 53;
				register18 := input38 * 54;
			WHEN "00000101" =>
				register1 := register2 - register1;
				register2 := register4 + register3;
				register3 := input39 + 55;
				register4 := input40 * 56;
				register5 := register6 - register5;
				register6 := register8 + register7;
				register7 := input41 + 57;
				register8 := input42 * 58;
				register9 := register10 - register9;
				register10 := register12 + register11;
				register11 := input43 + 59;
				register12 := input44 * 60;
				register13 := register14 - register13;
				register14 := register16 + register15;
				register15 := register18 + register17;
				register16 := input45 * 61;
			WHEN "00000110" =>
				register1 := register1 * 63;
				register2 := ((NOT register2) + 1) XOR register2;
				register3 := register4 + register3;
				register4 := input46 * 66;
				register5 := register5 * 68;
				register6 := ((NOT register6) + 1) XOR register6;
				register7 := register8 + register7;
				register8 := input47 * 71;
				register9 := register9 * 73;
				register10 := ((NOT register10) + 1) XOR register10;
				register11 := register12 + register11;
				register12 := input48 * 76;
				register13 := register13 * 78;
				register14 := ((NOT register14) + 1) XOR register14;
				register15 := register16 + register15;
			WHEN "00000111" =>
				register1 := register2 + register1;
				register2 := register4 + register3;
				register3 := register6 + register5;
				register4 := register8 + register7;
				register5 := register10 + register9;
				register6 := register12 + register11;
				register7 := register14 + register13;
			WHEN "00001000" =>
				output1 <= register1(0 TO 14) & register15(0 TO 15);
				output2 <= register3(0 TO 14) & register2(0 TO 15);
				output3 <= register5(0 TO 14) & register4(0 TO 15);
				output4 <= register7(0 TO 14) & register6(0 TO 15);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesaia_alap_description;