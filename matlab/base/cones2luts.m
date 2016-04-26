%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_luts] = cones2luts(in_delay, in_labels, in_range, in_equations)
out_luts = cell(1, in_range.sz);
out_luts(in_range.top) = in_equations(in_range.top);

for k = in_range.in
    signals = strcat('[', in_labels(get_inode(in_delay, k)), ']');
    ns = numel(signals);
    if (ns < 1), continue; end

    equation = in_equations{k};
    inputs = tt_inputs(ns);
    ni = size(inputs, 2);
    outputs = zeros(1, ni);

    for outi = 1:ni
        tteqn = equation;
        for ini = 1:ns, tteqn = strrep(tteqn, signals{ini}, num2str(inputs(ini, outi))); end
        outputs(outi) = eval(tteqn);
    end

    if (ni >= 4)
        outputs = reshape(outputs, [4, ni / 4]);
        outputs(1, :) = outputs(1, :) * 8;
        outputs(2, :) = outputs(2, :) * 4;
        outputs(3, :) = outputs(3, :) * 2;
    else
        outputs = reshape(outputs, [2, 1]);
        outputs(1, :) = outputs(1, :) * 2;
    end
    
    signals = strcat(signals, ',');
    out_luts{k} = ['lut(' strcat(signals{:}) '''' strremovespaces(num2str(sum(outputs, 1), '%X')) ''')'];
end
end
