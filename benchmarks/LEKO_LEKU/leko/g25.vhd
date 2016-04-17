-- Xilinx XPort Language Converter, Version 4.1 (110)
-- 
-- ABEL Design Source: C:\home\kirill\xillinx\testing.abl
-- VHDL Design Output: testing.vhd
-- Created 02-Sep-2005 12:24 PM
--
-- Copyright (c) 2005, Xilinx, Inc.  All Rights Reserved.
-- Xilinx Inc makes no warranty, expressed or implied, with respect to
-- the operation and/or functionality of the converted output files.
-- 

-- ee200 assignment 1

Library IEEE;
   use IEEE.std_logic_1164.all;
entity testing is
   Port (
      A40, A39, A73: buffer std_logic;
      A299, A265, A298: in std_logic;
      A105: buffer std_logic;
      A202, A201: in std_logic;
      A43, A8, A41: buffer std_logic;
      A269, A232, A170: in std_logic;
      A106: buffer std_logic;
      A166: in std_logic;
      A76: buffer std_logic;
      A234, A236, A167: in std_logic;
      A109, A140: buffer std_logic;
      A300: in std_logic;
      A42: buffer std_logic;
      A203, A267: in std_logic;
      A108: buffer std_logic;
      A235, A233: in std_logic;
      A74: buffer std_logic;
      A301, A168: in std_logic;
      A138, A7, A139, A142, A6: buffer std_logic;
      A268: in std_logic;
      A141, A10, A72: buffer std_logic;
      A200: in std_logic;
      A75: buffer std_logic;
      A169: in std_logic;
      A107, A9: buffer std_logic;
      A266, A302, A199: in std_logic
   );
end testing;


architecture testing_behav of testing is
   signal A165, A12, A137, A188, A270, A317, A314, A61, A258, A119, A66, A220,
	 A309, A230, A112, A295, A69, A310, A121, A325, A284, A91, A93, A257,
	 A34, A195, A160, A57, A321, A173, A281, A186, A89, A179, A48, A239,
	 A13, A120, A253, A23, A154, A50, A211, A190, A206, A175, A16, A68,
	 A38, A17, A225, A44, A129, A244, A85, A131, A192, A104, A273, A254,
	 A113, A223, A243, A4, A96, A101, A311, A318, A117, A124, A78, A147,
	 A324, A216, A161, A259, A31, A56, A315, A97, A231, A128, A278, A178,
	 A3, A22, A60, A198, A250, A26, A100, A306, A287, A261, A171, A227,
	 A94, A59, A82, A288, A172, A246, A185, A151, A155, A132, A30, A35,
	 A183, A224, A79, A189, A328, A14, A323, A116, A293, A65, A320, A207,
	 A88, A193, A305, A249, A327, A237, A215, A219, A277, A176, A53, A18,
	 A296, A125, A294, A228, A47, A280, A25, A217, A102, A205, A46, A67,
	 A5, A255, A251, A204, A272, A222, A64, A98, A95, A164, A135, A285,
	 A70, A149, A32, A312, A81, A49, A275, A248, A208, A123, A282, A289,
	 A146, A177, A159, A2, A118, A90, A297, A182, A242, A110, A152, A283,
	 A197, A83, A319, A307, A36, A241, A264, A326, A63, A260, A194, A144,
	 A330, A163, A212, A158, A291, A114, A133, A51, A229, A304, A29, A316,
	 A87, A28, A62, A54, A33, A276, A290, A322, A303, A145, A184, A111,
	 A274, A214, A58, A20, A226, A126, A245, A80, A86, A196, A52, A313,
	 A143, A218, A103, A209, A156, A11, A174, A187, A115, A71, A240, A256,
	 A92, A1, A247, A292, A150, A210, A134, A238, A162, A286, A329, A148,
	 A252, A213, A45, A21, A27, A127, A221, A99, A153, A263, A191, A19,
	 A37, A77, A24, A157, A279, A181, A55, A15, A271, A84, A262, A308,
	 A122, A180, A136, A130: std_logic;
begin

