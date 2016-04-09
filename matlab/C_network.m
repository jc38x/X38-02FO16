
classdef C_network < handle
    properties (SetAccess = immutable, GetAccess = public)
        m_delay
        %m_labels
        m_range
        %m_equations
        m_inode;
        m_setinode;
        m_onode;
        m_setonode;
        m_order;
        m_setorder;
        m_inorder;
        m_setinorder;
    end
    
    methods
        function [out_obj] = C_network(in_delay, in_range)%, in_labels, in_range, in_equations)
        out_obj.m_delay = in_delay;
        %out_obj.m_labels = in_labels;
        out_obj.m_range = in_range;
        %out_obj.m_equations = in_equations;
        
        out_obj.m_inode = cell(1, in_range.sz);
        out_obj.m_setinode = false(1, in_range.sz);
        out_obj.m_onode = cell(1, in_range.sz);
        out_obj.m_setonode = false(1, in_range.sz);
        out_obj.m_order = [];
        out_obj.m_setorder = false;
        out_obj.m_inorder = [];
        out_obj.m_setinorder = false;
        end
        
        function [out_order] = order(in_obj)
        if (~in_obj.m_setorder)
            in_obj.m_order = graphtopoorder(in_obj.m_delay);
            in_obj.m_setorder = true;
        end
        out_order = in_obj.m_order;
        end
        
        function [out_inorder] = inorder(in_obj)
        if (~in_obj.m_setinorder)
            order = in_obj.order();
            in_obj.m_inorder = order(is_in(order, in_obj.m_range));
            in_obj.m_setinorder = true;
        end
        out_inorder = in_obj.m_inorder;
        end
        
        function [out_inode] = inode(in_obj, in_node)
        if (~in_obj.m_setinode(in_node))
            in_obj.m_inode{in_node} = find(in_obj.m_delay(:, in_node).');
            in_obj.m_setinode(in_node) = true;
        end
        out_inode = in_obj.m_inode{in_node};
        end
        
        function [out_onode] = onode(in_obj, in_node)
        if (~in_obj.m_setonode(in_node))
            in_obj.m_onode{in_node} = find(in_obj.m_delay(in_node, :));
            in_obj.m_setonode(in_node) = true;
        end
        out_onode = in_obj.m_onode{in_node};
        end
        
        
        
    end
    
end
