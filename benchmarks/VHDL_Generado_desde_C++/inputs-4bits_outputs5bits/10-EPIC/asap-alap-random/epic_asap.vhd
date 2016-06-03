-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.16:16:48)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY epic_asap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6: IN unsigned(0 TO 3);
		output1, output2, output3, output4, output5, output6, output7, output8, output9: OUT unsigned(0 TO 4));
END epic_asap_entity;

ARCHITECTURE epic_asap_description OF epic_asap_entity IS
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
				register1 := input1 - 1;
				register2 := input2 srl 2;
				register3 := input3 * 3;
				register4 := input4 + 4;
				register5 := input5 + 5;
				register6 := input6 - 6;
			WHEN "00000010" =>
				register7 := register1 * 8;
				register8 := register1 - 10;
				register9 := register1 + 12;
				register10 := register1 - register5;
				register1 := register1 + register5;
				register11 := register2 srl 14;
				register3 := register3 + 16;
				register4 := register4 * 18;
				register5 := register5 * 20;
				register6 := register6 * 22;
			WHEN "00000011" =>
				register7 := register7 + 24;
				register8 := register8 * 26;
				register9 := register9 * 28;
				register10 := register10 * 30;
				register1 := register1 * 32;
				register12 := register2 sll to_integer(register11);
				register13 := ((NOT register3) + 1) XOR register3;
				register4 := register4 + 36;
				register5 := register5 + 38;
				register6 := register6 + 40;
			WHEN "00000100" =>
				register14 := ((NOT register7) + 1) XOR register7;
				register8 := register8 + 44;
				register9 := register9 + 46;
				register10 := register10 + 48;
				register1 := register1 + 50;
				register13 := register13 + 52;
				register15 := ((NOT register4) + 1) XOR register4;
				register16 := ((NOT register5) + 1) XOR register5;
				register17 := ((NOT register6) + 1) XOR register6;
			WHEN "00000101" =>
				register14 := register2 - register14;
				register18 := ((NOT register8) + 1) XOR register8;
				register19 := ((NOT register9) + 1) XOR register9;
				register20 := ((NOT register10) + 1) XOR register10;
				register21 := ((NOT register1) + 1) XOR register1;
				output1 <= register3(0 TO 1) & register13(0 TO 2);
				register3 := register2 - register15;
				register12 := register16 - register12;
				register13 := register2 - register17;
			WHEN "00000110" =>
				output2 <= register7(0 TO 1) & register14(0 TO 2);
				register7 := register11 + register18;
				register14 := register2 + register11 + register19;
				register15 := register2 + register11 + register20;
				register2 := register2 + register11 + register21;
				output3 <= register4(0 TO 1) & register3(0 TO 2);
				output4 <= register5(0 TO 1) & register12(0 TO 2);
				output5 <= register6(0 TO 1) & register13(0 TO 2);
			WHEN "00000111" =>
				output6 <= register8(0 TO 1) & register7(0 TO 2);
				output7 <= register9(0 TO 1) & register14(0 TO 2);
				output8 <= register10(0 TO 1) & register15(0 TO 2);
				output9 <= register1(0 TO 1) & register2(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END epic_asap_description;