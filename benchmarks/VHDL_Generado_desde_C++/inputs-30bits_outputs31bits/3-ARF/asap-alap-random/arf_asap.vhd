-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.14:37:21)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY arf_asap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8: IN unsigned(0 TO 30);
		output1, output2: OUT unsigned(0 TO 31));
END arf_asap_entity;

ARCHITECTURE arf_asap_description OF arf_asap_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register6: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register7: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register8: unsigned(0 TO 31) := "0000000000000000000000000000000";
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
				register1 := input1 * 1;
				register2 := input2 * 2;
				register3 := input3 * 3;
				register4 := input4 * 4;
				register5 := input5 * 5;
				register6 := input6 * 6;
				register7 := input7 * 7;
				register8 := input8 * 8;
			WHEN "00000010" =>
				register1 := register4 + register1;
				register2 := register2 + register8;
				register3 := register6 + register3;
				register4 := register7 + register5;
			WHEN "00000011" =>
				register1 := register1 + 10;
				register3 := register3 + 12;
			WHEN "00000100" =>
				register5 := register1 * 14;
				register1 := register1 * 16;
				register6 := register3 * 18;
				register3 := register3 * 20;
			WHEN "00000101" =>
				register5 := register6 + register5;
				register1 := register3 + register1;
			WHEN "00000110" =>
				register3 := register5 * 22;
				register5 := register5 * 24;
				register6 := register1 * 26;
				register1 := register1 * 28;
			WHEN "00000111" =>
				register3 := register3 + register6;
				register1 := register5 + register1;
			WHEN "00001000" =>
				output1 <= register4 + register3;
				output2 <= register2 + register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END arf_asap_description;