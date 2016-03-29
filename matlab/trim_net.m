
function [out_delay, out_labels, out_range, out_equations] = trim_net(in_delay, in_labels, in_range, in_equations)

signal2uid = containers.Map();

order = graphtoporder(in_delay);
order = order(is_in(order, in_range));



for k = order
end





end
