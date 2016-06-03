-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.16:17:17)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY epic_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6: IN unsigned(0 TO 3);
		output1, output2, output3, output4, output5, output6, output7, output8, output9: OUT unsigned(0 TO 4));
END epic_random_entity;

ARCHITECTURE epic_random_description OF epic_random_entity IS
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
				register1 := input1 + 1;
				register2 := input2 * 2;
			WHEN "00000010" =>
				register2 := register2 + 4;
				register3 := input3 + 5;
				register4 := input4 - 6;
				register1 := register1 * 8;
			WHEN "00000011" =>
				register5 := ((NOT register2) + 1) XOR register2;
				register4 := register4 * 12;
				register6 := input5 - 13;
			WHEN "00000100" =>
				register7 := register6 + register3;
				register8 := input6 srl 14;
				register9 := register3 * 16;
				register3 := register6 - register3;
				register5 := register5 + 18;
				register10 := register6 + 20;
			WHEN "00000101" =>
				output1 <= register2(0 TO 1) & register5(0 TO 2);
				register2 := register4 + 23;
				register3 := register3 * 25;
				register4 := register8 srl 27;
			WHEN "00000110" =>
				register5 := register8 sll to_integer(register4);
				register11 := ((NOT register2) + 1) XOR register2;
			WHEN "00000111" =>
				register11 := register8 - register11;
				register12 := register6 - 31;
			WHEN "00001000" =>
				output2 <= register2(0 TO 1) & register11(0 TO 2);
				register2 := register10 * 34;
				register3 := register3 + 36;
			WHEN "00001001" =>
				register10 := ((NOT register3) + 1) XOR register3;
				register9 := register9 + 40;
				register1 := register1 + 42;
			WHEN "00001010" =>
				register11 := ((NOT register9) + 1) XOR register9;
				register10 := register8 + register4 + register10;
				register12 := register12 * 46;
				register7 := register7 * 48;
			WHEN "00001011" =>
				register13 := ((NOT register1) + 1) XOR register1;
				register7 := register7 + 52;
				register2 := register2 + 54;
			WHEN "00001100" =>
				register13 := register8 - register13;
				output3 <= register3(0 TO 1) & register10(0 TO 2);
				register3 := ((NOT register2) + 1) XOR register2;
			WHEN "00001101" =>
				register10 := ((NOT register7) + 1) XOR register7;
				register3 := register8 + register4 + register3;
				register12 := register12 + 61;
				register5 := register11 - register5;
			WHEN "00001110" =>
				output4 <= register9(0 TO 1) & register5(0 TO 2);
				register5 := ((NOT register12) + 1) XOR register12;
				register9 := register8 + register4 + register10;
			WHEN "00001111" =>
				output5 <= register2(0 TO 1) & register3(0 TO 2);
				register2 := register4 + register5;
			WHEN "00010000" =>
				output6 <= register7(0 TO 1) & register9(0 TO 2);
			WHEN "00010001" =>
				output7 <= register1(0 TO 1) & register13(0 TO 2);
			WHEN "00010010" =>
				output8 <= register12(0 TO 1) & register2(0 TO 2);
				register1 := register6 * 70;
			WHEN "00010011" =>
				register1 := register1 + 72;
			WHEN "00010100" =>
				register2 := ((NOT register1) + 1) XOR register1;
			WHEN "00010101" =>
				register2 := register8 - register2;
			WHEN "00010110" =>
				output9 <= register1(0 TO 1) & register2(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END epic_random_description;