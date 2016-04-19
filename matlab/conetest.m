
K = 4;
DF = false;

[delay, labels, range, equations] = load_leko_leku('leko-g5\g25');
%[delay, labels, range, equations] = sample_valavan();

%view(build_graph(delay, labels, range, equations));

[iedge, oedge] = prepare_edges(delay, range);
order = graphtopoorder(delay);
inorder = get_inorder(delay, range);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

t = tic();
[cones] = generate_cones(inorder, iedge, oedge, range, K);
toc(t);
