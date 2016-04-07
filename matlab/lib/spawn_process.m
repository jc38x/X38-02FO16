%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://www.mathworks.com/matlabcentral/answers/72356-using-matlab-to-send-strings-to-the-stdin-of-another-console-application
% https://msdn.microsoft.com/en-us/library/system.diagnostics.process
%**************************************************************************

function spawn_process(in_path, in_cmdline, in_wd, in_cmdshow, in_stdinscript, in_stdoutcallback)
persistent s_lh

process = System.Diagnostics.Process;

process.EnableRaisingEvents = true;

process.StartInfo.UseShellExecute = false;
process.StartInfo.RedirectStandardInput = true;
process.StartInfo.RedirectStandardOutput = true;

process.StartInfo.FileName = in_path;
process.StartInfo.Arguments = in_cmdline;
process.StartInfo.WorkingDirectory = in_wd;
process.StartInfo.CreateNoWindow = in_cmdshow;

s_lh = process.addlistener('OutputDataReceived', in_stdoutcallback);
if (isempty(s_lh)), end

process.Start();
process.BeginOutputReadLine();

stdin = process.StandardInput;
for line = in_stdinscript.', stdin.WriteLine([line{:}]); end
stdin.Close();

process.WaitForExit();
process.Close();
end
