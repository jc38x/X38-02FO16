
%[delay, labels, range] = sample_valavan();
%[delay, labels, range] = sample_aaghalfadder();
[delay, labels, range, equations] = sample_aiglatch();
%[delay, labels, range, edges] = sample_edif(false);
%[delay, labels, range, edges] = sample_edif_special(false);
%[delay, labels, range, edges] = sample_ISE_mapped(false);

fname = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/latch.aig';


bg = build_graph(delay, labels, range, equations);
view(bg);

mat2aig(fname, delay, labels, range, equations);


[df, lf, rf, ef] = aiger2mat(fname);

bf = build_graph(df, lf, rf, ef);
view(bf);

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