%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_bg] = build_graph(in_delay, in_labels, in_range, in_equations)
out_bg = biograph(in_delay);
for n = 1:numel(out_bg.nodes)
    out_bg.Nodes(n).Label = in_labels{n};
    out_bg.Nodes(n).Shape = 'circle';   
    if     (n <= in_range.pihi), out_bg.Nodes(n).Color = [0.5 0.5 1.0];
    elseif (n <= in_range.inhi), out_bg.Nodes(n).Color = [1.0 1.0 0.5];
    else                         out_bg.Nodes(n).Color = [1.0 0.5 0.5];
    end
    %in_equations{n}
    out_bg.Nodes(n).Description = in_equations{n};
end
out_bg.ShowWeights = 'on';
end
