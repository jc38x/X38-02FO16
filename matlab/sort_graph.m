%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_equations] = sort_graph(in_delay, in_labels, in_range, in_equations)
inremap = C_remap([in_range.pi, get_inorder(in_delay, in_range), in_range.po], in_range.all);
index = inremap.remap(in_range.all);

[i, j, s] = get_edges(in_delay);

out_delay = sparse(inremap.remap(i), inremap.remap(j), s, in_range.sz, in_range.sz);
out_labels = in_labels(index);
out_equations = in_equations(index);
end
