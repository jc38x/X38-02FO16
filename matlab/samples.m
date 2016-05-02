
[delay, labels, range, equations] = sample_valavan();
%[delay, labels, range, equations] = sample_aighalfadder();
%[delay, labels, range, equations] = sample_aigflipflop();
%[delay, labels, range, edges] = sample_edif(false);
%[delay, labels, range, edges] = sample_edif_special(false);
%[delay, labels, range, edges] = sample_ISE_mapped(false);


%view(build_graph(delay, labels, range, equations));


[delay, labels, equations] = sort_graph(delay, labels, range, equations);
view(build_graph(delay, labels, range, equations));



%ndepth = fill_depth(delay, range);
%nheight = fill_height(delay, range);
%[naf, nnoedge] = fill_af(delay, range);
%[in_iedge, in_oedge] = fill_edges(delay, range);

[s, cv] = hara(delay, range, 1, 4, 1, 1.5, 0, 0);






[rd, rl, rr, re] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);
view(build_graph(rd, rl, rr, re));

luts = cones2luts(rd, rl, rr, re);
view(build_graph(rd, rl, rr, luts));



%fname = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/latch2.aig';


%[labels, equations] = rename_node(delay, labels, equations, [range.pi(1), range.po(2)], {'top,port(1)@O', 'top,port(1)@I'});




%mat2aiger(fname, delay, labels, range, equations);


%[df, lf, rf, ef] = aiger2mat(fname);

%bf = build_graph(df, lf, rf, ef);
%view(bf);




%[iedge, oedge] = prepare_edges(delay);
%equations = get_aig_equations(delay, iedge, labels, range);

%{
cone
1 nodes
2 internal edges
3 iedges
4 oedges root
5 oedges others
6 iedges max depth


%}
 %qualified = port{1};
    %bp = find(qualified == '(');
    %be = find(qualified == ')');
    %out_instance = qualified([1:(bp - 1), (be + 1):end]);
    %out_cell = strremovespaces(qualified((bp + 1):(be - 1)));
    
    
    
    
    
    %out_istop = strcmp(qualified, topname);