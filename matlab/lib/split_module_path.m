%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_directories, out_slash, out_filename, out_extension] = split_module_path(in_path)
level = find((in_path == '/') | (in_path == '\'));
lim = level(end);
dir = in_path(1:(lim - 1));
out_slash = in_path(lim);
fname = in_path((lim + 1):end);
dot = find(fname == '.');

out_directories = strsplit(dir, {'\', '/'});
for k = 1:numel(out_directories), out_directories{k} = [out_directories{k} out_slash]; end

if (isempty(dot)),
    out_filename = fname;
    out_extension = '';
else
    sep = dot(1);
    out_filename = fname(1:(sep - 1));
    out_extension = fname(sep:end);
end
end
