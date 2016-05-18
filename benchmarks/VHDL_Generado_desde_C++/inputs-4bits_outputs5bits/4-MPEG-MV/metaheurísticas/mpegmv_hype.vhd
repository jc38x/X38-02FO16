-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-16.09:03:50)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mpegmv_hype_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14: IN unsigned(0 TO 3);
		output1, output2, output3: OUT unsigned(0 TO 4));
END mpegmv_hype_entity;

ARCHITECTURE mpegmv_hype_description OF mpegmv_hype_entity IS
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
			WHEN "00000010" =>
				register1 := register1 + 3;
				register2 := input2 * 4;
				register3 := input3 * 5;
			WHEN "00000011" =>
				register4 := input4 * 6;
				register5 := input5 * 7;
				register1 := register3 + register1;
				register2 := register2 + 9;
			WHEN "00000100" =>
				register3 := input6 * 10;
				register6 := input7 * 11;
				register5 := register5 + 13;
				output1 <= register4 + register2;
			WHEN "00000101" =>
				register2 := input8 * 15;
				register4 := input9 * 16;
				register3 := register3 + register5;
				register1 := register6 + register1;
			WHEN "00000110" =>
				register4 := register4 + 18;
				register5 := input10 * 19;
			WHEN "00000111" =>
				register2 := register2 + register4;
				register4 := input11 * 20;
				register1 := ((NOT register1) + 1) XOR register1;
				register6 := input12 * 23;
				register3 := register5 + register3;
			WHEN "00001000" =>
				register2 := register4 + register2;
				register4 := input13 * 24;
				register5 := input14 * 25;
				register6 := register6 + 27;
				output2 <= register1(0 TO 1) & register3(0 TO 2);
			WHEN "00001001" =>
				register1 := register5 + register6;
			WHEN "00001010" =>
				register1 := register4 + register1;
			WHEN "00001011" =>
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00001100" =>
				output3 <= register1(0 TO 1) & register2(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mpegmv_hype_description;