
K = 4;
DF = false;
mode = 2;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

%RNG = rng();
%rng(RNG);

t = tic();
%delay = result_delay;
%range = result_range;

%[delay, range] = sample_valavan();
%[delay, range] = random_dag(100, 5000, 60, 1, 10); %ok

%[delay, range] = random_dag(1, 495, 1, 1, 10);
%[delay, range] = random_dag(385, 555, 60, 1, 10); %ok
%[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
%[delay, range] = random_dag(30, 1950, 20, 1, 10); %ok <<<<<<<<<<
%[delay, range] = random_dag(30, 50, 20, 1, 10); %ok 360s
[delay, range] = random_dag(30, 30, 20, 1, 10); %ok
toc(t)

t = tic();
[labels] = node_labels(range);

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);


depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

toc(t)

%t = tic();
%[keys, cones] = generate_cones_all(order, iedge, oedge, range, K, DF, delay);
%toc(t)
%bg = build_graph(delay, labels, range);
%view(bg);
%[depthcones] = fill_depth_cones(cones, delay, depth);
%[afcones] = fill_af_cones(cones, af, noedge);

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resulttag, resultrange] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)

bg = build_graph(delay, labels, range);
view(bg);

indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

br = build_graph(resultdelay, newlabels, resultrange);
view(br);


[resultiedge, resultoedge] = prepare_edges(resultdelay);
resultorder = graphtopoorder(resultdelay);
resultredro = fliplr(resultorder);


resultdepth = fill_depth(resultorder, resultiedge, resultdelay, resultrange);
resultheight = fill_height(resultredro, resultoedge, resultdelay, resultrange);
[resultaf, resultnoedge] = fill_af(resultorder, resultiedge, resultoedge, resultrange);
