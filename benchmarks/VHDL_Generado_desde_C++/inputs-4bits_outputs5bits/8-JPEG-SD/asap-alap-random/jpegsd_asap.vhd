-- IT Tijuana, NetList-FPGA-Optimizer 0.01 (printed on 2016-05-26.15:39:22)

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.NUMERIC_STD.all;

ENTITY jpegsd_asap_entity IS
	PORT (
		reset, clk: IN std_logic;
		input1, input2, input3, input4, input5, input6, input7, input8, input9, input10, input11, input12, input13, input14, input15, input16, input17, input18: IN unsigned(0 TO 3);
		output1, output2, output3: OUT unsigned(0 TO 4));
END jpegsd_asap_entity;

ARCHITECTURE jpegsd_asap_description OF jpegsd_asap_entity IS
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
	SHARED VARIABLE register15: unsigned(0 TO 4) := "00000";
	SHARED VARIABLE register16: unsigned(0 TO 4) := "00000";
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
				register1 := ((NOT input1) + 1) XOR input1;
				register2 := input2 + 2;
				register3 := input3 + 3;
				register4 := input4 + 4;
				register5 := input5 + 5;
				register6 := input6 + 6;
				output1 <= input7 + 7;
				output2 <= input8 + 8;
				register7 := ((NOT input9) + 1) XOR input9;
				register8 := input10 + 10;
				register9 := input11 + 11;
				register10 := input12 + 12;
				register11 := input13 + 13;
				register12 := input14 + 14;
				register13 := ((NOT input15) + 1) XOR input15;
				register14 := ((NOT input16) + 1) XOR input16;
				register15 := input17 + 17;
				register16 := input18 + 18;
			WHEN "00000010" =>
				register2 := ((NOT register2) + 1) XOR register2;
				register3 := ((NOT register3) + 1) XOR register3;
				register4 := ((NOT register4) + 1) XOR register4;
				register5 := ((NOT register5) + 1) XOR register5;
				register6 := ((NOT register6) + 1) XOR register6;
				register8 := ((NOT register8) + 1) XOR register8;
				register9 := ((NOT register9) + 1) XOR register9;
				register10 := ((NOT register10) + 1) XOR register10;
				register11 := ((NOT register11) + 1) XOR register11;
				register12 := ((NOT register12) + 1) XOR register12;
				register15 := ((NOT register15) + 1) XOR register15;
				register16 := ((NOT register16) + 1) XOR register16;
			WHEN "00000011" =>
				register2 := register8 + register2;
				register3 := register7 + register3;
				register1 := register1 + register12;
			WHEN "00000100" =>
				register2 := register2 + register16;
				register3 := register3 + register14;
				register1 := register1 + register13;
			WHEN "00000101" =>
				register2 := register2 + register15;
				register3 := register3 + register10;
				register1 := register1 + register4;
			WHEN "00000110" =>
				register3 := register3 + register5;
				register4 := register1 * 44;
			WHEN "00000111" =>
				register3 := register3 + register9;
			WHEN "00001000" =>
				register3 := register3 + register11;
			WHEN "00001001" =>
				register3 := register3 + register6;
			WHEN "00001010" =>
				register5 := register3 + 46;
			WHEN "00001011" =>
				register2 := register3 + register5 + register2;
			WHEN "00001100" =>
				register2 := register3 * register5 * register2;
			WHEN "00001101" =>
				register2 := register4 + register2;
			WHEN "00001110" =>
				register1 := register1 + register2;
			WHEN "00001111" =>
				register1 := register1 srl 48;
			WHEN "00010000" =>
				output3 <= register1;
			WHEN OTHERS =>
				NULL;
		END CASE;
	END PROCESS operations;

END jpegsd_asap_description;