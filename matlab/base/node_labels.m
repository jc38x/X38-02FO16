%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_labels] = node_labels(in_range)
out_labels = cell(1, in_range.sz);
m = max([in_range.szpi, in_range.szin, in_range.szpo]);
n2s = cell(1, m);
i = 0;

for n = 1:m, n2s{n} = num2str(n); end
for n = 1:in_range.szpi, i = i + 1; out_labels{i} = ['i' n2s{n}]; end
for n = 1:in_range.szin, i = i + 1; out_labels{i} = ['v' n2s{n}]; end
for n = 1:in_range.szpo, i = i + 1; out_labels{i} = ['o' n2s{n}]; end
end
