
function [out_equation] = get_aig_equations(in_iedge, in_labels, in_range)
out_equation = cell(1, in_range.sz);
k = in_range.pi;
out_equation(k) = {''};%in_labels(k);
k = in_range.po;
out_equation(k) = {''};

for k = in_range.in
    label = in_labels{k};
    ie = in_iedge{k};
    switch (label(1:3))
        case 'and', out_equation{k} = ['[' in_labels{ie(1, 1)} ']' ' & '  '[' in_labels{ie(1, 2)} ']'];
        case 'inv', out_equation{k} = ['~[' in_labels{ie(1, 1)} ']'];
        otherwise,  error(['Unexpected label ' label '.']);
    end
end
end
