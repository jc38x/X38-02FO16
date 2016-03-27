
[dd, ld, rd, ed] = tt2mat('0090');
[dt, lt, rt, et] = tt2mat('0700');

[ld, ed] = make_instance('LUT0090', ld, rd, ed);
[lt, et] = make_instance('LUT0700', lt, rt, et);

join = [{'LUT0090,o'; 'LUT0700,i3'},{'LUT0090,i1'; 'LUT0700,i2'}];


[delay, labels, range, equations] = merge_net(dd, ld, rd, ed, dt, lt, rt, et, join);

bg = build_graph(delay, labels, range, equations);
view(bg);
