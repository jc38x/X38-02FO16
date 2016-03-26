
[dd, ld, rd, ed] = tt2mat('0090');
[dt, lt, rt, et] = tt2mat('0700');

join = [{'o' ; 'i3'},{'i1'; 'i2'}];


[delay, labels, range, equations] = merge_net(dd, ld, rd, ed, dt, lt, rt, et, join);

bg = build_graph(delay, labels, range, equations);
view(bg);
