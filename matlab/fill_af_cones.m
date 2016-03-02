
function [out_af] = fill_af_cones(in_cones, in_af, in_noedge)
allsz = size(in_cones, 2);
out_af = cell(1, allsz);
for i = [1:allsz]
    cones = in_cones{i};
    csz = size(cones, 2);
    af = zeros(1, csz);
    for j = [1:csz]
        selaf = 1;
        for e = cones{3, j}
            e1 = e(1);
            selaf = selaf + (in_af(e1) / in_noedge(e1));
        end
        af(j) = selaf;
    end
    out_af{i} = af;
end
end
