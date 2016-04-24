
K = 4;
DF = false;

[delay, labels, range, equations] = load_leko_leku('leko-g5\g625');
%[delay, labels, range, equations] = load_lgsynth93('blif\alu4');
%[delay, labels, range, equations] = sample_valavan();



filename = 'C:/Users/jcds/Documents/GitHub/X38-02FO16/workspace/conetest.aig';
mat2aiger(filename, delay, labels, range, equations);

size(delay)

script = [
    {['read_aiger ' filename ';']};
    {'strash'};
    {'cleanup'}
    {'resyn2rs'};    
    {'balance'};
    {'refactor'};
    {'rewrite'}
    {'rr'};
    {'resyn2rs'};    
    {'balance'};
    {'refactor'};
    {'rewrite'}
    {'rr'};
    {'resyn2rs'};    
    {'balance'};
    {'refactor'};
    {'rewrite'}
    {'rr'};
    
    %repmat([{'balance'}; {'rewrite'}; {'refactor'};], 200, 1);    
    {['write_aiger -s ' filename]};
    {'quit'};
    ];

invoke_abc(script, false);

[delay, labels, range, equations] = aiger2mat(filename);

size(delay)


%[delay, labels, equations] = sort_graph(delay, labels, range, equations);


%view(build_graph(delay, labels, range, equations));


[iedge, oedge] = prepare_edges(delay, range);
order = graphtopoorder(delay);
inorder = get_inorder(delay, range);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);


t = tic();
[cones] = generate_cones(inorder, iedge, oedge, range, K, delay);
toc(t);



%checkmap = containers.Map();
%for n = 1:in_range.szin
%    c = out_cones{n};
%    for m = 1:numel(c)
%        key = [nodestring{c{m}}];
%        if (checkmap.isKey(key)), disp(['DUP: ' num2str(checkmap(key)) ' : ' num2str([n, m])]); end
%        checkmap(key) = [n, m];
%    end
%end
%sortc = zeros(1, ncones(adjin));
    %for n = 1:ncones(adjin), sortc(n) = numel(scones{n}); end
    %[~, sortc] = sort(sortc);
    %scones(sortc);
%ncones(adjin) = ncones(adjin) + subindex;
%function trim_cones()
    %end
