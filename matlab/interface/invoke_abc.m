%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_stdout] = invoke_abc(in_script)
[path, sl] = get_tools_path();
workdir = [path 'abc' sl];
out_stdout = spawn_process([workdir 'abc.exe'], '', workdir, in_script);
end
