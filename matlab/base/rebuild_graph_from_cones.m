%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = rebuild_graph_from_cones(in_S, in_Cv, in_delay, in_range, in_labels, in_equations)
nin = numel(in_S);
poofs = in_range.szin - nin;
tag = sparse(1, in_S, (1:nin) + in_range.szpi);
maxedges = nnz(in_delay);

edgesx     = zeros(1, maxedges);
edgesi     = zeros(1, maxedges);
edgesj     = zeros(1, maxedges);
edgesd     = zeros(1, maxedges);
edgesindex = 0;

out_range = prepare_range(in_range.szpi, nin, in_range.szpo);

out_equations = cell(1, out_range.sz);
out_equations(in_range.pi)         = in_equations(in_range.pi);
out_equations(in_range.po - poofs) = in_equations(in_range.po);

out_labels = [in_labels(in_range.pi), in_labels(in_S), in_labels(in_range.po)];

for input = in_range.pi
    outputs = get_onode(in_delay, input);
    for output = outputs(is_po(outputs, in_range)), push_edge(input, output - poofs, in_delay(input, output)); end
end

for cvidx = in_S
    vcone = in_Cv{cvidx};
    i2 = tag(cvidx);
    
    for e = vcone{in_range.CONE_IEDGE}
        e1 = e(1);
        if (is_in(e1, in_range)), i1 = tag(e1); else i1 = e1; end
        push_edge(i1, i2, in_delay(e1, e(2)));
    end
    
    for e = vcone{in_range.CONE_OEDGE}
        e2 = e(2);
        if (is_in(e2, in_range)), continue; end
        push_edge(i2, e2 - poofs, in_delay(e(1), e2));
    end

    node = vcone{in_range.CONE_NODE};
    subn = numel(node);
    noderemap = C_remap(node, 1:subn); 
    edge = vcone{in_range.CONE_EDGE};
    coneorder = graphtopoorder(sparse(noderemap.remap(edge(1, :)), noderemap.remap(edge(2, :)), 1, subn, subn));
    equation = in_equations{cvidx};
    for l = node(fliplr(coneorder(1:(subn - 1)))), equation = strrep(equation, ['[' in_labels{l} ']'], in_equations{l}); end
    out_equations{i2} = equation;
end

k = 1:edgesindex;
out_delay = sparse(edgesi(k), edgesj(k), edgesd(k), out_range.sz, out_range.sz);

    function push_edge(in_o, in_i, in_d)
    index = sub2ind([out_range.sz, out_range.sz], in_o, in_i);
    match = edgesx == index;
    if (any(match))
        if (in_d > edgesd(match)), edgesd(match) = in_d; end
    else
        edgesindex = edgesindex + 1;
        edgesx(edgesindex) = index;
        edgesi(edgesindex) = in_o;
        edgesj(edgesindex) = in_i;
        edgesd(edgesindex) = in_d;
    end
    end
end
