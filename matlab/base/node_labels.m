%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_labels] = node_labels(in_range)
m = max([in_range.szpi, in_range.szin, in_range.szpo]);
n2s = cell(1, m);
out_labels = cell(1, in_range.sz);
i = 0;

for n = 1:m, n2s{n} = num2str(n); end
for n = 1:in_range.szpi, add_label('i', n); end
for n = 1:in_range.szin, add_label('v', n); end
for n = 1:in_range.szpo, add_label('o', n); end

    function add_label(in_prefix, in_n)
    i = i + 1;
    out_labels{i} = [in_prefix n2s{in_n}];
    end
end
