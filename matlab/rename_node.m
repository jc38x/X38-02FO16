
function [out_labels, out_equations] = rename_node(in_delay, in_labels, in_equations, in_node, in_newlabels)
out_labels = in_labels;
out_labels(in_node) = in_newlabels;
out_equations = in_equations;

for k = in_node
    onode = find(
    
    
end




end
