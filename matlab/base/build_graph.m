%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_bg] = build_graph(in_delay, in_labels, in_range, in_equations)
out_bg = biograph(in_delay);
for n = in_range.all
    node = out_bg.Nodes(n);
    node.Label = in_labels{n};
    node.Shape = 'circle';   
    if     (is_pi(n, in_range)), color = [0.5 0.5 1.0];
    elseif (is_in(n, in_range)), color = [1.0 1.0 0.5];
    elseif (is_po(n, in_range)), color = [1.0 0.5 0.5];
    else                         error('Unknown node.');
    end
    node.Color = color;
    node.Description = in_equations{n};
end
out_bg.ShowWeights = 'on';
end
