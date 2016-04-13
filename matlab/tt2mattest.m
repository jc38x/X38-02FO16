
K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

t = tic();
[delay, labels, range, equations] = tt2mat('0000', 1);
%[labels, equations] = rename_node(delay, labels, equations, [1,2,3,4], {'I0', 'I1', 'I2', 'I3'});
[labels, equations] = rename_node(delay, labels, equations, 1, {'I0'});
[labels, equations] = make_instance('LUT4_B', delay, labels, range, equations);
toc(t)

bg = build_graph(delay, labels, range, equations);
view(bg);

mat2aiger('C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/tt2mat1.aig', delay, labels, range, equations);

[delay, labels, range, equations] = aiger2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/tt2mat1.aig');

bg = build_graph(delay, labels, range, equations);
view(bg);



[iedge, oedge] = prepare_edges(delay, range);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resultlabels, resultrange, resultequations] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations); %in_S, in_Cv, in_delay, in_range, in_labels, in_equations
toc(t)

[luts] = cones2luts(resultdelay, resultlabels, resultrange, resultequations);

br = build_graph(resultdelay, resultlabels, resultrange, luts);
view(br);


