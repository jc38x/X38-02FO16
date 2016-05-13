-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.10:17:23)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesahb_wsga_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5: IN unsigned(0 TO 3);
		output1, output2: OUT unsigned(0 TO 4));
END mesahb_wsga_entity;

ARCHITECTURE mesahb_wsga_description OF mesahb_wsga_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register2: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register3: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register4: unsigned(0 TO 4) := "00000";
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
				register2 := register2 + 4;
				output1 <= input3 + 5;
				register1 := register1 + 7;
			WHEN "00000011" =>
				register2 := register2 * 9;
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00000100" =>
				register2 := register2 + 13;
				register3 := input4 * 14;
			WHEN "00000101" =>
				register2 := ((NOT register2) + 1) XOR register2;
				register3 := register3 + 18;
				register4 := input5 * 19;
			WHEN "00000110" =>
				register3 := register3 * 21;
				register1 := register4 * register1;
				register2 := register2 * 23;
			WHEN "00000111" =>
				register1 := register2 + register1;
				register2 := register3 + 25;
			WHEN "00001000" =>
				output2 <= register1(0 TO 1) & register2(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesahb_wsga_description;