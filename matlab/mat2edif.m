
function mat2edif(in_filename, in_delay, in_labels, in_range, in_luts)
fid = fopen(in_filename, 'w');
if (fid == -1), error(['Failed to open file ' in_filename '.']); end

ts = strsplitntrim(datestr(now, 'yyyy mm dd HH MM SS'), ' ');
year = ts{1};
month = removelz(ts{2});
day = removelz(ts{3});
hour = removelz(ts{4});
minute = removelz(ts{5});
second = removelz(ts{6});


headerbegin = [
    {0, '(edif top'};
    {1, '(edifVersion 2 0 0)'};
    {1, '(edifLevel 0)'};
    {1, '(keywordMap (keywordLevel 0))'};
    {1, '(status'};
    {2, '(written'};
    {3, ['(timeStamp ' year ' ' month ' ' day ' ' hour ' ' minute ' ' second ')']};
    {3, '(author "author")'};
    {3, '(program "matlab")'};
    {2, ')'};
    {1, ')'}
    {1, '(external UNISIMS'};
    {2, '(edifLevel 0)'};
    {2, '(technology (numberDefinition))'};
    ];
    
lut4cell = [
    {2, '(cell LUT4'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface '};
    {6, '(port I0'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I1'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I2'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port I3'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};    
    ];

ibufcell = [
    {2, '(cell IBUF'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface'};
    {6, '(port I'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};
    ];

obufcell = [
    {2, '(cell OBUF'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface'};
    {6, '(port I'};
    {7, '(direction INPUT)'};
    {6, ')'};
    {6, '(port O'};
    {7, '(direction OUTPUT)'};
    {6, ')'};
    {5, ')'};
    {4, ')'};
    {2, ')'};
    ];

headerstop = [
    {1, ')'};
    ];

librarybegin = [
    {1, '(library top_lib'};
    {2, '(edifLevel 0)'};
    {2, '(technology (numberDefinition))'};
    {2, '(cell top'};
    {3, '(cellType GENERIC)'};
    {4, '(view view_1'};
    {5, '(viewType NETLIST)'};
    {5, '(interface'};
    ];


designator = [
    {6, '(designator "xc3s700a-4-fg484")'};
    {6, '(property TYPE (string "top") (owner "Xilinx"))'};
    {6, '(property NLW_UNIQUE_ID (integer 0) (owner "Xilinx"))'};
    {6, '(property NLW_MACRO_TAG (integer 0) (owner "Xilinx"))'};
    {6, '(property NLW_MACRO_ALIAS (string "top_top") (owner "Xilinx"))'};
    {5, ')'};
    {5, '(contents'};
    ];

librarystop = [
    {5, ')'};
    {4, ')'};
    {2, ')'};
    {1, ')'};
    ];

design = [
    {1, '(design top'};
    {2, '(cellRef top'};
    {3, '(libraryRef top_lib)'};
    {2, ')'};
    {2, '(property PART (string "xc3s700a-4-fg484") (owner "Xilinx"))'};
    {1, ')'};
    {0, ')'};
    ];

write_block(headerbegin);
write_block(lut4cell);
write_block(ibufcell);
write_block(obufcell);
write_block(headerstop);
write_block(librarybegin);

%top i/o
for k = in_range.pi
    fprintf(fid, [indent(6) '(port ' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(direction INPUT)\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.po
    fprintf(fid, [indent(6) '(port ' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(direction OUTPUT)\n']);
    fprintf(fid, [indent(6) ')\n']);
end

write_block(designator);

%instances
for k = in_range.in
    fprintf(fid, [indent(6) '(instance ' in_labels{k} '_LUT4\n']);
    fprintf(fid, [indent(7) '(viewRef view_1 (cellRef LUT4 (libraryRef UNISIMS)))\n']);
    fprintf(fid, [indent(7) '(property XSTLIB (boolean (true)) (owner "Xilinx"))\n']);
    fprintf(fid, [indent(7) '(property INIT (string "' in_luts{k - in_range.pihi} '") (owner "Xilinx"))\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.pi
    fprintf(fid, [indent(6) '(instance ' in_labels{k} '_IBUF\n']);
    fprintf(fid, [indent(7) '(viewRef view_1 (cellRef IBUF (libraryRef UNISIMS)))\n']);
    fprintf(fid, [indent(7) '(property XSTLIB (boolean (true)) (owner "Xilinx"))\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.po
    fprintf(fid, [indent(6) '(instance ' in_labels{k} '_OBUF\n']);
    fprintf(fid, [indent(7) '(viewRef view_1 (cellRef OBUF (libraryRef UNISIMS)))\n']);
    fprintf(fid, [indent(7) '(property XSTLIB (boolean (true)) (owner "Xilinx"))\n']);
    fprintf(fid, [indent(6) ')\n']);
end

% and nets
for k = in_range.pi
    fprintf(fid, [indent(6) '(net N_' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(joined\n']);
    fprintf(fid, [indent(8) '(portRef ' in_labels{k} ')\n']);
    fprintf(fid, [indent(8) '(portRef I (instanceRef ' in_labels{k} '_IBUF))\n']);
    fprintf(fid, [indent(7) ')\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.po
    fprintf(fid, [indent(6) '(net N_' in_labels{k} '\n']);
    fprintf(fid, [indent(7) '(joined\n']);
    fprintf(fid, [indent(8) '(portRef ' in_labels{k} ')\n']);
    fprintf(fid, [indent(8) '(portRef O (instanceRef ' in_labels{k} '_OBUF))\n']);
    fprintf(fid, [indent(7) ')\n']);
    fprintf(fid, [indent(6) ')\n']);
end

for k = in_range.in
end




write_block(librarystop);
write_block(design);

fclose(fid);





%{
fprintf(fid, '(edif top\n');
indent(1);
fprintf(fid, '(edifVersion 2 0 0)\n');
indent(1);
fprintf(fid, '(edifLevel 0)\n');
indent(1);
fprintf(fid, '(keywordMap (keywordLevel 0))\n');
indent(1);
fprintf(fid, '(status\n');
indent(2);
fprintf(fid, '(written\n');
indent(3);
fprintf(fid, '(timeStamp '
%}
    function write_block(in_block)
        for c = in_block.'
            fprintf(fid, [indent(c{1}) c{2} '\n']);
        end
    end


    function [out_ws] = indent(in_level)
        out_ws = repmat('  ', 1, in_level);
    %if (in_level <= 0), return; end
    %fprintf(fid, repmat('    ', 1, in_level));
    end

    function [out_str] = removelz(in_str)
    if (in_str(1) == '0'), out_str = in_str(2); else out_str = in_str; end
    end


end
