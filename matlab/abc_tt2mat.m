%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = abc_tt2mat(in_tthex, in_inputs)

if (in_inputs == 1 && strcmpi(in_tthex, '2'))
    disp('route-thru');
    out_delay = sparse([1, 2], [2, 3], 1, 3, 3);
    out_labels = {'i0', 'and_2', 'o'};
    out_range = prepare_range(1, 1, 1);
    out_equations = [{''}, {'and([i0],[i0])'}, {''}]; 
    return;
end



filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/abc_tt.aig';
invoke_abc({['read_truth ' in_tthex]; 'strash'; 'refactor'; 'refactor'; 'refactor'; ['write_aiger -s ' filename]; 'quit'});
[out_delay, out_labels, out_range, out_equations] = aiger2mat(filename);

if (out_range.szin < 1)
end


newnames = cell(1, out_range.szpi + out_range.szpo);
for k = 1:out_range.szpi, newnames{k} = ['i' num2str(k - 1)]; end
newnames(end) = {'o'};

[out_labels, out_equations] = rename_node(out_delay, out_labels, out_equations, [out_range.pi, out_range.po], newnames);



end
