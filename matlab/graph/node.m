
classdef node < element
    properties
        interface
        instance
        m_type
    end
    methods
        function out_obj = node(in_type, in_interface, in_instance)
            m_type = in_type;
        end
        
    end    
end
