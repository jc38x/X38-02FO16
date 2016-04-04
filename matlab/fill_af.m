%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% 10.1109/TCAD.2006.882119
%**************************************************************************

function [out_af, out_noedge] = fill_af(in_order, in_iedge, in_oedge, in_range)
out_af = zeros(1, in_range.sz);
out_noedge = zeros(1, in_range.sz);
for v = in_order 
    Av = double(is_in(v, in_range));
    for i = in_iedge{v}
        idx = i(1);
        out_noedge(idx) = size(in_oedge{idx}, 2);
        Av = Av + (out_af(idx) / out_noedge(idx));
    end
    out_af(v) = Av;
end
end
