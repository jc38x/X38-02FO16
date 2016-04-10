
string = 'and(not([inst_1,port_4(2)]), and([inst_2,port_3], not(and([port_2], [port_1(10)]))))';
signals = regexp_signals(string);
