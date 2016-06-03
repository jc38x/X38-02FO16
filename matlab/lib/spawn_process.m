%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://www.mathworks.com/matlabcentral/answers/72356-using-matlab-to-send-strings-to-the-stdin-of-another-console-application
% https://msdn.microsoft.com/en-us/library/system.diagnostics.process
%**************************************************************************

function [out_stdout] = spawn_process(in_path, in_cmdline, in_wd, in_stdinscript)
persistent s_lh

out_stdout = [];

process = System.Diagnostics.Process;

process.EnableRaisingEvents = true;

process.StartInfo.UseShellExecute = false;
process.StartInfo.RedirectStandardInput = true;
process.StartInfo.RedirectStandardOutput = true;

process.StartInfo.FileName = in_path;
process.StartInfo.Arguments = in_cmdline;
process.StartInfo.WorkingDirectory = in_wd;
process.StartInfo.CreateNoWindow = true;

s_lh = process.addlistener('OutputDataReceived', @stdout_capture);
if (isempty(s_lh)), end

process.Start();
process.BeginOutputReadLine();

stdin = process.StandardInput;
for l = 1:numel(in_stdinscript), stdin.WriteLine(in_stdinscript{l}); end
stdin.Close();

process.WaitForExit();
process.Close();

    function stdout_capture(~, event)        
    out_stdout = [out_stdout, {char(event.Data)}];
    end
end
