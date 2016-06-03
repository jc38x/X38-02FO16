-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.15:30:58)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY fir1_wsga_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18, input19, input20, input21, input22: IN unsigned(0 TO 3);
		output1: OUT unsigned(0 TO 4));
END fir1_wsga_entity;

ARCHITECTURE fir1_wsga_description OF fir1_wsga_entity IS
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
				register1 := input1 and input1;
				register2 := input2 and input2;
				register3 := input3 and input3;
				register4 := input4 and input4;
			WHEN "00000010" =>
				register5 := input5 and input5;
				register6 := input6 and input6;
				register7 := input7 and input7;
				register1 := register1 * register4;
				register4 := input8 and input8;
				register2 := register3 * register2;
			WHEN "00000011" =>
				register3 := register6 * register4;
				register4 := input9 and input9;
				register6 := input10 and input10;
				register5 := register7 * register5;
				register7 := input11 and input11;
			WHEN "00000100" =>
				register6 := register6 * register7;
				register7 := input12 and input12;
			WHEN "00000101" =>
				register4 := register4 * register7;
				register3 := register6 + register3;
			WHEN "00000110" =>
				register2 := register3 + register2;
				register3 := input13 and input13;
				register6 := input14 and input14;
				register7 := input15 and input15;
				register8 := input16 and input16;
			WHEN "00000111" =>
				register3 := register8 * register3;
				register8 := input17 and input17;
				register9 := input18 and input18;
				register10 := input19 and input19;
				register11 := input20 and input20;
				register1 := register1 + register2;
			WHEN "00001000" =>
				register2 := input21 and input21;
				register6 := register10 * register6;
				register9 := register11 * register9;
				register7 := register8 * register7;
			WHEN "00001001" =>
				register5 := register5 + register9;
				register8 := input22 and input22;
				register6 := register7 + register6;
			WHEN "00001010" =>
				register1 := register6 + register1;
			WHEN "00001011" =>
				register1 := register1 + register4;
				register2 := register2 * register8;
			WHEN "00001100" =>
				register1 := register5 + register1;
			WHEN "00001101" =>
				register1 := register1 + register2;
			WHEN "00001110" =>
				register1 := register3 + register1;
			WHEN "00001111" =>
				output1 <= register1 and register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END fir1_wsga_description;