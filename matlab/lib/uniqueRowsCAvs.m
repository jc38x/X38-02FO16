%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_ca] = uniqueRowsCAvs(in_ca)
nca = numel(in_ca);
nc = zeros(1, nca);
out_ca = cell(nca, 1);
index = 0;

for n = 1:nca, nc(n) = numel(in_ca{n}); end

for n = unique(nc)
    c = uniqueRowsCA(in_ca(nc == n));
    ntc = numel(c);
    out_ca((1:ntc) + index) = c;
    index = index + ntc;
end

out_ca = out_ca(1:index);
end
