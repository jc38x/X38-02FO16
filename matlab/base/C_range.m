%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

classdef C_range
properties (Access = public, Constant)
    CONE_NODE    = 1;
    CONE_EDGE    = 2;
    CONE_IEDGE   = 3;
    CONE_OEDGE   = 4;
    CONE_NROEDGE = 5;
    CONE_ENTRIES = 5;
end
properties (Access = public)    
    szpi
    szin
    szpo
    sz
    
    pilo
    pihi
    inlo
    inhi
    polo
    pohi
    
    pi
    in
    po
    all
    
    notpi
    top
    notpo
end
end
