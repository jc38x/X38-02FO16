
K = 4;
DF = false;
mode = 2;
alpha = 1.5; %1.5-2.5
maxi = 1; %20
epsrand = [0.000, 0.000]; %small








t = tic();
%[d, l, r, e, edif] = ngcedif2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/sample_ISE_mapped.edif');
[d, l, r, e, edif] = ngcedif2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/practica3.ndf');

toc(t)

check_network(d, r, e);

%bg = build_graph(d, l, r, e);
%view(bg);

filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/sample_ISE_mapped.aig';
optname = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/sample_ISE_mapped_SIM.aig';

mat2aiger(filename, d, l, r, e);

script = [
    {['read_aiger ' filename ';']};
    {'refactor'};
    {['write_aiger -s ' optname]};
    {'cec'}
    {'quit'};
    ];

invoke_abc(script);

[df, lf, rf, ef] = aiger2mat(optname);

check_network(df, rf, ef);

[iedgef, oedgef] = prepare_edges(df, rf);
orderf = graphtopoorder(df);
redrof = fliplr(orderf);
depthf = fill_depth(orderf, iedgef, df, rf);
heightf = fill_height(redrof, oedgef, df, rf);
[aff, noedgef] = fill_af(orderf, iedgef, oedgef, rf);

[sf, cvf] = hara(orderf, iedgef, oedgef, noedgef, df, depthf, heightf, aff, rf, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
[resultdf, resultlf, resultrf, resultef] = rebuild_graph_from_cones(sf, cvf, df, rf, lf, ef);

%[lutsf, inputsf, namesf] = cones2luts(resultlf, resultrf, resultef, []);
[lutsf] = cones2luts(resultdf, resultlf, resultrf, resultef);
