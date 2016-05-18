-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.17:10:08)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY arf_wsga_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8: IN unsigned(0 TO 30);
		output1, output2: OUT unsigned(0 TO 31));
END arf_wsga_entity;

ARCHITECTURE arf_wsga_description OF arf_wsga_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register6: unsigned(0 TO 31) := "00000000000000000000000000000000";
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
			WHEN "00000010" =>
				register4 := input4 * 4;
				register1 := register1 + register2;
				register2 := input5 * 5;
			WHEN "00000011" =>
				register2 := register3 + register2;
				register3 := input6 * 6;
				register5 := input7 * 7;
			WHEN "00000100" =>
				register3 := register3 + register5;
				register2 := register2 + 9;
				register5 := input8 * 10;
			WHEN "00000101" =>
				register6 := register2 * 12;
				register4 := register4 + register5;
				register3 := register3 + 14;
			WHEN "00000110" =>
				register5 := register3 * 16;
				register3 := register3 * 18;
				register2 := register2 * 20;
			WHEN "00000111" =>
				register2 := register3 + register2;
				register3 := register5 + register6;
			WHEN "00001000" =>
				register5 := register3 * 22;
				register6 := register2 * 24;
			WHEN "00001001" =>
				register5 := register6 + register5;
				register2 := register2 * 26;
				register3 := register3 * 28;
			WHEN "00001010" =>
				register2 := register2 + register3;
				output1 <= register1 + register5;
			WHEN "00001011" =>
				output2 <= register4 + register2;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END arf_wsga_description;