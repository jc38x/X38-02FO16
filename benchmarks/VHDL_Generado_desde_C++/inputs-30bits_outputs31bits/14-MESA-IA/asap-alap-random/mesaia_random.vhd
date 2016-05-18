-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.13:55:20)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesaia_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22, input23, input24, input25, input26, input27, input28, input29, input30, input31, input32, input33, input34, input35, input36, input37, input38, input39, input40, input41, input42, input43, input44, input45, input46, input47, input48: IN unsigned(0 TO 30);
		output1, output2, output3, output4: OUT unsigned(0 TO 31));
END mesaia_random_entity;

ARCHITECTURE mesaia_random_description OF mesaia_random_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register6: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register7: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register8: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register9: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register10: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register11: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register12: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register13: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register14: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register15: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register16: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register17: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register18: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register19: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register20: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register21: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register22: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register23: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register24: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register25: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register26: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register27: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register28: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register29: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register30: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register31: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register32: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register33: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register34: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register35: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register36: unsigned(0 TO 31) := "00000000000000000000000000000000";
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
				register4 := input4 * 4;
				register5 := input5 * 5;
				register6 := input6 * 6;
				register7 := input7 + 7;
				register8 := input8 * 8;
				register9 := input9 * 9;
				register10 := input10 * 10;
				register11 := input11 * 11;
				register12 := input12 + 12;
				register13 := input13 * 13;
				register14 := input14 + 14;
				register15 := input15 * 15;
				register16 := input16 + 16;
				register17 := input17 * 17;
				register18 := input18 * 18;
				register19 := input19 + 19;
				register20 := input20 * 20;
				register21 := input21 * 21;
				register22 := input22 * 22;
				register23 := input23 + 23;
				register24 := input24 * 24;
			WHEN "00000010" =>
				register19 := register20 + register19;
				register20 := input25 * 25;
				register25 := input26 + 26;
				register8 := register8 + register16;
				register16 := input27 * 27;
				register26 := input28 + 28;
				register27 := input29 + 29;
				register28 := input30 * 30;
				register29 := input31 + 31;
				register30 := input32 + 32;
				register31 := input33 + 33;
				register32 := input34 * 34;
			WHEN "00000011" =>
				register18 := register18 + register27;
				register27 := input35 * 35;
				register33 := input36 + 36;
				register34 := input37 * 37;
				register35 := input38 + 38;
			WHEN "00000100" =>
				register4 := register4 + register35;
				register18 := register28 + register18;
				register28 := input39 + 39;
				register35 := input40 * 40;
				register14 := register32 + register14;
				register32 := input41 * 41;
				register36 := input42 * 42;
			WHEN "00000101" =>
				register4 := register6 + register4;
				register6 := register36 + register25;
				register18 := ((NOT register18) + 1) XOR register18;
				register7 := register15 + register7;
				register13 := register13 + register23;
			WHEN "00000110" =>
				register4 := ((NOT register4) + 1) XOR register4;
				register14 := register17 + register14;
			WHEN "00000111" =>
				register14 := ((NOT register14) + 1) XOR register14;
				register12 := register34 + register12;
				register8 := register35 + register8;
				register15 := input43 * 49;
				register17 := input44 * 50;
				register5 := register5 + register26;
				register21 := register21 + register30;
				register23 := register27 + register29;
				register25 := input45 * 51;
				register26 := input46 * 52;
			WHEN "00001000" =>
				register19 := register26 + register19;
				register13 := register15 + register13;
				register15 := register32 + register33;
				register26 := input47 * 53;
			WHEN "00001001" =>
				register5 := register26 + register5;
				register6 := register22 + register6;
				register22 := input48 * 54;
				register17 := register17 + register31;
			WHEN "00001010" =>
				register1 := register22 + register1;
				register7 := register25 + register7;
				register11 := register11 + register21;
				register5 := ((NOT register5) + 1) XOR register5;
				register17 := register20 + register17;
			WHEN "00001011" =>
				register7 := ((NOT register7) + 1) XOR register7;
				register3 := register3 + register28;
				register13 := ((NOT register13) + 1) XOR register13;
			WHEN "00001100" =>
				register11 := ((NOT register11) + 1) XOR register11;
				register10 := register10 + register12;
				register7 := register13 - register7;
			WHEN "00001101" =>
				register11 := register11 - register14;
				register7 := register7 * 64;
				register10 := ((NOT register10) + 1) XOR register10;
				register2 := register2 + register15;
				register1 := register24 + register1;
			WHEN "00001110" =>
				register11 := register11 * 68;
				register9 := register9 + register23;
				register3 := register16 + register3;
				register6 := ((NOT register6) + 1) XOR register6;
				register12 := ((NOT register19) + 1) XOR register19;
				register4 := register4 - register10;
			WHEN "00001111" =>
				register3 := ((NOT register3) + 1) XOR register3;
				register7 := register12 + register7;
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00010000" =>
				register1 := register1 - register5;
				register4 := register4 * 78;
			WHEN "00010001" =>
				register4 := register18 + register4;
				register1 := register1 * 80;
				register3 := register3 + register11;
				output1 <= register7(0 TO 15) & register2(0 TO 15);
			WHEN "00010010" =>
				output2 <= register3(0 TO 15) & register9(0 TO 15);
				output3 <= register4(0 TO 15) & register17(0 TO 15);
				register1 := register6 + register1;
			WHEN "00010011" =>
				output4 <= register1(0 TO 15) & register8(0 TO 15);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesaia_random_description;