
classdef C_vector < handle
properties (Access = private)
    m_cell;
    m_index;
end
methods
    function [out_obj] = C_vector(in_reserve)
    out_obj.m_cell = cell(1, in_reserve);
    out_obj.m_index = 0;
    end
    
    function push(in_obj, in_data)
    in_obj.m_index = in_obj.m_index + 1;
    in_obj.m_cell(in_obj.m_index) = {in_data};
    end
    
    function [out_data] = extract(in_obj)
    out_data = in_obj.m_cell(1:in_obj.m_index);
    end
end
end
