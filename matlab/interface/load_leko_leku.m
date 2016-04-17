%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = load_leko_leku(in_name)
[dirs, sl] = split_module_path(mfilename('fullpath'));
base = [dirs{1:(end-2)}];
path = [base 'benchmarks' sl 'LEKO_LEKU' sl in_name '.blif'];
if (exist(path, 'file') ~= 2), error(['File ' path ' not found.']); end
tmp = [base 'workspace' sl 'tmp_lek__blif2aig_abc.aig'];
invoke_abc({['read_blif ' path ';']; 'strash'; ['write_aiger -s ' tmp ';']; 'quit'}, false);
[out_delay, out_labels, out_range, out_equations] = aiger2mat(tmp);
end
