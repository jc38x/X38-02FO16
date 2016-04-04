%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_height] = fill_height(in_redro, in_oedge, in_delay, in_range)
out_height = zeros(1, in_range.sz);
for v = in_redro
    for e = in_oedge{v}
        idx = e(2);
        h = out_height(idx) + in_delay(v, idx);
        if (h > out_height(v)), out_height(v) = h; end
    end
end
end
