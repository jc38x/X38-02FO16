
function [out_labels, out_equations] = make_instance(in_name, in_labels, in_range, in_equations)
out_labels = cell(1, in_range.sz);
out_equations = cell(1, in_range.sz);
out_equations([in_range.pi, in_range.po]) = {''};

translatemap = containers.Map();



for k = in_range.all
    label = in_labels{k};
    newlabel = [in_name ',' label];
    out_labels{k} = newlabel;
    translatemap(label) = newlabel;
end



for k = in_range.in
    equation = in_equations{k};
    signals = regexprep(unique(regexp(equation, '\[\w+\]', 'match')), '[\[\]]', '');
    for s = 1:numel(signals)
        signal = signals{s};
        equation = regexprep(equation, signal, translatemap(signal));
    end
    out_equations{k} = equation;
end




    %signals
        %if (translatemap.isKey(signal))
        %end
end
