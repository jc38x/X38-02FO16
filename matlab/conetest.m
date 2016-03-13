
%{
c = cell(1, 3);
c{1} = {[1], [1,2], [1,2,3]};
c{2} = {[2], [2,3], [2,3,4]};
c{3} = {[3], [3,4]};

c([1,3])
%}



K = 4;
DF = false;

%[delay, labels, range] = sample_valavan();
[delay, labels, range] = aig2mat('C:/Users/jcds/desktop/i10.aig');

[iedge, oedge] = prepare_edges(delay);
order = graphtopoorder(delay);
redro = fliplr(order);
depth = fill_depth(order, iedge, delay, range);
height = fill_height(redro, oedge, delay, range);
[af, noedge] = fill_af(order, iedge, oedge, range);

t = tic();
[tsort, cones] = generate_cones_all_alt(order, iedge, oedge, range, K, DF, delay);
toc(t);


%{
conea = {[1,2,3]; [1]; [2]; [3]; [4]};
coneb = {[4,5]; [1]; [2]; [3]; [4]};
conec = {[7]; [1]; [2]; [3]; [4]};

cone1 = [conea(:), coneb(:), conec(:)];
cone2 = [conea(:), conec(:)];
cone3 = [conea(:)];
cone4 = [coneb(:), conec(:)];

cones = [{cone1}, {cone2}, {cone3}, {cone4}];

selection = cones([1, 2, 3]);
nodes = selection{2}{1,2};%selection{1}{1,2};
%}
% raiz, fijo(nodos), cono

%{
cone1 = {{[1,2,3]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[2,3,4]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[5,6,7]}; {[1]}; {[2]}; {[3]}; {[4]}};

cones = {
    {
    {[1,2,3]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[2,3,4]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[5,6,7]}; {[1]}; {[2]}; {[3]}; {[4]}
    } , ...
    {
    {[8,9,10]}; {[1]}; {[2]}; {[3]}; {[4]}, ...
    {[11,12,13]}; {[1]}; {[2]}; {[3]}; {[4]}
    } , ...
    {
    {[14,15]}; {[1]}; {[2]}; {[3]}; {[4]}
    }
    };
%}