-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-13.07:45:36)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY mpegmv_femo_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14: IN unsigned(0 TO 30);
		output1, output2, output3: OUT unsigned(0 TO 31));
END mpegmv_femo_entity;

ARCHITECTURE mpegmv_femo_description OF mpegmv_femo_entity IS
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
			WHEN "00000010" =>
				register1 := register1 + 5;
			WHEN "00000011" =>
				register1 := register2 + register1;
				register2 := input4 * 6;
				register3 := register3 + 8;
			WHEN "00000100" =>
				register1 := register2 + register1;
				register2 := input5 * 9;
				register4 := input6 * 10;
			WHEN "00000101" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register5 := input7 * 13;
				output1 <= register2 + register3;
				register2 := input8 * 15;
				register3 := register4 + 17;
			WHEN "00000110" =>
				register3 := register5 + register3;
				register2 := register2 + 19;
				register4 := input9 * 20;
				register5 := input10 * 21;
				register6 := input11 * 22;
			WHEN "00000111" =>
				register3 := register5 + register3;
				register5 := input12 * 23;
				register2 := register6 + register2;
			WHEN "00001000" =>
				register2 := register5 + register2;
				register5 := input13 * 24;
				output2 <= register1(0 TO 15) & register3(0 TO 15);
			WHEN "00001001" =>
				register1 := register5 + 27;
			WHEN "00001010" =>
				register1 := register4 + register1;
				register3 := input14 * 28;
			WHEN "00001011" =>
				register1 := register3 + register1;
			WHEN "00001100" =>
				register1 := ((NOT register1) + 1) XOR register1;
			WHEN "00001101" =>
				output3 <= register1(0 TO 15) & register2(0 TO 15);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END mpegmv_femo_description;