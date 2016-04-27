%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations, out_filename] = load_lgsynth93(in_name)
[dirs, sl] = split_module_path(mfilename('fullpath'));
base = [dirs{1:(end-2)}];
out_filename = [base 'benchmarks' sl 'LGSynth93' sl 'testcases' sl in_name '.blif'];
if (exist(out_filename, 'file') ~= 2), error(['File ' out_filename ' not found.']); end
tmp = [base 'workspace' sl 'tmp_lgsynth93_blif2aig_abc.aig'];
invoke_abc({['read_blif ' out_filename]; 'comb'; 'strash'; ['write_aiger -s ' tmp]; 'quit'});
[out_delay, out_labels, out_range, out_equations] = aiger2mat(tmp);
end
