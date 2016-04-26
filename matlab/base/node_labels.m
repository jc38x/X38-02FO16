%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_labels] = node_labels(in_range)
out_labels = cell(1, in_range.sz);
n2s = strtrim(cellstr(num2str((1:max([in_range.szpi, in_range.szin, in_range.szpo])).')).');

out_labels(in_range.pi) = strcat('i', n2s(1:in_range.szpi));
out_labels(in_range.in) = strcat('v', n2s(1:in_range.szin));
out_labels(in_range.po) = strcat('o', n2s(1:in_range.szpo));
end
