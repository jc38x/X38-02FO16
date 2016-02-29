
K = 4;
DF = true;
mode = 2;

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
%[delay, range] = random_dag(20, 30, 10, 1, 10); %ok
[delay, range] = random_dag(1, 20, 1, 1, 10); %ok 360s
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
%[keys, cones] = generate_cones_all(order, iedge, oedge, range, K, DF);
%toc(t)



t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, 1);
toc(t)

t = tic();
[result_delay, resulttag, result_range] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)




indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

bg = build_graph(delay, labels, range);
view(bg);

br = build_graph(result_delay, newlabels, result_range);

view(br);
%%{

%{
%}