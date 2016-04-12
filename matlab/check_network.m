
function check_network(in_delay, in_range, in_equations)

if (any(sum(in_delay(:, in_range.pi), 1) > 0))
    warning('Some PI have inodes');
end

if (~all(sum(in_delay(in_range.pi, :), 2) > 0))
    warning('Some PI are unconnected');
end

if (~all(sum(in_delay(in_range.in, :), 2) > 0))
    warning('Some IN have no onodes');
end

if (~all(sum(in_delay(:, in_range.in), 1) > 0))
    warning('Some IN have no inodes');
end

if (any(sum(in_delay(in_range.po, :), 2) > 0))
    warning('Some PO have onodes');
end

if (~all(sum(in_delay(:, in_range.po), 1) > 0))
    warning('Some PO are unconnected');
end

if (any(strcmpi('0', in_equations(in_range.in))))
    warning('Network has constant 0');
end

if (any(strcmpi('1', in_equations(in_range.in))))
    warning('Network has constant 1');
end

if (any(sum(in_delay(in_range.pi, in_range.po), 1) > 0))
    warning('Direct paths from PI to PO');
end


disp('END CHECK');


end
