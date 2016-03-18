
K = 4;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

%rng(RNG);

t = tic();
%[delay, range] = sample_valavan();
%[delay, range] = random_dag(20, 30, 5, 1, 10); %ok
[delay, labels, range, equations] = random_dag(10, 20, 5, 1, 10); %ok
toc(t)

bg = build_graph(delay, labels, range, equations);
view(bg);

%{
t = tic();
%[labels] = node_labels(range);
[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);

depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
toc(t)

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resulttag, resultrange] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)


t = tic();
indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

bg = build_graph(delay, labels, range);
view(bg);

br = build_graph(resultdelay, newlabels, resultrange);
view(br);
toc(t)


[resultiedge, resultoedge] = prepare_edges(resultdelay);
resultorder = graphtopoorder(resultdelay);
resultredro = fliplr(resultorder);

resultdepth = fill_depth(resultorder, resultiedge, resultdelay, resultrange);
resultheight = fill_height(resultredro, resultoedge, resultdelay, resultrange);
[resultaf, resultnoedge] = fill_af(resultorder, resultiedge, resultoedge, resultrange);



%RNG = rng();
%rng(RNG);
%delay = result_delay;
%range = result_range;

%[delay, range] = sample_valavan();
%[delay, range] = random_dag(100, 5000, 60, 1, 10); %ok

%[delay, range] = random_dag(1, 495, 1, 1, 10);
%[delay, range] = random_dag(385, 555, 60, 1, 10); %ok
%[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
%[delay, range] = random_dag(30, 1950, 20, 1, 10); %ok <<<<<<<<<<
%[delay, range] = random_dag(30, 50, 20, 1, 10); %ok 360s
%[delay, range] = random_dag(30, 40, 20, 1, 10); %ok



%t = tic();
%[keys, cones] = generate_cones_all(order, iedge, oedge, range, K, DF, delay);
%toc(t)
%bg = build_graph(delay, labels, range);
%view(bg);
%[depthcones] = fill_depth_cones(cones, delay, depth);
%[afcones] = fill_af_cones(cones, af, noedge);

%}





%{
[resultiedge, resultoedge] = prepare_edges(resultdelay);
resultorder = graphtopoorder(resultdelay);
resultredro = fliplr(resultorder);


resultdepth = fill_depth(resultorder, resultiedge, resultdelay, resultrange);
resultheight = fill_height(resultredro, resultoedge, resultdelay, resultrange);
[resultaf, resultnoedge] = fill_af(resultorder, resultiedge, resultoedge, resultrange);
%}