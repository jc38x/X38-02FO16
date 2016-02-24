
K = 4;

t = tic();
%[delay, range] = sample_valavan();
%[delay, range] = random_dag(100, 5000, 60, 1, 10); %ok

[delay, range] = random_dag(385, 555, 60, 1, 10); %ok
%[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
%[delay, range] = random_dag(20, 30, 10, 1, 10); %ok
%[delay, range] = random_dag(6, 6, 2, 1, 10); %ok
toc(t)


bg = build_graph(delay, labels, range);
view(bg);
%{

t = tic();
[labels] = node_labels(range);

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);

depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);



[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, false, 20);

[result_delay, resulttag, result_range] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)




indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];


br = build_graph(result_delay, newlabels, result_range);

view(br);

%}