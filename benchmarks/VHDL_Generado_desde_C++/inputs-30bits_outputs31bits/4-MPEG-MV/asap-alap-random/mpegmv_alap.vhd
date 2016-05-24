-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-13.07:37:13)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mpegmv_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14: IN unsigned(0 TO 30);
		output1, output2, output3: OUT unsigned(0 TO 31));
END mpegmv_alap_entity;

ARCHITECTURE mpegmv_alap_description OF mpegmv_alap_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register6: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register7: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register8: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register9: unsigned(0 TO 31) := "00000000000000000000000000000000";
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
			WHEN "00000010" =>
				register1 := register1 + 5;
				register4 := input4 * 6;
				register5 := input5 * 7;
				register2 := register2 + 9;
				register6 := input6 * 10;
				register3 := register3 + 12;
				register7 := input7 * 13;
			WHEN "00000011" =>
				register1 := register4 + register1;
				register4 := input8 * 14;
				register5 := register5 + 16;
				register8 := input9 * 17;
				register2 := register6 + register2;
				register6 := input10 * 18;
				register9 := input11 * 19;
				register3 := register7 + register3;
			WHEN "00000100" =>
				register7 := input12 * 20;
				register1 := register4 + register1;
				register4 := register8 + register5;
				register5 := input13 * 21;
				register2 := register6 + register2;
				register6 := register9 + 23;
				register8 := input14 * 24;
			WHEN "00000101" =>
				register3 := register7 + register3;
				register1 := ((NOT register1) + 1) XOR register1;
				register4 := register5 + register4;
				register2 := ((NOT register2) + 1) XOR register2;
				output1 <= register8 + register6;
			WHEN "00000110" =>
				output2 <= register1(0 TO 15) & register3(0 TO 15);
				output3 <= register2(0 TO 15) & register4(0 TO 15);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mpegmv_alap_description;