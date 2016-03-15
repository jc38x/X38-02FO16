
[delay, labels, range] = sample_valavan();
ttinit = cell(1, range.szin);
ttinit(1:end) = {'FFFF'};

mat2edif('C:\Users\jcds\Documents\GitHub\X38-02FO16\ediftest.edif', delay, labels, range, ttinit);
fclose('all');
