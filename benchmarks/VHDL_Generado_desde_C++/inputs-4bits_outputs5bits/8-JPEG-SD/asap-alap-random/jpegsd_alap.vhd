-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.15:39:39)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY jpegsd_alap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18: IN unsigned(0 TO 3);
		output1, output2, output3: OUT unsigned(0 TO 4));
END jpegsd_alap_entity;

ARCHITECTURE jpegsd_alap_description OF jpegsd_alap_entity IS
	SIGNAL current_state : unsigned(0 TO 7) := "00000000";
	SHARED VARIABLE register1: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register2: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register3: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register4: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register5: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register6: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register7: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register8: unsigned(0 TO 4) := "00000";
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
			WHEN "00000010" =>
				register1 := ((NOT register1) + 1) XOR register1;
				register2 := ((NOT input2) + 1) XOR input2;
				register3 := input3 + 5;
				register4 := ((NOT input4) + 1) XOR input4;
			WHEN "00000011" =>
				register1 := register2 + register1;
				register2 := input5 + 7;
				register3 := ((NOT register3) + 1) XOR register3;
			WHEN "00000100" =>
				register1 := register1 + register4;
				register4 := input6 + 10;
				register2 := ((NOT register2) + 1) XOR register2;
			WHEN "00000101" =>
				register1 := register1 + register3;
				register3 := input7 + 13;
				register5 := input8 + 14;
				register6 := input9 + 15;
				register4 := ((NOT register4) + 1) XOR register4;
			WHEN "00000110" =>
				register1 := register1 + register2;
				register2 := input10 + 18;
				register3 := ((NOT register3) + 1) XOR register3;
				register5 := ((NOT register5) + 1) XOR register5;
				register7 := input11 + 23;
				register6 := ((NOT register6) + 1) XOR register6;
			WHEN "00000111" =>
				register1 := register1 + register4;
				register4 := input12 + 26;
				register8 := input13 + 27;
				register2 := ((NOT register2) + 1) XOR register2;
				register3 := register5 + register3;
				register5 := ((NOT register7) + 1) XOR register7;
			WHEN "00001000" =>
				register1 := register1 + register6;
				register4 := ((NOT register4) + 1) XOR register4;
				register6 := ((NOT input14) + 1) XOR input14;
				register7 := ((NOT register8) + 1) XOR register8;
				register2 := register3 + register2;
			WHEN "00001001" =>
				register1 := register1 + register5;
				register3 := input15 + 37;
				register5 := ((NOT input16) + 1) XOR input16;
				register4 := register6 + register4;
				register2 := register2 + register7;
			WHEN "00001010" =>
				register6 := register1 + 40;
				register3 := ((NOT register3) + 1) XOR register3;
				register4 := register4 + register5;
			WHEN "00001011" =>
				register2 := register1 + register6 + register2;
				register3 := register4 + register3;
			WHEN "00001100" =>
				register1 := register1 * register6 * register2;
				register2 := register3 * 44;
			WHEN "00001101" =>
				register1 := register2 + register1;
			WHEN "00001110" =>
				register1 := register3 + register1;
			WHEN "00001111" =>
				register1 := register1 srl 46;
				output1 <= input17 + 47;
				output2 <= input18 + 48;
			WHEN "00010000" =>
				output3 <= register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END jpegsd_alap_description;