%{
        testcones = allcones(1:subindex);
        nc = zeros(1, subindex);
        prevsubindex = subindex;
        allcones = cell(1, subindex);
        subindex = 0;

        for j = 1:prevsubindex, nc(j) = numel(testcones{j}); end

        for j = unique(nc)
            tc = uniqueRowsCA(testcones(nc == j).');
            ntc = numel(tc);
            allcones((1:ntc) + subindex) = tc.';
            subindex = subindex + ntc;
        end
        %}
        %{
        
        %}
    
        %{

            disp('MISS');
            vec = cell(1, numel(nr));
            for k = 1:numel(nr), vec{k} = 1:ncones(nr(k)); end
            offset = zeros(numel(nr), 1);
            for k = 1:(numel(nr) - 1), offset(k + 1) = offset(k) + ncones(nr(k)); end
            
            nrcones = cell_collapse(out_cones(nr));
            for c = combvec(vec{:})
                cnr = unique([nrcones{c + offset}]);
                key = num2str(cnr);
                if (conemap.isKey(key)), continue; end
                conemap(key) = key;
                cone = [in, cnr];
                subindex = subindex + 1;
                allcones{subindex} = cone;
            end

            allcones = allcones(1:subindex);
            index = index + 1;
            cones{index} = allcones;
            
            ncones(adjin) = ncones(adjin) + subindex;
        end
    end
    %}%{
        vec = cell(1, nnr);
        offset = zeros(nnr, 1);
        adjnr = in_nr - in_range.szpi;
        nrc = cell_collapse(out_cones(adjnr));
        allcones = cell(1, prod(ncones(adjnr)));
        
        for k = 1:nnr, vec{k} = 1:ncones(adjnr(k)); end
        for k = 1:(nnr - 1), offset(k + 1) = offset(k) + ncones(adjnr(k)); end

        for combo = combvec(vec{:}), try_add_cone(unique_nodes([in, [nrc{combo + offset}]])); end
        trim_cones();
            %}
           
        %{
        
        %}
    
        %{

            disp('MISS');
            vec = cell(1, numel(nr));
            for k = 1:numel(nr), vec{k} = 1:ncones(nr(k)); end
            offset = zeros(numel(nr), 1);
            for k = 1:(numel(nr) - 1), offset(k + 1) = offset(k) + ncones(nr(k)); end
            
            nrcones = cell_collapse(out_cones(nr));
            for c = combvec(vec{:})
                cnr = unique([nrcones{c + offset}]);
                key = num2str(cnr);
                if (conemap.isKey(key)), continue; end
                conemap(key) = key;
                cone = [in, cnr];
                subindex = subindex + 1;
                allcones{subindex} = cone;
            end

            allcones = allcones(1:subindex);
            index = index + 1;
            cones{index} = allcones;
            
            ncones(adjin) = ncones(adjin) + subindex;
        end
    end
    %}
%cnr = unique([nrcones{combo + offset}]);
            %key = num2str(cnr);
            %if (conemap.isKey(key)), continue; end
            %conemap(key) = key;
            %try_add_cone([in, cnr]);
        
        
        
        
        
        
    
        %warning('Unimplemented operation');
        %allcones = [];
 %ie = [in_iedge{in_c}];
        %iee = ~ismembc(unique(ie(1, :)), in_c);
%tag1 = c1(1:(end - 1));
            %if (~isempty(tag1)), tag1 = tag1(end); end
            
            
            
                
                %tag2 = c2(1:(end - 1));
                %if (~isempty(tag2) && ~isempty(tag1) && any(tag1 == tag2)), prune = prune + 1; continue; end
                
                %x1 = c1(1:(end - 1));
                %x2 = c2(1:(end - 1));
                
                
                
                
                
                
                
                %{
                ck = [nodestring{cone}];
                if (conemap.isKey(ck))
                    dup = dup + 1;
                    continue;
                end
                conemap(ck) = 0;
                %}
%list2 = unique([list2 c2(1)]);
                %if (any(ismembc(list1, list2))), prune = prune + 1; continue; end
                
                %%if (any(tag == c2)), prune = prune + 1; continue; end
                %tag2 = c2(1:(end-1));
                %iex2 = [in_iedge{tag2}];
                %if ((~isempty(iex1) && ~isempty(iex2)) && any(ismembc(iex2(1,:), iex1(1,:)))), prune = prune + 1; continue; end
                
                %mk = marker;
                %mk([in, c1, c2]) = true;
                %cone = in_range.all(mk);
%cone = unique([in, c1, c2]);
                %ck = sprintf('%d.', cone);
                %%debug = conemap(ck);
                %if (any(strcmpi(ck, conelist))), dup = dup + 1; continue; end
                %conelist = [conelist, {ck}];
                %{nrc1; nrc2; k; l};
%list1 = unique([list1 c1(1:(end-1))]);
            %if (any(ismembc(list1, list2))), prune = prune + sum(keep2); continue; end
            
            %tag1 = c1(1:(end - 1));
            %iex1 = [in_iedge{tag1}];
%for k = v1, iex = [in_iedge{nrc1{k}}]; keep1(k) = ~any(iex(1, :) == nr2); end
        %for k = v2, iex = [in_iedge{nrc2{k}}]; keep2(k) = ~any(iex(1, :) == nr1); end

        %prune = prune + ((nnc1 * nnc2) - (sum(keep1) * sum(keep2)));
        
        
        
        %list1 = [];
        %list2 = [];
%{
        nncm = min([nnc1, nnc2]);
        keep1 = true(1, nnc1);
        keep2 = true(1, nnc2);
        for k = 1:nncm
            iex = [in_iedge{nrc1{k}}];
            keep1(k) = ~any(iex(1,:) == nr2);
            iex = [in_iedge{nrc2{k}}];            
            keep2(k) = ~any(iex(1,:) == nr1);
            if (~keep2(k) || ~keep1(k)), break; end
        end        
        for l = (k + 1):nnc1
            iex = [in_iedge{nrc1{l}}];
            keep1(l) = ~any(iex(1,:) == nr2);
        end
        for l = (k + 1):nnc2
            iex = [in_iedge{nrc2{l}}];
            keep2(l) = ~any(iex(1,:) == nr1);
        end
        
        v1 = 1:nnc1;
        v2 = 1:nnc2;
        %}
%end
   
    
         %for k = 1:index
   %     c = cones(k);
        
    %end
 %{
    total = index * prod(ncones(inpre));
    
    
    
    
    allcones = cell(1, total);
    allindex = 0;
    
    vec = cell(1, szin);
    for n = 1:szin, vec{n} = 1:ncones(inpre); end    
    nrcones = cell_collapse(out_cones(inpre));
    
    for c = combvec(vec{:})
    end
    %}
    
    
    %nrcones = ;
    %[nrcones{:}];
    

        
        
%disp([num2str(in) ': ' num2str(ncones(adjin))]);
%{
    if (isempty(nr))
        allcones = cell(1, 1);
        nnr = 0;
        try_add_cone(in);
    else
        nr = nr - in_range.szpi;
        allcones = cell(1, prod(ncones(nr)));
        
        
        if (nnr == 1)
            nnc = ncones(nr);
            nrcones = out_cones{nr};
            for k = 1:nnc
                cnr = sort(nrcones{k});
                key = num2str(cnr);
                try_add_cone([in, cnr]);
                conemap(key) = key;
            end          
        elseif (nnr == 2)
        else
        end
        
        
            if (isempty(nr))
        index = index + 1;
        allcones = cell(1, 1);
        allcones{1} = in;
        cones{index} = allcones;
        ncones(adjin) = ncones(adjin) + 1;
    else
        nr = nr - in_range.szpi;
        total = prod(ncones(nr));
        allcones = cell(1, total);
        subindex = 0;
        
        nnr = numel(nr);
        if (nnr < 2)
            nnc = ncones(nr);
            allcones = cell(1, nnc);
            nrcones = out_cones{nr};
            for k = 1:nnc
                cnr = sort(nrcones{k});
                key = num2str(cnr);
                allcones{k} = [in, nrcones{k}];
                conemap(key) = key;
                disp(['< 2: ' num2str(k) ' / ' num2str(nnc)]);
            end
            index = index + 1;
            cones{index} = allcones;
            ncones(adjin) = ncones(adjin) + nnc;
        elseif (nnr < 3)
            nnc1 = ncones(nr(1));
            nnc2 = ncones(nr(2));
            nrc1 = out_cones{nr(1)};
            nrc2 = out_cones{nr(2)};
            nnc = nnc1 * nnc2;
            allcones = cell(1, nnc);
            total = 0;
            for k = 1:nnc1
                for l = 1:nnc2
                    disp(['< 3: ' num2str((k - 1) * nnc2 + l) ' / ' num2str(nnc)]);
                    cnr = unique([nrc1{k}, nrc2{l}]);
                    key = num2str(cnr);
                    if (conemap.isKey(key)), continue; end
                    conemap(key) = key;
                    total = total + 1;
                    allcones{total} = [in, cnr];
                end
            end
            index = index + 1;
            cones{index} = allcones(1:total);
            ncones(adjin) = ncones(adjin) + total;
            
            
        else
        
        
%}
%numi = numel(in_inorder);
%counter = 0;
    %counter = counter + 1;
    %disp([num2str(counter) ' / ' num2str(numi)]);
    %conemap = containers.Map();
 %if (sum(is_pi(ind, in_range)) > in_K), disp('> K PI'); return; end
        %if (sum(is_pi(unique(ie(1, iee)), in_range)) > in_K), return; end
        %{
        if (nnr > 1)
            
            
            %if (sum(is_pi(unique(ie), in_range)) > in_K), disp('not K'); return; end
            
            
            
        end
            %}
        
    %in_nr = in_nr - in_range.szpi;
                %cnr = sort(nrcones{k});
                %key = num2str(cnr);
                
                %conemap(key) = key;
            
            
    %{
    subindex = 0;
    
    
    
%function [out_key] = hash_cone(in_c)
        %out_key = num2str(in_c); %628.324600 621.391284
        %out_key = sprintf('%d.',in_c); %434.963708
        %end
%ck = hash_cone(cone);
                    %disp(num2str(conemap(ck)));
                    %if (conemap(ck) ~= 2)
                    %    disp('BRKP');
                    %end
%1:nnc1
            %1:nnc2
            %if (any(c1 == nr2)), disp('HIT 1'); continue; end
            %if (any(c2 == nr1)), disp('HIT 2'); continue; end
   %ie1 = in_iedge{nr1};
        %ie2 = in_iedge{nr2};
        %if (any(ie1(1,:) == nr2) || any(ie2(1,:) == nr1))
        %    disp('HIT');
        %    return;
        %end
%ie1 = in_iedge{nr1};
                %ie2 = in_iedge{nr2};
                
                
                
                
                
                
                
                %if (any(c1 == nr2) || any(c2 == nr1))
                %    disp('        HIT');
                %    continue;
                %end
                %disp('    INNER');
            %disp('OUTER')
            %{
            key = num2str(unique(in_c));
            if (conemap.isKey(key))
                disp('DUP');% num2str(conemap(key)) ' :: ' num2str(nnr)]);
                debug_info = conemap(key);
                
                if (nnr < 1)
                    next_step = {
                        nnr;
                        in_c;
                        };
                elseif (nnr < 2)
                    next_step = {
                        nnr;
                        in_c;
                        nrcones;
                        k;
                        };
                else
                    next_step = {
                        nnr;
                        in_c;
                        nrc1;
                        nrc2;
                        k;
                        l;
                        };
                end
                if (debug_info{1} == 1)
                    return;
                end
                
                return;
            end
            if (nnr < 1)
                conemap(key) = {
                    nnr;
                    in_c;
                    };
            elseif (nnr < 2)
                conemap(key) = {
                    nnr;
                    in_c;
                    nrcones;
                    k;
                    };
            else
                conemap(key) = {
                    nnr;
                    in_c;
                    nrc1;
                    nrc2;
                    k;
                    l;
                    };
            end
            %}
            
        %ie = in_iedge{in_c};
        %ie = unique(ie(1, :));
        %iec = ismember(ie, in_c);
        %iee = ~iec;
        %if (numel(ie(iee)) > in_K), return; end
        %in_c = unique(in_c);
        
        %iec = ismembc(ie(1, :), in_c);
        %{
        ie = [in_iedge{in_c}];
        iec = ismember(ie(1, :), in_c);
        iee = ~iec;
        ind = unique(ie(1, iee));
        if (numel(ind) > in_K), return; end
        %}
