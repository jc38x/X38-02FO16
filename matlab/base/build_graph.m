%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_bg] = build_graph(in_delay, in_labels, in_range, in_equations)
out_bg = biograph(in_delay);
for n = 1:numel(out_bg.Nodes)
    node = out_bg.Nodes(n);
    node.Label = in_labels{n};
    node.Shape = 'circle';   
    if     (n <= in_range.pihi), node.Color = [0.5 0.5 1.0];
    elseif (n <= in_range.inhi), node.Color = [1.0 1.0 0.5];
    else                         node.Color = [1.0 0.5 0.5];
    end
    node.Description = in_equations{n};
end
out_bg.ShowWeights = 'on';
end
