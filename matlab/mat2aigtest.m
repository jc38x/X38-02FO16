
[delay, labels, range, equations] = tt2mat('0090');
[labels, equations] = make_instance('LUT4_01', labels, range, equations);
 
filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/LUT0090.aig';

mat2aig(filename, delay, labels, range, equations);

bg = build_graph(delay, labels, range, equations);
view(bg);

[df, lf, rf] = aig2mat(filename);

bf = build_graph(df, lf, rf, equations);
view(bf);


            %wp = wp + 1;
        %out_bytes(wp) = uint8(bitor(bitand(x, 127), 128));
    %wp = wp + 1;
    %out_bytes(wp) = uint8(bitand(x, 127));
%latches = 0;
%for k = , write_line(num2str(signal2literal(in_labels{k}))); end
%for k = in_range.po
%    equation = in_equations{k};
%    if (~strcmpi(equation, 'latch')), continue; end
%    write_line(num2str(signal2literal(in_labels{k})));
%end

%for k = in_range.po
%end

    %gate = ;
    %len = numel(equation);
            %if (ns ~= 1 && ns ~= 3)
            %split = split(end);  
%{
            depth = 1;
            signalscope = false;
            split = [];
            index = start;

            while ((index <= len) && isempty(split))
                index = index + 1;
                ch = equation(index);
                switch (ch)
                case '(', if (~signalscope), depth = depth + 1; end
                case '[', signalscope = true;
                case ')', if (~signalscope), depth = depth - 1; end
                case ']', signalscope = false;
                case ',', if (~signalscope && (depth == 1)), split = index; end
                end
            end
            if (isempty(split)), error('Incomplete and definition.'); end
            %}








%for k = in_range.pi
%    equation = in_equations{k};
%    if (~strcmpi(equation, 'latch')), continue; end
    %latches = latches + 1;
%    push_literal();
%end

%literal = literal + 2;
%signal2literal(label) = literal;
%literal = literal + 2;
    %signal2literal(label) = literal;
    %signal2literal(['not(' signal ')']) = literal + 1;
    %literal = literal + 2;
    %signal2literal(in_label) = literal; 
    

%bdd = make_bdd(equation);
    
    
    
    
    
    %signals = [];
    
    
    %if (equation == '0' || equation == '1')
    %elseif (strcmpi(equation(
    %end
    %{
    function [out_bdd] = make_bdd(in_equation)
        inputstart = find(in_equation == '(', 1);
        gate = in_equation(1:inputstart);
        
        if (any(strcmpi(gate, {'and', 'or', 'xor'})))
        elseif (strcmpi(gate, 'not'))
        else
        end
        
        
        
        
        depth = 1;
        ignore = false;
        index = inputstart + 1;
        len = numel(in_equation);
        
        while (index <= len)
            ch = in_equation(index);
            switch (ch)
                case '('
                    depth = depth + 1;
                case ')',
                    depth = depth - 1;
                    if (depth == 0)
                        
                    end
                    
                    
                case '[', ignore = true;
                case ']', ignore = false;
                case ',',
            end
            
        end
        

            
                
                

            
            

        
        
    end
%}


