
K = 3;
DF = false;


t = tic();



%[delay, labels, range] = sample_valavan();
[delay, labels, range] = sample_aaghalfadder();


[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
equations = get_aig_equations(iedge, labels, range);

[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));



[result_delay, resulttag, result_range, resultequations] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);

toc(t)




bg = build_graph(delay, labels, range, equations);
view(bg);





indices = find(resulttag);
[~, I] = sort(resulttag(indices));

newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

br = build_graph(result_delay, newlabels, result_range, resultequations);

view(br);


