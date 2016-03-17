%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_luts, out_inputs] = cones2luts(in_range, in_equations)
out_luts = cell(1, in_range.szin);
out_inputs = cell(1, in_range.szin);

for k = in_range.in
    equation = in_equations{k};
    signals = unique(regexp(equation, '\[\w+\]', 'match'));
    ns = numel(signals);
    inputs = num2cell(repmat([1, 0], ns, 1), 2);
    inputs = combvec(inputs{:});
    ni = size(inputs, 2);
    outputs = zeros(1, ni);
    
    for outi = 1:ni
        eveqn = equation;
        for ini = 1:ns, eveqn = strrep(eveqn, signals{ini}, num2str(inputs(ini, outi))); end
        outputs(outi) = eval(eveqn);
    end
    
    if (ni < 4)
        outputs = reshape(outputs, [2, 1]);
        outputs(1, :) = outputs(1, :) * 2;
    else
        outputs = reshape(outputs, [4, ni / 4]);
        outputs(1, :) = outputs(1, :) * 8;
        outputs(2, :) = outputs(2, :) * 4;
        outputs(3, :) = outputs(3, :) * 2;
    end
    
    index = k - in_range.pihi;
    out_luts{index} = strremovespaces(num2str(sum(outputs, 1), '%X'));
    out_inputs{index} = regexprep(signals, '[\[\]]', '');
end
end