%allcones{((k - 1) * nnc2) + l} = [in, unique([nrc1{k}, nrc2{l}])];
            %{
            if (any((ie1(1, :) >= (nr2 - 0.5)) & (ie1(1, :) <= (nr2 + 0.5))) || any((ie2(1, :) >= (nr1 - 0.5)) & (ie2(1, :) <= (nr1 + 0.5))))
                disp('HIT');
                ie1(1, :)
                nr2
                ie2(1, :)
                nr1
                allcones = [];
                subindex = 0;
            elseif (any(nr1 == nrc2{end}) || any(nr2 == nrc1{end}))
                disp('HIT2');
                allcones = [];
                subindex = 0;
        
            else
            
                nnc = nnc1 * nnc2;
                allcones = cell(1, nnc);
                subindex = 0;
                for k = 1:nnc1
                    for l = 1:nnc2
                        %allcones{((k - 1) * nnc2) + l} = [in, unique([nrc1{k}, nrc2{l}])];
                        try_add_cone([in, unique([nrc1{k}, nrc2{l}])]);
                    end
                end
            %end
                %}
%allcones = cell(1, nnc1);
                %for k = 1:nnc1, allcones{k} = [in, nrc1{k}]; end
                %subindex = nnc1;

                %allcones = cell(1, nnc2);
                %for k = 1:nnc2, allcones{k} = [in, nrc2{k}]; end
                %subindex = nnc2;
            %{
            total = 0;
            
                    disp(['< 3: ' num2str((k - 1) * nnc2 + l) ' / ' num2str(nnc)]);
                    cnr = unique([nrc1{k}, nrc2{l}]);
                    key = num2str(cnr);
                    if (conemap.isKey(key)), continue; end
                    conemap(key) = key;
                    total = total + 1;
                    allcones{total} = [in, cnr];
                end
            end
            %}
        
            %allcones = [];
            %subindex = 0;
                %}