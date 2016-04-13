%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function invoke_abc(in_script)
this = mfilename('fullpath');
level = find((this == '/') | (this == '\'));
path = this(1:level(end - 2));
slash = path(end);
workdir = [path 'tools' slash 'abc' slash];
path = [workdir 'abc.exe'];

spawn_process(path, '', workdir, false, in_script, @(obj, event)stdout_callback_abc(obj, event, C_cmdfifo(in_script)));
end
