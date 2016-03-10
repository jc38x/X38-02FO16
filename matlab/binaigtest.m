
[aigdelay, aiglabels, aigrange] = aig2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/i10.aig');
[aagdelay, aaglabels, aagrange] = aag2mat('C:/Users/jcds/Documents/GitHub/X38-02FO16/i10.aag');

s = sum(aigdelay > 0, 2);
f = find(s < 1);

aigolab = aiglabels(f).';

s = sum(aigdelay > 0, 1);
f = find(s < 1);

aigilab = aiglabels(f).';


s = sum(aagdelay > 0, 2);
f = find(s < 1);

aagolab = aaglabels(f).';

s = sum(aagdelay > 0, 1);
f = find(s < 1);

aagilab = aaglabels(f).';



%literal = num2str(next_sequence());
    %disp(['O ' literal]);
    %rh1 = 1;
%if (lhs <= rh0), disp('???'); end
    %if (rh0 < rh1), disp('???'); end
    
    %if (any(rh0 == [658, 702, 3162, 4278, 4724, 5192, 7124])), disp('???'); end
    %if (any(rh1 == [658, 702, 3162, 4278, 4724, 5192, 7124])), disp('???'); end
    
    %if (rh0 < 2), disp('rh0'); end
    %if (rh1 < 2), disp('rh1'); end
%num2str(fread(fid, 1))
%num2str(fread(fid, 1))
%num2str(fread(fid, 1))
%buffer = [];
%bufferpos = 0;

%out_seq = num2str(out_seq);

%out_delay = [];
%out_labels = [];
%out_range = [];

%fclose(fid);

%{
for k = 1:i
    signal = ['i' num2str(k) '_' num2str(input(k))];
    push_signal(signal);
end

for k = 1:l
    sk = num2str(k);
    signal = ['latch' sk 'i_' num2str(latch(k))];
    push_signal(signal);
    
end

for k = 1:o
    seq = next_sequence();
    
end

for k = 1:a
    seq = next_sequence();
    
end

    function push_signal(in_signal)
    end
%}

%;
    %if (seq < 2), disp(['O constante ' num2str(seq)]); end
    %if (seq < 2), disp(['AND I constante ' num2str(seq)]); end
%{
    function [out_ok] = read_next_block()
    if (feof(fid))
        out_ok = false;
        return;
    end
    data = fread(fid, blocksize, 'uint8');
    if (isempty(data))
        out_ok = false;
        return;
    end
    buffer = [buffer, data];
    out_ok = true;
    end
%}
       %{
        %if (isempty(buffer) && ~read_next_block()), error('EOF'); end
        
        
        if (~isempty(buffer))
            for b = buffer(bufferpos:end)
            end
            
        end
        
        
        while (~feof(fid))
            
        end
        %}
