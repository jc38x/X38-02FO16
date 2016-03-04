%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_labels] = node_labels(in_range)
out_labels = cell(1, in_range.sz);
i = 1;
for n = 1:in_range.szpi, out_labels{i} = ['i' num2str(n)]; i = i + 1; end
for n = 1:in_range.szin, out_labels{i} = ['v' num2str(n)]; i = i + 1; end
for n = 1:in_range.szpo, out_labels{i} = ['o' num2str(n)]; i = i + 1; end
end
