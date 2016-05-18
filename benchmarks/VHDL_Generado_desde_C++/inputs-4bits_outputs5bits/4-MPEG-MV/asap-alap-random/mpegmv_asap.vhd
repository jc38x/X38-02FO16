-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-13.07:37:02)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mpegmv_asap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14: IN unsigned(0 TO 3);
		output1, output2, output3: OUT unsigned(0 TO 4));
END mpegmv_asap_entity;

ARCHITECTURE mpegmv_asap_description OF mpegmv_asap_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register2: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register3: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register4: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register5: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register6: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register7: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register8: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register9: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register10: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register11: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register12: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register13: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register14: unsigned(0 TO 4) := "00000";
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
				register5 := input5 * 5;
				register6 := input6 * 6;
				register7 := input7 * 7;
				register8 := input8 * 8;
				register9 := input9 * 9;
				register10 := input10 * 10;
				register11 := input11 * 11;
				register12 := input12 * 12;
				register13 := input13 * 13;
				register14 := input14 * 14;
			WHEN "00000010" =>
				register1 := register1 + 16;
				register6 := register6 + 18;
				register7 := register7 + 20;
				register9 := register9 + 22;
				register13 := register13 + 24;
			WHEN "00000011" =>
				register1 := register2 + register1;
				register2 := register4 + register6;
				output1 <= register3 + register7;
				register3 := register8 + register9;
				register4 := register12 + register13;
			WHEN "00000100" =>
				register1 := register14 + register1;
				register2 := register5 + register2;
				register3 := register10 + register3;
				register4 := register11 + register4;
			WHEN "00000101" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register4 := ((NOT register4) + 1) XOR register4;
			WHEN "00000110" =>
				output2 <= register1(0 TO 1) & register3(0 TO 2);
				output3 <= register4(0 TO 1) & register2(0 TO 2);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mpegmv_asap_description;