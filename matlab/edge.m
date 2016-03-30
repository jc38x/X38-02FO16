
classdef edge < element
    properties
        m_inode
        m_onode
        m_delay
    end
    methods
        function out_obj = edge(in_inode, in_onode, in_delay)
            out_obj.m_inode = in_inode;
            out_obj.m_onode = in_onode;
            out_obj.m_delay = in_delay;
            
            in_inode.push_oedge(out_obj);
            in_onode.push_iedge(out_obj);
        end
        
    end
end
