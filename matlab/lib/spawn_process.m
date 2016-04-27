%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% http://www.mathworks.com/matlabcentral/answers/72356-using-matlab-to-send-strings-to-the-stdin-of-another-console-application
% https://msdn.microsoft.com/en-us/library/system.diagnostics.process
%**************************************************************************

function [out_stdout, s_lh] = spawn_process(in_path, in_cmdline, in_wd, in_stdinscript)
%persistent s_lh
%persistent stdoutresponse

%out_stdoutresponse = C_cmdfifo([]);
out_stdout = C_vector(64);
%out_stdoutresponse = [];
%stdoutresponse = [];

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
%fieldnames(s_lh)%class(s_lh)
if (isempty(s_lh)), end

process.Start();
process.BeginOutputReadLine();

stdin = process.StandardInput;
for l = 1:numel(in_stdinscript), stdin.WriteLine(in_stdinscript{l}); end
stdin.Close();



process.WaitForExit();

%disp('EXIT');

%process.StandardOutput.Close();

%celldisp(stdoutresponse);
%process.HasExited()

process.Close();

pause(1);

%s_lh.Source
%dbstack(0)


%refresh
%dbstack(0)

    function stdout_capture(obj, event)
        %disp('CALLBACK');
    %class(obj)
    %class(event)
    %stdoutresponse = [stdoutresponse; {char(event.Data)}];
    %celldisp(out_stdoutresponse);
    %disp(char(event.Data));
    out_stdout.push(char(event.Data));
    end
end
