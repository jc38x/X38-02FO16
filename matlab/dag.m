
K = 3;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

t = tic();

%[delay, labels, range] = sample_valavan();
%[delay, labels, range] = sample_aaghalfadder();
[delay, labels, range] = sample_aaglatch();

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
equations = get_aig_equations(iedge, labels, range);

[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));

[result_delay, newlabels, result_range, resultequations] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);

toc(t)

bg = build_graph(delay, labels, range, equations);
view(bg);

br = build_graph(result_delay, newlabels, result_range, resultequations);
view(br);

[LUTS, lutinputs] = cones2luts(result_range, resultequations);





    %{
indices = find(resulttag);
[~, I] = sort(resulttag(indices));
newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];
%}

    %{
    equation = in_equations{cvidx + ofs};
    if (subn < 2)
        out_equations{i2} = equation;
        continue;
    end
    %}
%out_equation{i2} = strrep(out_equation{i2}, in_labels{l}, ['(' in_equations{l} ')']);
%for j = in_range.po
    %    d = in_delay(i, j);
    %    if (d > 0), push_edge(i, j - poofs, in_delay(i, j)); end
    %end

%node2uid = containers.Map(in_labels, num2cell(1:in_range.sz));
%out_delay = spalloc(nsz, nsz, maxedges);
%delay = in_delay(e1, e(2));
        %out_delay(i1, i2) = delay;
        %delay = in_delay(e(1), e2);
        %out_delay(i2, i1) = delay;
%out_x = [];
%res
    
    %outi = 0;
    %signalmap = containers.Map(signals, num2cell(0:(ns - 1)));
    %outi = outi + 1;
    %x = inputs
    %zeros(4, numel(inputs) / 4); 
    
    
    
    
    %signals
    %inputs