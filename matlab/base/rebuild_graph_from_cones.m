%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_tag, out_range] = rebuild_graph_from_cones(in_S, in_Cv, in_delay, in_range)
nin = numel(in_S);
nsz = in_range.szpi + nin + in_range.szpo;
ofs = in_range.pihi;
poofs = in_range.szin - nin;

out_delay = spalloc(nsz, nsz, sum(in_delay(:) > 0));
out_tag = sparse(1, [in_S - ofs], [[1:nin] + ofs]);

for visible = in_S
    cvidx = visible - ofs;
    vcone = in_Cv{cvidx};
    i2 = out_tag(cvidx);
    for e = vcone{3}
        e1 = e(1);
        if (is_in(e1, in_range)), i1 = out_tag(e1 - ofs); else i1 = e1; end
        delay = in_delay(e1, e(2));
        if (delay > out_delay(i1, i2)), out_delay(i1, i2) = delay; end
    end
    for e = vcone{4}
        e2 = e(2);
        if (is_in(e2, in_range)), continue; end
        i1 = e2 - poofs;
        delay = in_delay(e(1), e2);
        if (delay > out_delay(i2, i1)), out_delay(i2, i1) = delay; end
    end
end

pilo = in_range.pilo;
pihi = in_range.pihi;
inlo = in_range.pihi + 1;
inhi = in_range.pihi + nin;
polo = inhi + 1;
pohi = inhi + in_range.szpo;
out_range = prepare_range(pilo, pihi, inlo, inhi, polo, pohi);
end
