
cones = cell(1, 5);

a = cell(1, 2);
b = cell(1, 3);
c = cell(1, 1);
d = cell(1, 4);
e = cell(1, 5);

a{2} = 'a';
b{3} = 'b';
c{1} = 'c';
d{4} = 'd';
e{5} = 'e';

cones{1} = a;
cones{2} = b;
cones{3} = c;
cones{4} = d;
cones{5} = e;



col = cell_collapse(cones([2,4,5]));



%cones = {{[1,2,3], [5,6], [7], [8,9,10,11]}, {[1,2,3], [5,6], [7], [8,9,10,11]}, {[1,2,3], [5,6], [7], [8,9,10,11]}};



%{
    function [out_byte] = next_byte()
    if (feof(fid)), error_handler('Unexpected EOF.'); end
    out_byte = fread(fid, 1, 'uint8');
    if (isempty(out_byte)), error_handler('File read failed.'); end
    end
%}


%{
    function [out_seq] = next_sequence()
    data = next_byte();
    out_seq = bitand(data, 127);
    p = 1;
    while (bitand(data, 128))
        data = next_byte();
        out_seq = out_seq + (bitand(data, 127) * (2 ^ (7 * p)));
        p = p + 1;
    end
    end
%}


%{
i = 0;

while (true)
    i = i + 1;
    switch (i)
        case 0, disp('Imposible');
        case 1, disp('Inicio');
        case 2, disp('...');
        case 3, disp('Final');
        case 4, disp('Break'); break;
        otherwise disp('Ctrl + C');
    end
    
end
%}
