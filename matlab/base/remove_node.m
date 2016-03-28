%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = remove_node(in_delay, in_labels, in_range, in_equations, in_node)
out_delay = in_delay;
out_labels = in_labels;
out_equations = in_equations;

out_delay(in_node, :) = [];
out_delay(:, in_node) = [];
out_labels(in_node) = [];
out_equations(in_node) = [];

out_range = prepare_range(in_range.szpi - sum(is_pi(in_node, in_range)), in_range.szin - sum(is_in(in_node, in_range)), in_range.szpo - sum(is_po(in_node, in_range)));
end
