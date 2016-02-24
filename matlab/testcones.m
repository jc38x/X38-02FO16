
K = 4;
DF = false;

%SRNG = rng();
%rng(SRNG)

t = tic();
%[delay, range] = sample_valavan();
%[delay, range] = random_dag(100, 5000, 60, 1, 10); %ok
[delay, range] = random_dag(1, 2000, 1, 1, 10); %ok
%[delay, range] = random_dag(385, 555, 60, 1, 10); %ok
%[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
%[delay, range] = random_dag(20, 30, 10, 1, 10); %ok
%[delay, range] = random_dag(1, 10, 1, 1, 10); %ok
%[delay, range] = random_dag(6, 6, 2, 1, 10); %ok
toc(t)

%[labels] = node_labels(range);

%bg = build_graph(delay, labels, range);
%view(bg);

%{


[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);

depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

t = tic();
[keys, cones] = generate_cones(order, iedge, oedge, range, K, DF);
toc(t)
%lv0 = cones(keys==40)
%lv1 = cones{keys==40}
%lv2 = lv1(1, :)


%lv2 = 
%}