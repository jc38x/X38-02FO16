-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.10:15:41)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mesahb_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5: IN unsigned(0 TO 30);
		output1, output2: OUT unsigned(0 TO 31));
END mesahb_random_entity;

ARCHITECTURE mesahb_random_description OF mesahb_random_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "00000000000000000000000000000000";
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
			WHEN "00000010" =>
				register2 := register2 + 6;
				register4 := register4 + 8;
				output1 <= input5 + 9;
			WHEN "00000011" =>
				register4 := ((NOT register4) + 1) XOR register4;
			WHEN "00000100" =>
				register3 := register3 * register4;
				register1 := register1 + 13;
				register2 := register2 * 15;
			WHEN "00000101" =>
				register2 := register2 + 17;
			WHEN "00000110" =>
				register2 := ((NOT register2) + 1) XOR register2;
			WHEN "00000111" =>
				register2 := register2 * 21;
			WHEN "00001000" =>
				register2 := register2 + register3;
				register1 := register1 * 23;
			WHEN "00001001" =>
				register1 := register1 + 25;
			WHEN "00001010" =>
				output2 <= register2(0 TO 15) & register1(0 TO 15);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mesahb_random_description;