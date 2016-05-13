-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.10:15:30)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesahb_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5: IN unsigned(0 TO 30);
		output1, output2: OUT unsigned(0 TO 31));
END mesahb_alap_entity;

ARCHITECTURE mesahb_alap_description OF mesahb_alap_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "0000000000000000000000000000000";
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
			WHEN "00000010" =>
				register1 := register1 + 3;
				register2 := input2 * 4;
			WHEN "00000011" =>
				register1 := register1 * 6;
				register3 := input3 * 7;
				register2 := register2 + 9;
			WHEN "00000100" =>
				register1 := register1 + 11;
				register3 := register3 + 13;
				register2 := ((NOT register2) + 1) XOR register2;
				register4 := input4 * 16;
			WHEN "00000101" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register3 := register3 * 20;
				register2 := register4 * register2;
			WHEN "00000110" =>
				register1 := register1 * 22;
				register3 := register3 + 24;
			WHEN "00000111" =>
				register1 := register1 + register2;
				output1 <= input5 + 25;
			WHEN "00001000" =>
				output2 <= register1(0 TO 14) & register3(0 TO 15);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesahb_alap_description;