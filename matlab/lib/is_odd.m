%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://www.mathworks.com/matlabcentral/answers/178217-is-there-built-in-function-such-as-iseven-isint-and-factorial-in-matlab
%**************************************************************************

function [out_isit] = is_odd(in_n)
out_isit = mod(in_n, 2) == 1;
end
