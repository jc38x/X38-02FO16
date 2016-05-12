%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

classdef (Sealed = true) C_remap
properties (SetAccess = immutable, GetAccess = private)
    m_map;
end

methods
    function [out_obj] = C_remap(in_keys, in_values)
    out_obj.m_map(in_keys) = in_values;
    end

    function [out_values] = remap(in_obj, in_keys)
    out_values = in_obj.m_map(in_keys);
    end
end
end
