%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function stdout_callback_abc(~, event, cmdfifo)
line = char(event.Data);
[startindex, endindex] = regexp(line, 'abc \d+\>');
startindex = [startindex, numel(line) + 1];
statement = line(1:(startindex(1) - 1));

if (~isempty(statement)), fprintf('%s\n', statement); end

for i = 1:numel(endindex)
    matchstop = endindex(i) + 2;
    response = line((matchstop + 1):(startindex(i + 1) - 1));
    fprintf('%s\n', [line(startindex(i):matchstop) cmdfifo.next()]);
    if (~isempty(response)), fprintf('%s\n', response); end
end
end
