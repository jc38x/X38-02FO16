
function check_network(in_delay, in_labels, in_range, in_equations)
if (isempty(in_range.pi)),                                warning('Network has no PI.');          end
if (isempty(in_range.in)),                                warning('Network has no IN.');          end
if (isempty(in_range.po)),                                warning('Network has no PO.');          end

if ( any(sum(in_delay(:, in_range.pi), 1) > 0)),          warning('Some PI have inodes.');        end
if (~all(sum(in_delay(in_range.pi, :), 2) > 0)),          warning('Some PI are unconnected.');    end

if (~all(sum(in_delay(in_range.in, :), 2) > 0)),          warning('Some IN have no onodes.');     end
if (~all(sum(in_delay(:, in_range.in), 1) > 0)),          warning('Some IN have no inodes.');     end

if ( any(sum(in_delay(in_range.po, :), 2) > 0)),          warning('Some PO have onodes.');        end
if (~all(sum(in_delay(:, in_range.po), 1) > 0)),          warning('Some PO are unconnected.');    end

if (any(strcmpi('0', in_equations(in_range.in)))),        warning('Network has constant 0.');     end
if (any(strcmpi('1', in_equations(in_range.in)))),        warning('Network has constant 1.');     end

if (~graphisdag(in_delay)),                               warning('Network is not a DAG.');       end
if (any(diag(in_delay) > 0)),                             warning('Network has self-loops.');     end
if (any(sum(in_delay(in_range.pi, in_range.po), 1) > 0)), warning('Direct paths from PI to PO.'); end
if (numel(unique(in_labels)) ~= numel(in_labels)),        warning('Duplicated labels.');          end

disp('Network check completed.');
end
