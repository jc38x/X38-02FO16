%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_labels, out_equations] = rename_node(in_delay, in_labels, in_equations, in_node, in_newlabels)
out_labels = in_labels;
out_labels(in_node) = in_newlabels;
out_equations = in_equations;

for k = 1:numel(in_node)
    node = in_node(k);
    newlabel = in_newlabels{k};
    label = in_labels{node};
    for l = find(in_delay(node, :)), out_equations{l} = strrep(out_equations{l}, label, newlabel); end
end
end