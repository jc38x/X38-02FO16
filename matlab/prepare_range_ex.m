
function [out_range] = prepare_range_ex(in_delay, in_range)
out_range = in_range;
out_range.order = graphtopoorder(in_delay);
out_range.inorder = out_range.order(is_in(out_range.order, out_range));

[~, ~, inode, onode] = prepare_edges(in_delay, out_range);
out_range.inode = inode;
out_range.onode = onode;
end
