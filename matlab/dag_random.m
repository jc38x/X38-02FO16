
K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

%[delay, range] = sample_valavan();
[delay, labels, range, equations] = random_dag(20, 30, 5, 1, 9); %ok
%[delay, labels, range, equations] = sample_valavan();%random_dag(20, 50, 10, 1, 9); %ok

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

bg = build_graph(delay, labels, range, equations);
view(bg);

br = build_graph(resultdelay, resultlabels, resultrange, resultequations);
view(br);
