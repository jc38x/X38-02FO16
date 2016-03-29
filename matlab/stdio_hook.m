
% http://www.mathworks.com/matlabcentral/answers/72356-using-matlab-to-send-strings-to-the-stdin-of-another-console-application

function stdio_hook(in_path, in_cmdshow, in_script, in_stdocallback)


process = System.Diagnostics.Process;

process.StartInfo.FileName = in_path;
process.EnableRaisingEvents = true;
process.StartInfo.CreateNoWindow = in_cmdshow;
process.StartInfo.UseShellExecute = false;
process.StartInfo.RedirectStandardOutput = true;

process.addlistener('OutputDataReceived', in_stdocallback);

process.StartInfo.RedirectStandardInput = true;
process.Start();

stdin = process.StandardInput;
process.BeginOutputReadLine();

for k = 1:size(in_script, 1)
    stdin.WriteLine(in_script{k});
end


stdin.Close();
process.WaitForExit();
process.Close();
end
