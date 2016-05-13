-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.17:09:56)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY arf_spea2_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8: IN unsigned(0 TO 3);
		output1, output2: OUT unsigned(0 TO 4));
END arf_spea2_entity;

ARCHITECTURE arf_spea2_description OF arf_spea2_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register2: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register3: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register4: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register5: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register6: unsigned(0 TO 4) := "00000";
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
			WHEN "00000010" =>
				register1 := register1 + register2;
				register2 := input3 * 3;
				register3 := input4 * 4;
			WHEN "00000011" =>
				register4 := input5 * 5;
				register5 := input6 * 6;
				register2 := register2 + register3;
			WHEN "00000100" =>
				register3 := register4 + register5;
				register4 := input7 * 7;
			WHEN "00000101" =>
				register3 := register3 + 9;
				register5 := input8 * 10;
			WHEN "00000110" =>
				register4 := register5 + register4;
				register5 := register3 * 12;
				register1 := register1 + 14;
				register3 := register3 * 16;
			WHEN "00000111" =>
				register6 := register1 * 18;
			WHEN "00001000" =>
				register3 := register3 + register6;
				register1 := register1 * 20;
			WHEN "00001001" =>
				register1 := register5 + register1;
			WHEN "00001010" =>
				register5 := register1 * 22;
				register6 := register3 * 24;
			WHEN "00001011" =>
				register5 := register5 + register6;
				register3 := register3 * 26;
				register1 := register1 * 28;
			WHEN "00001100" =>
				register1 := register1 + register3;
				output1 <= register4 + register5;
			WHEN "00001101" =>
				output2 <= register2 + register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END arf_spea2_description;