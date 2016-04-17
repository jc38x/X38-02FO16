%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function invoke_abc(in_script)
[dirs, sl] = split_module_path(mfilename('fullpath'));
workdir = [[dirs{1:(end-2)}] 'tools' sl 'abc' sl];
spawn_process([workdir 'abc.exe'], '', workdir, false, in_script, @(obj, event)stdout_callback_abc(obj, event, C_cmdfifo(in_script)));
end
