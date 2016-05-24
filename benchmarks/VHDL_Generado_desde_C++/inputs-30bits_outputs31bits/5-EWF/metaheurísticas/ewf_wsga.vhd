-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-17.11:31:50)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY ewf_wsga_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2: IN unsigned(0 TO 30);
		output1, output2, output3, output4, output5: OUT unsigned(0 TO 31));
END ewf_wsga_entity;

ARCHITECTURE ewf_wsga_description OF ewf_wsga_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register6: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register7: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register8: unsigned(0 TO 31) := "00000000000000000000000000000000";
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
				register3 := input2 + 4;
			WHEN "00000011" =>
				register4 := register2 + 6;
			WHEN "00000100" =>
				register4 := register3 + register4;
			WHEN "00000101" =>
				register5 := register4 * 8;
			WHEN "00000110" =>
				register5 := register2 + register5;
				register6 := register4 * 10;
			WHEN "00000111" =>
				register4 := register4 + register5;
				register6 := register3 + register6;
				register2 := register2 + register5;
			WHEN "00001000" =>
				output1 <= register6 + register4;
				register3 := register3 + register6;
				register2 := register2 * 13;
			WHEN "00001001" =>
				register3 := register3 * 15;
				register2 := register1 + register2;
			WHEN "00001010" =>
				register3 := register3 + 17;
				register1 := register1 + register2;
				register4 := register5 + register2;
			WHEN "00001011" =>
				register4 := register4 + 19;
				register5 := register6 + register3;
				register1 := register1 * 21;
				register6 := register3 + 23;
			WHEN "00001100" =>
				register6 := register6 * 25;
				register5 := register5 + 27;
				register1 := register1 + 29;
				register7 := register4 * 31;
			WHEN "00001101" =>
				register8 := register5 * 33;
				register7 := register7 + 35;
				output2 <= register3 + register6;
				output3 <= register2 + register1;
			WHEN "00001110" =>
				register1 := register8 + 39;
				output4 <= register4 + register7;
			WHEN "00001111" =>
				output5 <= register5 + register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END ewf_wsga_description;