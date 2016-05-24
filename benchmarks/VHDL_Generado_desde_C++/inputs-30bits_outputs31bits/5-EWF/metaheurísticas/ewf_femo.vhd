-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-17.11:31:09)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY ewf_femo_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2: IN unsigned(0 TO 30);
		output1, output2, output3, output4, output5: OUT unsigned(0 TO 31));
END ewf_femo_entity;

ARCHITECTURE ewf_femo_description OF ewf_femo_entity IS
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
				register5 := register3 + register5;
				register6 := register4 * 10;
			WHEN "00000111" =>
				register3 := register3 + register5;
				register4 := register4 + register5;
			WHEN "00001000" =>
				register6 := register1 + register6;
				register3 := register3 * 12;
			WHEN "00001001" =>
				output1 <= register6 + register4;
				register1 := register1 + register6;
			WHEN "00001010" =>
				register3 := register2 + register3;
				register1 := register1 * 15;
			WHEN "00001011" =>
				register2 := register2 + register3;
			WHEN "00001100" =>
				register2 := register2 * 17;
			WHEN "00001101" =>
				register2 := register2 + 19;
				register4 := register5 + register3;
			WHEN "00001110" =>
				output2 <= register3 + register2;
				register2 := register4 + 22;
			WHEN "00001111" =>
				register3 := register2 * 24;
			WHEN "00010000" =>
				register3 := register3 + 26;
			WHEN "00010001" =>
				output3 <= register2 + register3;
				register1 := register1 + 29;
			WHEN "00010010" =>
				register2 := register1 + 31;
			WHEN "00010011" =>
				register2 := register2 * 33;
				register3 := register6 + register1;
			WHEN "00010100" =>
				register3 := register3 + 35;
				output4 <= register1 + register2;
			WHEN "00010101" =>
				register1 := register3 * 38;
			WHEN "00010110" =>
				register1 := register1 + 40;
			WHEN "00010111" =>
				output5 <= register3 + register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END ewf_femo_description;