%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_stdout] = invoke_abc(in_script)
[dirs, sl] = split_module_path(mfilename('fullpath'));
workdir = [[dirs{1:(end-2)}] 'tools' sl 'abc' sl];
stdout = extract(spawn_process([workdir 'abc.exe'], '', workdir, in_script));

ns = numel(stdout);
response = C_vector(ns);
j = 0;

for k = 1:ns
    line = stdout{k};
    [sidx, endindex] = regexp(line, 'abc \d+\>');
    
    startindex = [sidx, numel(line) + 1];
    statement = line(1:(startindex(1) - 1));
    ne = numel(endindex);
    text = C_vector((2 * ne) + 1);

    if (~isempty(statement)), text.push(statement); end

    for i = 1:ne
        matchstop = endindex(i) + 2;
        statement = line((matchstop + 1):(startindex(i + 1) - 1));
        j = j + 1;
        text.push([line(startindex(i):matchstop) in_script{j}]);
        if (~isempty(statement)), text.push(statement); end
    end
    
    response.push(text.extract());
end

out_stdout = cell_collapse(response.extract());
end
