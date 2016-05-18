-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-13.07:45:24)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mpegmv_nsga2_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14: IN unsigned(0 TO 3);
		output1, output2, output3: OUT unsigned(0 TO 4));
END mpegmv_nsga2_entity;

ARCHITECTURE mpegmv_nsga2_description OF mpegmv_nsga2_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register2: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register3: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register4: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register5: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register6: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register7: unsigned(0 TO 4) := "00000";
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
				register3 := input3 * 5;
			WHEN "00000011" =>
				register3 := register3 + 7;
				register2 := register2 + 9;
				register4 := input4 * 10;
				register5 := input5 * 11;
			WHEN "00000100" =>
				register4 := register4 + 13;
				register6 := input6 * 14;
				register1 := register5 + register1;
				register5 := input7 * 15;
				register7 := input8 * 16;
			WHEN "00000101" =>
				register1 := register7 + register1;
				register7 := input9 * 17;
			WHEN "00000110" =>
				output1 <= register7 + register3;
				register3 := input10 * 19;
				register4 := register6 + register4;
				register2 := register5 + register2;
				register1 := ((NOT register1) + 1) XOR register1;
				register5 := input11 * 22;
			WHEN "00000111" =>
				register4 := register5 + register4;
				register5 := input12 * 23;
			WHEN "00001000" =>
				output2 <= register1(0 TO 1) & register4(0 TO 2);
				register1 := input13 * 25;
				register2 := register5 + register2;
			WHEN "00001001" =>
				register2 := ((NOT register2) + 1) XOR register2;
				register4 := input14 * 28;
				register1 := register1 + 30;
			WHEN "00001010" =>
				register1 := register4 + register1;
			WHEN "00001011" =>
				register1 := register3 + register1;
			WHEN "00001100" =>
				output3 <= register2(0 TO 1) & register1(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mpegmv_nsga2_description;