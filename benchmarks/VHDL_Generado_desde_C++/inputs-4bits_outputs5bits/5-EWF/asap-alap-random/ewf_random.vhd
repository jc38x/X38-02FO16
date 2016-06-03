-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-16.08:47:50)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY ewf_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2: IN unsigned(0 TO 3);
		output1, output2, output3, output4, output5: OUT unsigned(0 TO 4));
END ewf_random_entity;

ARCHITECTURE ewf_random_description OF ewf_random_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register2: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register3: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register4: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register5: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register6: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register7: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register8: unsigned(0 TO 4) := "00000";
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
			WHEN "00000010" =>
				register3 := register2 + 4;
			WHEN "00000011" =>
				register4 := register3 + 6;
			WHEN "00000100" =>
				register4 := register1 + register4;
			WHEN "00000101" =>
				register5 := register4 * 8;
				register6 := register4 * 10;
			WHEN "00000110" =>
				register5 := register3 + register5;
			WHEN "00000111" =>
				register4 := register4 + register5;
				register6 := register1 + register6;
				register3 := register3 + register5;
			WHEN "00001000" =>
				register1 := register1 + register6;
				register3 := register3 * 12;
			WHEN "00001001" =>
				register1 := register1 * 14;
			WHEN "00001010" =>
				register1 := register1 + 16;
				register3 := register2 + register3;
			WHEN "00001011" =>
				register7 := register6 + register1;
				register2 := register2 + register3;
			WHEN "00001100" =>
				register7 := register7 + 18;
				register5 := register5 + register3;
			WHEN "00001101" =>
				register8 := register7 * 20;
				output1 <= register6 + register4;
			WHEN "00001110" =>
				register4 := register8 + 23;
				register6 := register1 + 25;
				register2 := register2 * 27;
			WHEN "00001111" =>
				register6 := register6 * 29;
				output2 <= register7 + register4;
				register4 := register5 + 32;
				register2 := register2 + 34;
			WHEN "00010000" =>
				output3 <= register3 + register2;
				output4 <= register1 + register6;
				register1 := register4 * 38;
			WHEN "00010001" =>
				register1 := register1 + 40;
			WHEN "00010010" =>
				output5 <= register4 + register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END ewf_random_description;