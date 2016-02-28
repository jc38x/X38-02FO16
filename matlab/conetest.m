
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