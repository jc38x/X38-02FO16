%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

classdef (Sealed = true) C_cmdfifo < handle
    properties (Access = private)
        m_cmd;
    end
    
    methods
        function [out_obj] = C_cmdfifo(in_cmdlist)
        out_obj.m_cmd = in_cmdlist;
        end
        
        function [out_next] = next(in_obj)
        if (isempty(in_obj.m_cmd))
            out_next = [];
        else
            out_next = in_obj.m_cmd{1};
            in_obj.m_cmd(1) = [];
        end
        end
    end    
end
