-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-13.00:55:14)

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
			WHEN "00000110" =>
				register5 := register1 + register5;
				register6 := register4 * 10;
			WHEN "00000111" =>
				register6 := register3 + register6;
			WHEN "00001000" =>
				register4 := register4 + register6;
			WHEN "00001001" =>
				output1 <= register5 + register4;
				register1 := register1 + register5;
				register3 := register3 + register6;
			WHEN "00001010" =>
				register3 := register3 * 13;
				register1 := register1 * 15;
			WHEN "00001011" =>
				register3 := register2 + register3;
				register1 := register1 + 17;
			WHEN "00001100" =>
				register2 := register2 + register3;
				register4 := register1 + 19;
				register5 := register5 + register1;
			WHEN "00001101" =>
				register5 := register5 + 21;
				register4 := register4 * 23;
				register2 := register2 * 25;
			WHEN "00001110" =>
				register2 := register2 + 27;
				register7 := register5 * 29;
			WHEN "00001111" =>
				register7 := register7 + 31;
				output2 <= register1 + register4;
				output3 <= register3 + register2;
			WHEN "00010000" =>
				output4 <= register5 + register7;
				register1 := register6 + register3;
			WHEN "00010001" =>
				register1 := register1 + 36;
			WHEN "00010010" =>
				register2 := register1 * 38;
			WHEN "00010011" =>
				register2 := register2 + 40;
			WHEN "00010100" =>
				output5 <= register1 + register2;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END ewf_random_description;