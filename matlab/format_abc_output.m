
function [out_stdout] = format_abc_output(in_script, in_stdout)
nj = numel(in_script);
ns = numel(in_stdout);
response = cell(1, ns);
index = 0;
j = 0;

for k = 1:ns
    line = in_stdout{k};
    [sidx, endindex] = regexp(line, 'abc \d+\>');
    
    startindex = [sidx, numel(line) + 1];
    statement = line(1:(startindex(1) - 1));
    ne = numel(endindex);
    
    text = cell(1, (2 * ne) + 1);
    subindex = 0;

    if (~isempty(statement)), push_line(statement); end

    for i = 1:ne
        matchstop = endindex(i) + 2;
        statement = line((matchstop + 1):(startindex(i + 1) - 1));
        j = j + 1;
        if (j <= nj), push_line([line(startindex(i):matchstop) in_script{j}]); end
        if (~isempty(statement)), push_line(statement); end
    end
    
    index = index + 1;
    response{index} = text(1:subindex);
end

out_stdout = cell_collapse(response(1:index));

    function push_line(in_line)
    subindex = subindex + 1;
    text{subindex} = in_line;
    end
end
