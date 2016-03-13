
K = 4;
DF = false;


t = tic();



[delay, labels, range] = sample_aaghalfadder();

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));



[result_delay, resulttag, result_range] = rebuild_graph_from_cones(s, cv, delay, range);

toc(t)




bg = build_graph(delay, labels, range);
view(bg);





indices = find(resulttag);
[~, I] = sort(resulttag(indices));

newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

br = build_graph(result_delay, newlabels, result_range);

view(br);


