
K = 4;
DF = false;
mode = 2;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.000, 0.000]; %small


%[delay, labels, range, equations] = load_leko_leku('leko-g5\g25');
[delay, labels, range, equations] = load_lgsynth93('blif\alu4');

filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/lekog25.aig';
mat2aiger(filename, delay, labels, range, equations);
%{
script = [
    {['read_aiger ' filename]};
    {'cleanup'};
    {'refactor'};
    {['write_aiger -s ' filename]};
    {'cec'}
    {'quit'};
    ];
%}
script = {
    'resyn2';
    'resyn2rs';
    'resyn2rs';
    'resyn2rs';
    'resyn2rs';
    'resyn2rs';
    };

invoke_abc(script, false);

[delay, labels, range, equations] = aiger2mat(filename);

[iedge, oedge] = prepare_edges(delay, range);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t);

[resultdf, resultlf, resultrf, resultef] = rebuild_graph_from_cones(s, cv, delay, range, labels, equations);
[lutsf] = cones2luts(resultdf, resultlf, resultrf, resultef);
