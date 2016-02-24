
K = 256;

if (dagiter == 0)
    %[delay, range] = sample_valavan();
    [delay, range] = random_dag(385, 555, 60, 1, 10); %ok
    %[delay, range] = random_dag(100, 200, 10, 1, 10); %ok
    %[delay, range] = random_dag(20, 30, 10, 1, 10); %ok
    %[delay, range] = random_dag(6, 6, 2, 1, 10); %ok
    
    [labels] = node_labels(range);
    %bg = build_graph(delay, labels, range);
    %view(bg);
    dagiter = 1;
end

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);

depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, 20);
[newdelay, newtag, newrange] = rebuild_graph_from_cones(s, cv, iedge, delay, range);

indices = find(newtag);
[~, I] = sort(newtag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

disp([num2str(size(delay, 1)) ' -> ' num2str(size(newdelay, 1))]);

delay = newdelay;
labels = newlabels;
range = newrange;

%br = build_graph(delay, labels, range);
%view(br);

