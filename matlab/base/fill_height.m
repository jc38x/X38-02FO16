%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_height] = fill_height(in_delay, in_range)
out_height = zeros(1, in_range.sz);
for v = fliplr(get_inorder(in_delay, in_range))
    for e = get_onode(in_delay, v)
        h = out_height(e) + in_delay(v, e);
        if (h > out_height(v)), out_height(v) = h; end
    end
end
end
