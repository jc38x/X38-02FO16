%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_cones] = generate_cones(in_inorder, in_iedge, in_oedge, in_range, in_K)
out_cones = cell(1, in_range.szin);
ncones = zeros(1, in_range.szin);


%numi = numel(in_inorder);
%counter = 0;
    %counter = counter + 1;
    %disp([num2str(counter) ' / ' num2str(numi)]);
    %conemap = containers.Map();
    
    prune = 0;
    dup = 0;
    kcut = 0;

for in = in_inorder
    conemap = containers.Map();
    
    iedge = in_iedge{in};
    inode = iedge(1, :);
    inpre = inode(is_in(inode, in_range));
    szin = numel(inpre);
    adjin = in - in_range.szpi;
    
    szall = 1;
    for n = 1:szin, szall = szall + nchoosek(szin, n); end
    cones = cell(1, szall);
    index = 0;
    
    add_cone([]);
    for n = 1:szin
        parall = nchoosek(inpre, n);
        for m = 1:size(parall, 1), add_cone(parall(m, :)); end
    end
    
    out_cones{adjin} = cell_collapse(cones(1:index));
    %disp([num2str(in) ': ' num2str(ncones(adjin))]);
end
    
    prune
    dup
    kcut
    


    function add_cone(in_nr)
	
    nnr = numel(in_nr);
    subindex = 0;
    
    switch (nnr)
    case 0
        allcones = cell(1, 1);
        try_add_cone(in);
    case 1
        nr = in_nr - in_range.szpi;
        nnc = ncones(nr);
        nrcones = out_cones{nr};
        allcones = cell(1, nnc);
        for k = 1:nnc, try_add_cone(unique([in, nrcones{k}])); end
    case 2
        nr1 = in_nr(1);
        nr2 = in_nr(2);
        adjnr1 = nr1 - in_range.szpi;
        adjnr2 = nr2 - in_range.szpi;
        nnc1 = ncones(adjnr1);
        nnc2 = ncones(adjnr2);
        nrc1 = out_cones{adjnr1};
        nrc2 = out_cones{adjnr2};
        allcones = cell(1, nnc1 * nnc2);
        
        %ie1 = in_iedge{nr1};
        %ie2 = in_iedge{nr2};
        %if (any(ie1(1,:) == nr2) || any(ie2(1,:) == nr1))
        %    disp('HIT');
        %    return;
        %end
        
        keep1 = true(1, nnc1);
        v1 = 1:nnc1;
        for k = v1
            iex = [in_iedge{nrc1{k}}];
            keep1(k) = ~any(iex(1,:) == nr2);
        end
        
        keep2 = true(1, nnc2);
        v2 = 1:nnc2;
        for k = v2
            iex = [in_iedge{nrc2{k}}];
            keep2(k) = ~any(iex(1,:) == nr1);
        end
        
        prune = prune + (nnc1 - sum(keep1)) * (nnc2 - sum(keep2));
        
        
        for k = v1(keep1)%1:nnc1
            c1 = nrc1{k};
            %if (any(c1 == nr2)), disp('HIT 1'); continue; end
            for l = v2(keep2)%1:nnc2
                c2 = nrc2{l};
                %if (any(c2 == nr1)), disp('HIT 2'); continue; end
            
                
                cone = unique([in, c1, c2]);
                %ck = hash_cone(cone);
                ck = sprintf('%d.', cone);
                if (conemap.isKey(ck))
                    %disp(num2str(conemap(ck)));
                    %if (conemap(ck) ~= 2)
                    %    disp('BRKP');
                    %end
                    dup = dup + 1;
                    continue;
                end
                conemap(ck) = 2;
                
                
                try_add_cone(cone);
                
            end
            
        end
            
            
    otherwise
        warning('Unimplemented operation');
        allcones = [];
    end
    
    index = index + 1;
    cones{index} = allcones(1:subindex);
    ncones(adjin) = ncones(adjin) + subindex;
    
        %function [out_key] = hash_cone(in_c)
        %out_key = num2str(in_c); %628.324600 621.391284
        %out_key = sprintf('%d.',in_c); %434.963708
        %end
    
        function try_add_cone(in_c)
        ie = [in_iedge{in_c}];
        iee = ~ismembc(unique(ie(1, :)), in_c);
        if (sum(iee) > in_K), kcut = kcut + 1; return; end

        subindex = subindex + 1;
        allcones{subindex} = in_c;
        end
    
        
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
        
        
        
        
        
%}
        %{
        vec = cell(1, nnr);
        for k = 1:numel(nr), vec{k} = 1:ncones(nr(k)); end
        offset = zeros(nnr, 1);
        for k = 1:(nnr - 1), offset(k + 1) = offset(k) + ncones(nr(k)); end
        
        nrcones = cell_collapse(out_cones(nr));
        for c = combvec(vec{:})
            cnr = unique([nrcones{c + offset}]);
            key = num2str(cnr);
            if (conemap.isKey(key)), continue; end
            conemap(key) = key;
            try_add_cone([in, cnr]);
        end
        %}
    %end
   
    
    
        
        
        
        %{
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
    
    

        
    
    end





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
    

%{
    function add_cone(in_c)
    ie = [in_iedge{in_c}];
    iec = ismember(ie(1, :), in_c);
    iee = ~iec;
    
    oenr = [in_oedge{in_c(in_c ~= in)}];
    if (~isempty(oenr)), oenr(:, ismember(oenr(2, :), in_c)) = []; end
    
    index = index + 1;

    cones{1, index} = in_c;
    cones{2, index} = ie(:, iec);
    cones{3, index} = ie(:, iee);
    cones{4, index} = in_oedge{in};
    cones{5, index} = oenr;
    end
%}



%{
function try_add_cone(in_c)
    ie = [in_iedge{in_c}];
    iec = ismembc(ie(1, :), in_c);
    iee = ~iec;
    if (numel(unique(ie(1, iee))) > in_K), return; end

    nroot = in_c ~= in;
    oenr = cell2mat(in_oedge(in_c(nroot)));
    if (~isempty(oenr)), oenr(:, ismembc(oenr(2, :), in_c)) = []; end

    index = index + 1;

    cones{1, index} = [in, in_c(nroot)];
    cones{2, index} = ie(:, iec);
    cones{3, index} = ie(:, iee);
    cones{4, index} = in_oedge{in};
    cones{5, index} = oenr;
end
%}
end
