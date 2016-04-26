%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_bit] = lut(varargin)
bits = 1:(nargin - 1);
index = sum(cell_collapse(varargin(bits)) .* (2 .^ (bits - 1))) + 1;
tt = hexToBinaryVector(varargin{nargin}, [], 'LSBFirst');
if (index > numel(tt)), out_bit = 0; else out_bit = tt(index); end
end
