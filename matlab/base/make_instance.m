%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_labels, out_equations] = make_instance(in_name, in_delay, in_labels, in_range, in_equations)
[out_labels, out_equations] = rename_node(in_delay, in_labels, in_equations, in_range.all, strcat(in_name, ',', in_labels)); 
end
