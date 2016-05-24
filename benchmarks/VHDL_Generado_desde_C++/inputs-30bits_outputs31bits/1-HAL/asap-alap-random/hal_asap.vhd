-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-12.08:57:10)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY hal_asap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5: IN unsigned(0 TO 30);
		output1, output2, output3: OUT unsigned(0 TO 31));
END hal_asap_entity;

ARCHITECTURE hal_asap_description OF hal_asap_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "0000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "0000000000000000000000000000000";
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
				register2 := input2 * 2;
				register3 := input3 * 3;
				register4 := input4 * 4;
				register5 := input5 * 5;
			WHEN "00000010" =>
				IF (register1 < 6) THEN
					output1 <= register1;
				ELSE
					output1 <= "0000000000000000000000000000110";
				END IF;
				register1 := register2 * register3;
				register2 := register4 * 8;
				output2 <= register5 + 9;
			WHEN "00000011" =>
				register1 := register1 - 11;
			WHEN "00000100" =>
				output3 <= register1 - register2;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END hal_asap_description;