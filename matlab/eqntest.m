
global CONFIG

CONFIG.EQN_NFGETS = 4096;
CONFIG.EQN_BUFFERSIZE = 16384;
CONFIG.EQN_NEDGES = 8192;

K = 4;
DF = false;
mode = 2;
alpha = 1.5; %1.5-2.5
maxi = 20; %20
epsrand = [0.001, 0.005]; %small

t = tic();
feqn = fopen('dsip_.eqn', 'rt');
[delay, range, labels, equations] = eqn2mat(feqn);
fclose(feqn);
toc(t)

t = tic();
[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);

depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);
toc(t)

t = tic();
[s, cv] = hara(order, iedge, oedge, noedge, delay, depth, height, af, range, K, DF, mode, maxi, alpha, epsrand(1), epsrand(2));
toc(t)

t = tic();
[resultdelay, resulttag, resultrange] = rebuild_graph_from_cones(s, cv, delay, range);
toc(t)

[resultiedge, resultoedge] = prepare_edges(resultdelay);
resultorder = graphtopoorder(resultdelay);
resultredro = fliplr(resultorder);

resultdepth = fill_depth(resultorder, resultiedge, resultdelay, resultrange);
resultheight = fill_height(resultredro, resultoedge, resultdelay, resultrange);
[resultaf, resultnoedge] = fill_af(resultorder, resultiedge, resultoedge, resultrange);













%feqn = fopen('dsip_PROC.eqn', 'rt');
%feqn = fopen('C6288_proc.eqn', 'rt');


%{
while (true)
    next = fgets(in_feqn, 4096);
    if (next == -1), break; end
    if (next(end) == nl), line = line + 1; end
    fl = [fl, next];    
    flindex = find(fl == ';');
    if (numel(flindex) < 1), continue; end
    flindex = flindex(1);
    parse_statement(fl(1:flindex));
	fl(1:flindex) = [];
end
%}
%rp = 1;
%nrp = rp + step;
    %flindex = find(fl(rp:(nrp - 1)) == ';');
    
    %fib = rp;
    %rp = nrp;
   
        
    
    
    %rp = 1;
    
    %flindex = flindex(1);
    %fl = [fl, next];    
    
    
	%fl(1:flindex) = [];

    %uid2signal(uid) = in_str;

    %function push_signal_list(in_list)
    %for signal = in_list, try_add_signal(signal{1}, true, false, false); end
    %end

%haspilist = false;
%haspolist = false;
%uid2signal = containers.Map('KeyType', 'double', 'ValueType', 'char');
%out_edges = [];
%t1 = 0;
%tt = 0;
%tn = 0;

%out_statements = [];
%flindex = 1;
    


%out_edges = edges;
%pi
%po
%numel(in)
%numel(allnodes)

%





%{
    for c = fl(flindex:end)
        if (c ~= ';'),
            if (c == nl), line = line + 1; end
            flindex = flindex + 1;
            continue;
        end
        parse_statement(fl(1:flindex));
        fl(1:flindex) = [];
        flindex = 1;
        break;
    end
    %}

%out_edges = [celledges{1:end}];
%out_signals = signal2uid;

%%if (signal2uid.isKey(in_str)), return; end, parse_error(['Duplicate signal ''' in_str '''']); end

    	%if (in_allownot && (in_str(1) == '!')), tss = in_str(2:end); else tss = in_str; end
    %if (in_allownot && (in_str(1) == '!')), tss = in_str(2:end); else tss = in_str; end

    
        %{
pivot = 0;
        for ch = in_s
            pivot = pivot + 1;
            if (ch ~= '='), continue; end
            lstr = strtrim(in_s(1:(pivot - 1)));
            rstr = strtrim(in_s((pivot + 1):(end-1)));
            break;
        end
        %}
%{
t1 = tic();
                
                
                
                t1 = toc(t1);
                tt = tt + t1;
                tn = tn + 1;
%}
%out_mat = [out_mat; {in_s}];
%if (haspilist), parse_error('INORDER redefinition'); end
                %push_signal_list(strtrim(strsplit(rstr)));
                %haspilist = true;
                %if (haspolist), parse_error('OUTORDER redefinition'); end
                %push_signal_list(strtrim(strsplit(rstr)));
                %haspolist = true;
%if (ss(1) == '!')
                        %    tss = ss(2:end);
                        %else
                        %    tss = ss;
                        %end
                        %try_add_signal(tss)
                        
                        
                        %if (~test_name(tss) && ~test_id(tss)), parse_error('Unexpected expression'); end
%str = ;
        %if (~test_name(str))
        %if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end

%if (~testname(lstr) && test_id(str)), parse_error(['Unexpected token ''' str '''']); end
                %if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end
        %push_node_list()
                
                %{
                for pi = listpi
                    str = pi{1};
                    alphanum = isstrprop(str, 'alphanum');
                    us = str == '_';
                    an1 = isstrprop(str, 'alpha');                    
                    if (~all(alphanum | us) || ~(an1 || us(1))), parse_error(['Unexpected token ''' str '''']); end
                    if (signal2uid.isKey(str)), parse_error(['Duplicate signal ''' str '''']); end
                end
                %}
                
        %expr = strsplit(in_s);
        
        
        
        
        %and * or + not ! xor ^
