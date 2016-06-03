%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_equations] = sort_graph(in_delay, in_labels, in_range, in_equations)
index = [in_range.pi, get_inorder(in_delay, in_range), in_range.po];
inremap = C_remap(index, in_range.all);

[di, dj, ds] = get_edges(in_delay);

out_delay = sparse(inremap.remap(di), inremap.remap(dj), ds, in_range.sz, in_range.sz);
out_labels = in_labels(index);
out_equations = in_equations(index);
end
