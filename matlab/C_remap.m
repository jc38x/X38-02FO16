
classdef (Sealed = true) C_remap
    properties (SetAccess = immutable, GetAccess = private)
        m_map;
    end
    
    methods
        function [out_obj] = C_remap(in_keys, in_values)
            out_obj.m_map = containers.Map(num2cell(in_keys), num2cell(in_values));
        end
        
        function [out_values] = remap(in_obj, in_keys)
            out_values = cell2mat(in_obj.m_map.values(num2cell(in_keys)));
        end
    end
end
