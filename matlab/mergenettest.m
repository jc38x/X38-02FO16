
[dd, ld, rd, ed] = tt2mat('0090');
[dt, lt, rt, et] = tt2mat('0700');
[d2, l2, r2, e2] = tt2mat('D7FF');

[ld, ed] = make_instance('LUT0090', ld, rd, ed);
[lt, et] = make_instance('LUT0700', lt, rt, et);
[l2, e2] = make_instance('LUTD7FF', l2, r2, e2);

join = [{'LUT0090,o'; 'LUT0700,i3'},{'LUT0090,i1'; 'LUT0700,i2'}];

[d1, l1, r1, e1] = attach_net(dd, ld, rd, ed, dt, lt, rt, et, join);

join = [{'LUT0090,o'; 'LUTD7FF,i0'}];

[dx, lx, rx, ex] = attach_net(d1, l1, r1, e1, d2, l2, r2, e2, join);

%[dx, lx, rx, ex] = remove_port(dx, lx, rx, ex, find(strcmpi('LUT0090,o', lx)));



%[delay, labels, range, equations] = merge_net(delay, labels, range, equations, d2, l2, r2, e2, join);



bg = build_graph(dx, lx, rx, ex);
view(bg);