-- Start of original equations
   A198 <= A176 and A191;
   A197 <= (not A176) and (not A198);
   A196 <= A176 or A191;
   A195 <= (not A169) or (not A170);
   A194 <= A176 or A191;
   A193 <= (not A192) and (not A176);
   A192 <= A176 and A191;
   A191 <= (not A167) or (not A168);
   A190 <= A168 and A180;
   A189 <= A169 or A176;
   A188 <= A169 or A170;
   A187 <= (not A197) or (not A196);
   A186 <= A195 and A188;
   A185 <= ((not A169) and A176) or (A169 and (not A176));
   A184 <= (not A193) or (not A194);
   A183 <= (A168 and A180) or ((not A168) and (not A180));
   A182 <= A190 or A167;
   A181 <= A187 and A168;
   A180 <= A189 and A188;
   A179 <= A184 and A168;
   A178 <= A186 and A185;
   A177 <= ((not A178) and A168) or (A178 and (not A168));
   A176 <= ((not A166) and A167) or (A166 and (not A167));
   A175 <= A176 and A183;
   A174 <= A176 and A182;
   A173 <= A181 or A180;
   A172 <= A179 or A178;
   A171 <= A177 and A176;
   A204 <= A210 and A209;
   A205 <= A212 or A211;
   A206 <= A214 or A213;
   A207 <= A209 and A215;
   A208 <= A209 and A216;
   A209 <= ((not A199) and A200) or (A199 and (not A200));
   A210 <= ((not A211) and A201) or (A211 and (not A201));
   A211 <= A219 and A218;
   A212 <= A217 and A201;
   A213 <= A222 and A221;
   A214 <= A220 and A201;
   A215 <= A223 or A200;
   A216 <= (A201 and A213) or ((not A201) and (not A213));
   A217 <= (not A226) or (not A227);
   A218 <= ((not A202) and A209) or (A202 and (not A209));
   A219 <= A228 and A221;
   A220 <= (not A230) or (not A229);
   A221 <= A202 or A203;
   A222 <= A202 or A209;
   A223 <= A201 and A213;
   A224 <= (not A200) or (not A201);
   A225 <= A209 and A224;
   A226 <= (not A225) and (not A209);
   A227 <= A209 or A224;
   A228 <= (not A202) or (not A203);
   A229 <= A209 or A224;
   A230 <= (not A209) and (not A231);
   A231 <= A209 and A224;
   A237 <= A243 and A242;
   A238 <= A245 or A244;
   A239 <= A247 or A246;
   A240 <= A242 and A248;
   A241 <= A242 and A249;
   A242 <= ((not A232) and A233) or (A232 and (not A233));
   A243 <= ((not A244) and A234) or (A244 and (not A234));
   A244 <= A252 and A251;
   A245 <= A250 and A234;
   A246 <= A255 and A254;
   A247 <= A253 and A234;
   A248 <= A256 or A233;
   A249 <= (A234 and A246) or ((not A234) and (not A246));
   A250 <= (not A259) or (not A260);
   A251 <= ((not A235) and A242) or (A235 and (not A242));
   A252 <= A261 and A254;
   A253 <= (not A263) or (not A262);
   A254 <= A235 or A236;
   A255 <= A235 or A242;
   A256 <= A234 and A246;
   A257 <= (not A233) or (not A234);
   A258 <= A242 and A257;
   A259 <= (not A258) and (not A242);
   A260 <= A242 or A257;
   A261 <= (not A235) or (not A236);
   A262 <= A242 or A257;
   A263 <= (not A235) or A235;
   A264 <= A242 and A257;
   A270 <= A276 and A275;
   A271 <= A278 or A277;
   A272 <= A280 or A279;
   A273 <= A275 and A281;
   A274 <= A275 and A282;
   A275 <= ((not A265) and A266) or (A265 and (not A266));
   A276 <= ((not A277) and A267) or (A277 and (not A267));
   A277 <= A285 and A284;
   A278 <= A283 and A267;
   A279 <= A288 and A287;
   A280 <= A286 and A267;
   A281 <= A289 or A266;
   A282 <= (A267 and A279) or ((not A267) and (not A279));
   A283 <= (not A292) or (not A293);
   A284 <= ((not A268) and A275) or (A268 and (not A275));
   A285 <= A294 and A287;
   A286 <= (not A296) or (not A295);
   A287 <= A268 or A269;
   A288 <= A268 or A275;
   A289 <= A267 and A279;
   A290 <= (not A266) or (not A267);
   A291 <= A275 and A290;
   A292 <= (not A291) and (not A275);
   A293 <= A275 or A290;
   A294 <= (not A268) or (not A269);
   A295 <= A275 or A290;
   A296 <= (not A275) and (not A297);
   A297 <= A275 and A290;
   A303 <= A309 and A308;
   A304 <= A311 or A310;
   A305 <= A313 or A312;
   A306 <= A308 and A314;
   A307 <= A308 and A315;
   A308 <= ((not A298) and A299) or (A298 and (not A299));
   A309 <= ((not A310) and A300) or (A310 and (not A300));
   A310 <= A318 and A317;
   A311 <= A316 and A300;
   A312 <= A321 and A320;
   A313 <= A319 and A300;
   A314 <= A322 or A299;
   A315 <= (A300 and A312) or ((not A300) and (not A312));
   A316 <= (not A325) or (not A326);
   A317 <= ((not A301) and A308) or (A301 and (not A308));
   A318 <= A327 and A320;
   A319 <= (not A329) or (not A328);
   A320 <= A301 or A302;
   A321 <= A301 or A308;
   A322 <= A300 and A312;
   A323 <= (not A299) or (not A300);
   A324 <= A308 and A323;
   A325 <= (not A324) and (not A308);
   A326 <= A308 or A323;
   A327 <= (not A301) or (not A302);
   A328 <= A308 or A323;
   A329 <= (not A308) and (not A330);
   A330 <= A308 and A323;
   A165 <= A143 and A158;
   A164 <= (not A143) and (not A165);
   A163 <= A143 or A158;
   A162 <= (not A136) or (not A137);
   A161 <= A143 or A158;
   A160 <= (not A159) and (not A143);
   A159 <= A143 and A158;
   A158 <= (not A134) or (not A135);
   A157 <= A135 and A147;
   A156 <= A136 or A143;
   A155 <= A136 or A137;
   A154 <= (not A164) or (not A163);
   A153 <= A162 and A155;
   A152 <= ((not A136) and A143) or (A136 and (not A143));
   A151 <= (not A160) or (not A161);
   A150 <= (A135 and A147) or ((not A135) and (not A147));
   A149 <= A157 or A134;
   A148 <= A154 and A135;
   A147 <= A156 and A155;
   A146 <= A151 and A135;
   A145 <= A153 and A152;
   A144 <= ((not A145) and A135) or (A145 and (not A135));
   A143 <= ((not A133) and A134) or (A133 and (not A134));
   A142 <= A143 and A150;
   A141 <= A143 and A149;
   A140 <= A148 or A147;
   A139 <= A146 or A145;
   A138 <= A144 and A143;
   A137 <= A307;
   A136 <= A274;
   A135 <= A241;
   A134 <= A208;
   A133 <= A171;
   A132 <= A110 and A125;
   A131 <= (not A110) and (not A132);
   A130 <= A110 or A125;
   A129 <= (not A103) or (not A104);
   A128 <= A110 or A125;
   A127 <= (not A126) and (not A110);
   A126 <= A110 and A125;
   A125 <= (not A101) or (not A102);
   A124 <= A102 and A114;
   A123 <= A103 or A110;
   A122 <= A103 or A104;
   A121 <= (not A131) or (not A130);
   A120 <= A129 and A122;
   A119 <= ((not A103) and A110) or (A103 and (not A110));
   A118 <= (not A127) or (not A128);
   A117 <= (A102 and A114) or ((not A102) and (not A114));
   A116 <= A124 or A101;
   A115 <= A121 and A102;
   A114 <= A123 and A122;
   A113 <= A118 and A102;
   A112 <= A120 and A119;
   A111 <= ((not A112) and A102) or (A112 and (not A102));
   A110 <= ((not A100) and A101) or (A100 and (not A101));
   A109 <= A110 and A117;
   A108 <= A110 and A116;
   A107 <= A115 or A114;
   A106 <= A113 or A112;
   A105 <= A111 and A110;
   A104 <= A306;
   A103 <= A273;
   A102 <= A240;
   A101 <= A207;
   A100 <= A172;
   A99 <= A77 and A92;
   A98 <= (not A77) and (not A99);
   A97 <= A77 or A92;
   A96 <= (not A70) or (not A71);
   A95 <= A77 or A92;
   A94 <= (not A93) and (not A77);
   A93 <= A77 and A92;
   A92 <= (not A68) or (not A69);
   A91 <= A69 and A81;
   A90 <= A70 or A77;
   A89 <= A70 or A71;
   A88 <= (not A98) or (not A97);
   A87 <= A96 and A89;
   A86 <= ((not A70) and A77) or (A70 and (not A77));
   A85 <= (not A94) or (not A95);
   A84 <= (A69 and A81) or ((not A69) and (not A81));
   A83 <= A91 or A68;
   A82 <= A88 and A69;
   A81 <= A90 and A89;
   A80 <= A85 and A69;
   A79 <= A87 and A86;
   A78 <= ((not A79) and A69) or (A79 and (not A69));
   A77 <= ((not A67) and A68) or (A67 and (not A68));
   A76 <= A77 and A84;
   A75 <= A77 and A83;
   A74 <= A82 or A81;
   A73 <= A80 or A79;
   A72 <= A78 and A77;
   A71 <= A305;
   A70 <= A272;
   A69 <= A239;
   A68 <= A206;
   A67 <= A173;
   A66 <= A44 and A59;
   A65 <= (not A44) and (not A66);
   A64 <= A44 or A59;
   A63 <= (not A37) or (not A38);
   A62 <= A44 or A59;
   A61 <= (not A60) and (not A44);
   A60 <= A44 and A59;
   A59 <= (not A35) or (not A36);
   A58 <= A36 and A48;
   A57 <= A37 or A44;
   A56 <= A37 or A38;
   A55 <= (not A65) or (not A64);
   A54 <= A63 and A56;
   A53 <= ((not A37) and A44) or (A37 and (not A44));
   A52 <= (not A61) or (not A62);
   A51 <= (A36 and A48) or ((not A36) and (not A48));
   A50 <= A58 or A35;
   A49 <= A55 and A36;
   A48 <= A57 and A56;
   A47 <= A52 and A36;
   A46 <= A54 and A53;
   A45 <= ((not A46) and A36) or (A46 and (not A36));
   A44 <= ((not A34) and A35) or (A34 and (not A35));
   A43 <= A44 and A51;
   A42 <= A44 and A50;
   A41 <= A49 or A48;
   A40 <= A47 or A46;
   A39 <= A45 and A44;
   A38 <= A304;
   A37 <= A271;
   A36 <= A238;
   A35 <= A205;
   A34 <= A174;
   A1 <= A303;
   A2 <= A270;
   A3 <= A237;
   A4 <= A204;
   A5 <= A175;
   A6 <= A12 and A11;
   A7 <= A14 or A13;
   A8 <= A16 or A15;
   A9 <= A11 and A17;
   A10 <= A11 and A18;
   A11 <= ((not A1) and A2) or (A1 and (not A2));
   A12 <= ((not A13) and A3) or (A13 and (not A3));
   A13 <= A21 and A20;
   A14 <= A19 and A3;
   A15 <= A24 and A23;
   A16 <= A22 and A3;
   A17 <= A25 or A2;
   A18 <= (A3 and A15) or ((not A3) and (not A15));
   A19 <= (not A28) or (not A29);
   A20 <= ((not A4) and A11) or (A4 and (not A11));
   A21 <= A30 and A23;
   A22 <= (not A32) or (not A31);
   A23 <= A4 or A5;
   A24 <= A4 or A11;
   A25 <= A3 and A15;
   A26 <= (not A2) or (not A3);
   A27 <= A11 and A26;
   A28 <= (not A27) and (not A11);
   A29 <= A11 or A26;
   A30 <= (not A4) or (not A5);
   A31 <= A11 or A26;
   A32 <= (not A11) and (not A33);
   A33 <= A11 and A26;
end testing_behav;
