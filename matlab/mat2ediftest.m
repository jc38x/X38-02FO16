
K = 3;
DF = false;
mode = 1;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

[delay, labels, range] = sample_aaghalfadder();

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
equations = get_aig_equations(iedge, labels, range);

[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));

[resultdelay, resultlabels, resultrange, resultequations] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);

bg = build_graph(delay, labels, range, equations);
view(bg);

br = build_graph(resultdelay, resultlabels, resultrange, resultequations);
view(br);

[luts, inputs] = cones2luts(resultrange, resultequations);

ediffname = 'C:\Users\jcds\Documents\GitHub\X38-02FO16\ediftest.edif';
mat2edif(ediffname, resultdelay, resultlabels, resultrange, luts, inputs);

[edifdelay, ediflabels, edifrange] = edif2mat(ediffname, false);

edifequations = cell(1, edifrange.sz);
edifequations(1:end) = {''};

be = build_graph(edifdelay, ediflabels, edifrange, edifequations);
view(be);



%redroenoc = ;
    %keys = noderemap.keys();
    %remapnode = containers.Map(noderemap.values(keys), keys);
    %redroenoc = cell2mat(remapnode.values(num2cell(redroenoc)));
    
    
    %equation = in_equations{cvidx + in_range.pihi};
    %for l = redroenoc, equation = strrep(equation, ['[' in_labels{l} ']'], ['(' in_equations{l} ')']); end
    %out_equations{i2} = equation;
    
    %conegraph = 0;
	%coneorder = ;
    %ofs = in_range.pihi;
