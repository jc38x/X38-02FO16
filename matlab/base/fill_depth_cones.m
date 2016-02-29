
function [out_depth] = fill_depth_cones(in_cones, in_delay, in_depth)
allsz = size(in_cones, 2);
out_depth = cell(1, allsz);
for i = [1:allsz]
    cones = in_cones{i};
    csz = size(cones, 2);
    depth = zeros(1, csz);
    for j = [1:csz]
        maxdepth = 0;
        for e = cones{3, j}
            e1 = e(1);
            d = in_depth(e1) + in_delay(e1, e(2));
            if (d > maxdepth), maxdepth = d; end
        end
        depth(j) = maxdepth;
    end
    out_depth{i} = depth;
end
end
