%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_path, out_sl] = get_workspace_path()
[dirs, out_sl] = split_module_path(mfilename('fullpath'));
out_path = [[dirs{1:(end-2)}] 'workspace' out_sl];
end
