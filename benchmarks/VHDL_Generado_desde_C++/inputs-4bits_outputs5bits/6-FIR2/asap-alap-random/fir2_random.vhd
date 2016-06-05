-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.14:43:58)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY fir2_random_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16: IN unsigned(0 TO 3);
		output1: OUT unsigned(0 TO 4));
END fir2_random_entity;

ARCHITECTURE fir2_random_description OF fir2_random_entity IS
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
				register1 := not input1 or input1;
				register2 := not input2 or input2;
				register3 := not input3 or input3;
				register4 := not input4 or input4;
				register5 := not input5 or input5;
				register6 := not input6 or input6;
				register7 := not input7 or input7;
				register8 := not input8 or input8;
				register9 := not input9 or input9;
				register10 := not input10 or input10;
			WHEN "00000010" =>
				register11 := not input11 or input11;
				register12 := not input12 or input12;
				register13 := not input13 or input13;
				register14 := not input14 or input14;
				register2 := register5 + register2;
			WHEN "00000011" =>
				register2 := register2 * 16;
				register5 := register9 + register7;
				register7 := not input15 or input15;
				register1 := register13 + register1;
				register9 := not input16 or input16;
				register6 := register14 + register6;
			WHEN "00000100" =>
				register6 := register6 * 20;
				register5 := register5 * 22;
				register3 := register3 + register8;
				register4 := register4 + register12;
				register7 := register10 + register7;
			WHEN "00000101" =>
				register3 := register3 * 24;
				register4 := register4 * 26;
				register8 := register11 + register9;
			WHEN "00000110" =>
				register7 := register7 * 28;
				register8 := register8 * 30;
			WHEN "00000111" =>
				register1 := register1 * 32;
				register5 := register8 + register5;
			WHEN "00001000" =>
				register5 := register7 + register5;
			WHEN "00001001" =>
				register4 := register4 + register5;
			WHEN "00001010" =>
				register4 := register6 + register4;
			WHEN "00001011" =>
				register3 := register3 + register4;
			WHEN "00001100" =>
				register1 := register1 + register3;
			WHEN "00001101" =>
				register1 := register2 + register1;
			WHEN "00001110" =>
				output1 <= to_unsigned(2 ** to_integer(register1), 4);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END fir2_random_description;