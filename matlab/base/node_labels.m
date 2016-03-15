%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_labels] = node_labels(in_range)
m = max([in_range.szpi, in_range.szin, in_range.szpo]);
n2s = cell(1, m);
out_labels = cell(1, in_range.sz);
i = 1;
for n = 1:m, n2s{n} = num2str(n); end
for n = 1:in_range.szpi, out_labels{i} = ['i' n2s{n}]; i = i + 1; end
for n = 1:in_range.szin, out_labels{i} = ['v' n2s{n}]; i = i + 1; end
for n = 1:in_range.szpo, out_labels{i} = ['o' n2s{n}]; i = i + 1; end
end
