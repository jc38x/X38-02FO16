
K = 4;
DF = false;
mode = 2;
alpha = 2;
maxi = 20;
epsrand = [0.0001, 0.0005];

%RNG = rng();
rng(RNG);

t = tic();
%delay = result_delay;
%range = result_range;

%[delay, range] = sample_valavan();
%[delay, range] = random_dag(100, 5000, 60, 1, 10); %ok

%[delay, range] = random_dag(1, 495, 1, 1, 10);
%[delay, range] = random_dag(385, 555, 60, 1, 10); %ok
%[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
%[delay, range] = random_dag(5, 450, 3, 1, 10); %ok <<<<<<<<<<
[delay, range] = random_dag(1, 10, 1, 1, 10); %ok 360s
%[delay, range] = random_dag(6, 6, 2, 1, 10); %ok
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
[keys, cones] = generate_cones_all(order, iedge, oedge, range, K, DF, delay);
%toc(t)
%bg = build_graph(delay, labels, range);
%view(bg);







%[depthcones] = fill_depth_cones(cones, delay, depth);
%[afcones] = fill_af_cones(cones, af, noedge);



t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[result_delay, resulttag, result_range] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)


bg = build_graph(delay, labels, range);
view(bg);

indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];



br = build_graph(result_delay, newlabels, result_range);

view(br);



%{
%}