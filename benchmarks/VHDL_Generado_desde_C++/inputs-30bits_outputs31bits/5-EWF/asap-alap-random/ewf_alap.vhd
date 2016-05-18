-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-13.00:55:01)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY ewf_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2: IN unsigned(0 TO 30);
		output1, output2, output3, output4, output5: OUT unsigned(0 TO 31));
END ewf_alap_entity;

ARCHITECTURE ewf_alap_description OF ewf_alap_entity IS
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
			WHEN "00000010" =>
				register2 := register1 + 3;
			WHEN "00000011" =>
				register3 := register2 + 5;
				register4 := input2 + 6;
			WHEN "00000100" =>
				register3 := register4 + register3;
			WHEN "00000101" =>
				register5 := register3 * 8;
				register6 := register3 * 10;
			WHEN "00000110" =>
				register5 := register4 + register5;
				register6 := register2 + register6;
			WHEN "00000111" =>
				register4 := register4 + register5;
				register2 := register2 + register6;
			WHEN "00001000" =>
				register4 := register4 * 12;
				register2 := register2 * 14;
			WHEN "00001001" =>
				register4 := register4 + 16;
				register2 := register1 + register2;
			WHEN "00001010" =>
				register7 := register5 + register4;
				register8 := register6 + register2;
			WHEN "00001011" =>
				register7 := register7 + 18;
				register1 := register1 + register2;
				register8 := register8 + 20;
				register9 := register4 + 22;
			WHEN "00001100" =>
				register10 := register7 * 24;
				register1 := register1 * 26;
				register11 := register8 * 28;
			WHEN "00001101" =>
				register9 := register9 * 30;
				register3 := register3 + register6;
				register6 := register10 + 32;
				register1 := register1 + 34;
				register10 := register11 + 36;
			WHEN "00001110" =>
				output1 <= register4 + register9;
				output2 <= register5 + register3;
				output3 <= register7 + register6;
				output4 <= register2 + register1;
				output5 <= register8 + register10;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END ewf_alap_description;