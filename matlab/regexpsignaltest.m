
string = 'and(and(and(not([inst_1,port_4(2)]), and([inst_2,port_3], not(and([port_2], [port_1(10)])))), [inst_z,bus(5)@O]),[in5f,busz_(2)@I]),[bus(0)@O]),[bus@I])';
signals = regexp_signals(string, true, true);
