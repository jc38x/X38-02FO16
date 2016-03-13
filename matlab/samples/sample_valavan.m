%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************
% References
% 10.1109/TCAD.2006.882119
%**************************************************************************

function [out_delay, out_labels, out_range] = sample_valavan()
npi = 6;
nin = 6;
npo = 2;

nodos = npi + nin + npo;
out_delay = sparse(nodos, nodos);
id = 1;

i = zeros(1, npi);
v = zeros(1, nin);
o = zeros(1, npo);

for n = 1:npi, i(n) = id; id = id + 1; end
for n = 1:nin, v(n) = id; id = id + 1; end
for n = 1:npo, o(n) = id; id = id + 1; end

out_delay(i(1), v(5)) = 4;
out_delay(i(2), v(3)) = 2;
out_delay(i(3), v(1)) = 1;
out_delay(i(4), v(1)) = 1;
out_delay(i(5), v(2)) = 1;
out_delay(i(6), v(2)) = 1;

out_delay(v(5), v(6)) = 1;
out_delay(v(3), v(5)) = 1;
out_delay(v(3), v(6)) = 2;
out_delay(v(1), v(3)) = 1;
out_delay(v(1), v(4)) = 2;
out_delay(v(2), v(4)) = 3;

out_delay(v(6), o(1)) = 1;
out_delay(v(4), o(2)) = 1;

out_range = prepare_range(i(1), i(6), v(1), v(6), o(1), o(2));
out_labels = node_labels(out_range);
end
