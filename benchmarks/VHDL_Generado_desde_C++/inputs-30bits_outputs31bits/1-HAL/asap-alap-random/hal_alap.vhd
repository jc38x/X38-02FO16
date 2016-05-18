t-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.08:58:01)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY hal_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5: IN unsigned(0 TO 30);
		output1, output2, output3: OUT unsigned(0 TO 31));
END hal_alap_entity;

ARCHITECTURE hal_alap_description OF hal_alap_entity IS
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
			WHEN "00000010" =>
				register3 := input3 * 3;
				register1 := register2 * register1;
			WHEN "00000011" =>
				register2 := input4 * 4;
				register3 := register3 * 6;
				register1 := register1 - 8;
				register4 := input5 + 9;
			WHEN "00000100" =>
				output1 <= register2 + 10;
				output2 <= register1 - register3;
				IF (register4 < 12) THEN
					output3 <= register4;
				ELSE
					output3 <= "00000000000000000000000000001100";
				END IF;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END hal_alap_description;