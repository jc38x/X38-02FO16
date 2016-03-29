
function stdo_callback_echo(obj, event)
disp('echo');
if (~isempty(event.Data)), disp(event.Data); end
end
