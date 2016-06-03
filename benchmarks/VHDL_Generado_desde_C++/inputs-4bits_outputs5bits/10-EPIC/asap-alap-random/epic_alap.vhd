-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.16:17:03)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY epic_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6: IN unsigned(0 TO 3);
		output1, output2, output3, output4, output5, output6, output7, output8, output9: OUT unsigned(0 TO 4));
END epic_alap_entity;

ARCHITECTURE epic_alap_description OF epic_alap_entity IS
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
				register2 := input2 - 2;
			WHEN "00000010" =>
				register3 := register2 - register1;
				register4 := input3 + 3;
				register5 := register2 + 5;
				register6 := register2 - 7;
				register7 := register2 + register1;
				register8 := input4 - 8;
			WHEN "00000011" =>
				register3 := register3 * 10;
				register2 := register2 * 12;
				register4 := register4 * 14;
				register9 := input5 srl 15;
				register1 := register1 * 17;
				register5 := register5 * 19;
				register6 := register6 * 21;
				register10 := input6 * 22;
				register7 := register7 * 24;
				register8 := register8 * 26;
			WHEN "00000100" =>
				register3 := register3 + 28;
				register2 := register2 + 30;
				register4 := register4 + 32;
				register11 := register9 srl 34;
				register1 := register1 + 36;
				register5 := register5 + 38;
				register6 := register6 + 40;
				register10 := register10 + 42;
				register7 := register7 + 44;
				register8 := register8 + 46;
			WHEN "00000101" =>
				register12 := ((NOT register3) + 1) XOR register3;
				register13 := ((NOT register2) + 1) XOR register2;
				register14 := ((NOT register4) + 1) XOR register4;
				register15 := register9 sll to_integer(register11);
				register16 := ((NOT register1) + 1) XOR register1;
				register17 := ((NOT register5) + 1) XOR register5;
				register18 := ((NOT register6) + 1) XOR register6;
				register19 := ((NOT register10) + 1) XOR register10;
				register20 := ((NOT register7) + 1) XOR register7;
				register21 := ((NOT register8) + 1) XOR register8;
			WHEN "00000110" =>
				register12 := register9 + register11 + register12;
				register13 := register9 - register13;
				register14 := register9 - register14;
				register15 := register16 - register15;
				register16 := register9 + register11 + register17;
				register17 := register11 + register18;
				register18 := register19 + 66;
				register11 := register9 + register11 + register20;
				register9 := register9 - register21;
			WHEN "00000111" =>
				output1 <= register3(0 TO 1) & register12(0 TO 2);
				output2 <= register2(0 TO 1) & register13(0 TO 2);
				output3 <= register4(0 TO 1) & register14(0 TO 2);
				output4 <= register1(0 TO 1) & register15(0 TO 2);
				output5 <= register5(0 TO 1) & register16(0 TO 2);
				output6 <= register6(0 TO 1) & register17(0 TO 2);
				output7 <= register10(0 TO 1) & register18(0 TO 2);
				output8 <= register7(0 TO 1) & register11(0 TO 2);
				output9 <= register8(0 TO 1) & register9(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END epic_alap_description;