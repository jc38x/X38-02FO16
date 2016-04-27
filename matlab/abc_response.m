%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function abc_response(in_response, in_script)

class(in_response)
z = 1;

%while (in_cmdfifo.has_next())
    for k = 1:numel(in_response)
    
line = in_response{k};%in_cmdfifo.next();%char(event.Data);
[startindex, endindex] = regexp(line, 'abc \d+\>');
startindex = [startindex, numel(line) + 1];
statement = line(1:(startindex(1) - 1));

if (~isempty(statement)), fprintf('%s\n', statement); end

for i = 1:numel(endindex)
    matchstop = endindex(i) + 2;
    response = line((matchstop + 1):(startindex(i + 1) - 1));
    fprintf('%s\n', [line(startindex(i):matchstop) in_script{z}]);
    z = z + 1;
    if (~isempty(response)), fprintf('%s\n', response); end
end

end
end
