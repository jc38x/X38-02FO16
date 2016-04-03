
[d, l, r, e] = ngcedif2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/matlab/sample_ISE_mapped.edif');


bg = build_graph(d, l, r, e);
view(bg);
