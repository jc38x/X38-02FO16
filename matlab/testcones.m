
K = 4;
DF = false;

[delay, range] = sample_valavan();
[labels] = node_labels(range);

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
