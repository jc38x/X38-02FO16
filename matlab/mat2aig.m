
function [ output_args ] = mat2aig(in_delay, in_labels, in_range, in_equations)


order = graphtopoorder(in_delay);
inorder = order(is_in(order, in_range));
signal2literal = containers.Map();
literal = 0;

i = in_range.szpi;
l = 0;
o = in_range.szpo;

for k = in_range.pi
    literal = literal + 2;
    signal = ['[' in_labels{k} ']'];    
    signal2literal(signal) = literal;
    signal2literal(['not(' signal ')']) = literal + 1;
end

for k = inorder
    equation = in_equations{k};
    signals = [];
    
    
    
    
end








end
