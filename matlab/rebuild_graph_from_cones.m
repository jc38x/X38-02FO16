%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = rebuild_graph_from_cones(in_S, in_Cv, in_delay, in_range, in_labels, in_equations)
nin = numel(in_S);
nsz = in_range.szpi + nin + in_range.szpo;
ofs = in_range.pihi;
poofs = in_range.szin - nin;
adjS = in_S - ofs;
tag = sparse(1, adjS, (1:nin) + ofs);

maxedges = sum(in_delay(:) > 0);
edgesindex = 0;
edgesi = zeros(1, maxedges);
edgesj = zeros(1, maxedges);
edgesd = zeros(1, maxedges);

out_equations = cell(1, nsz);
out_equations(in_range.pi) = in_equations(in_range.pi);
out_equations(in_range.po - poofs) = in_equations(in_range.po);

indices = find(tag);
[~, I] = sort(tag(indices));
out_labels = [in_labels(in_range.pi), in_labels(indices(I) + in_range.szpi), in_labels(in_range.po)];

for i = in_range.pi
    fj = find(in_delay(i, :));
    for j = fj(is_po(fj, in_range)), push_edge(i, j - poofs, in_delay(i, j)); end
end

for cvidx = adjS
    vcone = in_Cv{cvidx};
    i2 = tag(cvidx);
    
    for e = vcone{in_range.CONE_IEDGE}
        e1 = e(1);
        if (is_in(e1, in_range)), i1 = tag(e1 - ofs); else i1 = e1; end
        push_edge(i1, i2, in_delay(e1, e(2)));
    end
    for e = vcone{in_range.CONE_OEDGE}
        e2 = e(2);
        if (is_in(e2, in_range)), continue; end
        push_edge(i2, e2 - poofs, in_delay(e(1), e2));
    end
    
    node = vcone{in_range.CONE_NODE};
    subn = numel(node);   
    noderemap = containers.Map(num2cell(node), 1:subn);
    edge = vcone{in_range.CONE_EDGE};
    conegraph = sparse(cell2mat(noderemap.values(num2cell(edge(1, :)))), cell2mat(noderemap.values(num2cell(edge(2, :)))), 1, subn, subn);    
    coneorder = graphtopoorder(conegraph);
    coneorder = coneorder(1:(subn-1));
    redroenoc = fliplr(coneorder);
    keys = noderemap.keys();
    remapnode = containers.Map(noderemap.values(keys), keys);
    redroenoc = cell2mat(remapnode.values(num2cell(redroenoc)));

    equation = in_equations{cvidx + ofs};
    for l = redroenoc, equation = strrep(equation, ['[' in_labels{l} ']'], ['(' in_equations{l} ')']); end
    out_equations{i2} = equation;
end

k = 1:edgesindex;
out_delay = sparse(edgesi(k), edgesj(k), edgesd(k), nsz, nsz);

pilo = in_range.pilo;
pihi = in_range.pihi;
inlo = in_range.pihi + 1;
inhi = in_range.pihi + nin;
polo = inhi + 1;
pohi = inhi + in_range.szpo;

out_range = prepare_range(pilo, pihi, inlo, inhi, polo, pohi);

    function push_edge(in_o, in_i, in_d)
    edgesindex = edgesindex + 1;
    edgesi(edgesindex) = in_o;
    edgesj(edgesindex) = in_i;
    edgesd(edgesindex) = in_d;
    end
end
