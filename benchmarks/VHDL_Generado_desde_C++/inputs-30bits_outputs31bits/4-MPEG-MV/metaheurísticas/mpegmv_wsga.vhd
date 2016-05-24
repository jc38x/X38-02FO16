-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-16.09:04:32)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mpegmv_wsga_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14: IN unsigned(0 TO 30);
		output1, output2, output3: OUT unsigned(0 TO 31));
END mpegmv_wsga_entity;

ARCHITECTURE mpegmv_wsga_description OF mpegmv_wsga_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register2: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register3: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register4: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register5: unsigned(0 TO 31) := "00000000000000000000000000000000";
	SHARED VARIABLE register6: unsigned(0 TO 31) := "00000000000000000000000000000000";
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
				register4 := register4 + 6;
				register5 := input5 * 7;
				register6 := input6 * 8;
				register3 := register3 + 10;
				register2 := register2 + 12;
			WHEN "00000011" =>
				register1 := register1 + register2;
				register2 := register6 + register3;
				register3 := input7 * 13;
				register4 := register5 + register4;
				register5 := input8 * 14;
			WHEN "00000100" =>
				register1 := register5 + register1;
				register5 := input9 * 15;
				register2 := register3 + register2;
				register3 := input10 * 16;
			WHEN "00000101" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register6 := input11 * 19;
				register3 := register3 + 21;
			WHEN "00000110" =>
				output1 <= register5 + register3;
				register3 := input12 * 23;
				register5 := register6 + 25;
			WHEN "00000111" =>
				register3 := register3 + register5;
				register5 := input13 * 26;
				output2 <= register1(0 TO 15) & register2(0 TO 15);
			WHEN "00001000" =>
				register1 := register5 + register3;
				register2 := input14 * 28;
			WHEN "00001001" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register2 := register2 + register4;
			WHEN "00001010" =>
				output3 <= register1(0 TO 15) & register2(0 TO 15);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mpegmv_wsga_description;