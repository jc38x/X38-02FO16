-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.14:51:43)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY fir2_femo_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16: IN unsigned(0 TO 3);
		output1: OUT unsigned(0 TO 4));
END fir2_femo_entity;

ARCHITECTURE fir2_femo_description OF fir2_femo_entity IS
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
				register1 := not input1 or input1;
				register2 := not input2 or input2;
			WHEN "00000010" =>
				register1 := register2 + register1;
				register2 := not input3 or input3;
				register3 := not input4 or input4;
				register4 := not input5 or input5;
			WHEN "00000011" =>
				register2 := register2 + register3;
				register3 := not input6 or input6;
			WHEN "00000100" =>
				register2 := register2 * 8;
				register1 := register1 * 10;
				register5 := not input7 or input7;
				register3 := register4 + register3;
				register4 := not input8 or input8;
			WHEN "00000101" =>
				register4 := register4 + register5;
				register5 := not input9 or input9;
				register6 := not input10 or input10;
			WHEN "00000110" =>
				register5 := register6 + register5;
				register6 := not input11 or input11;
				register4 := register4 * 17;
			WHEN "00000111" =>
				register1 := register1 + register4;
				register4 := not input12 or input12;
				register5 := register5 * 20;
				register3 := register3 * 22;
			WHEN "00001000" =>
				register4 := register4 + register6;
				register6 := not input13 or input13;
				register7 := not input14 or input14;
				register1 := register3 + register1;
			WHEN "00001001" =>
				register1 := register2 + register1;
				register2 := not input15 or input15;
				register3 := register7 + register6;
				register6 := not input16 or input16;
				register4 := register4 * 28;
			WHEN "00001010" =>
				register1 := register4 + register1;
			WHEN "00001011" =>
				register1 := register5 + register1;
				register3 := register3 * 30;
				register2 := register6 + register2;
			WHEN "00001100" =>
				register2 := register2 * 32;
				register1 := register3 + register1;
			WHEN "00001101" =>
				register1 := register2 + register1;
			WHEN "00001110" =>
				output1 <= to_unsigned(2 ** to_integer(register1), 4);
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END fir2_femo_description;