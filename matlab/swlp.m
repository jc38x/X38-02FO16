

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
