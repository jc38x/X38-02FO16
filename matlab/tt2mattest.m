
K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

[delay, labels, range, equations] = tt2mat('03');

[iedge, oedge] = prepare_edges(delay);
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

bg = build_graph(delay, labels, range, equations);
view(bg);

br = build_graph(resultdelay, resultlabels, resultrange, resultequations);
view(br);

[luts, inputs] = cones2luts(resultrange, resultequations, {'[i0]', '[i1]', '[i2]'});


