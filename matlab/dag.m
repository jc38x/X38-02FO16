
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



[result_delay, resulttag, result_range, resultequations] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);

toc(t)




bg = build_graph(delay, labels, range, equations);
view(bg);





indices = find(resulttag);
[~, I] = sort(resulttag(indices));

newlabels = [labels(range.pi), labels(indices(I)+double(range.szpi)), labels(range.po)];

br = build_graph(result_delay, newlabels, result_range, resultequations);

view(br);

[LUTS, lutinputs] = cones2luts(result_range, resultequations);


%out_x = [];
%res
    
    %outi = 0;
    %signalmap = containers.Map(signals, num2cell(0:(ns - 1)));
    %outi = outi + 1;
    %x = inputs
    %zeros(4, numel(inputs) / 4); 
    
    
    
    
    %signals
    %inputs