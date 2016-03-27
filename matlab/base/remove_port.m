%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_delay, out_labels, out_range, out_equations] = remove_port(in_delay, in_labels, in_range, in_equations, in_port)
out_delay = in_delay;
out_labels = in_labels;
out_equations = in_equations;

out_delay(in_port, :) = [];
out_delay(:, in_port) = [];
out_labels(in_port) = [];
out_equations(in_port) = [];

npi = in_range.szpi - sum(is_pi(in_port, in_range));
npo = in_range.szpo - sum(is_po(in_port, in_range));

out_range = prepare_range(npi, in_range.szin, npo);
end
