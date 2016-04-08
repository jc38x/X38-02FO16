%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_range] = prepare_range(in_szpi, in_szin, in_szpo)
out_range.szpi = in_szpi;
out_range.szin = in_szin;
out_range.szpo = in_szpo;
out_range.sz   = in_szpi + in_szin + in_szpo;

out_range.pilo = 1;
out_range.pihi = in_szpi;
out_range.inlo = out_range.pihi + 1;
out_range.inhi = out_range.pihi + in_szin;
out_range.polo = out_range.inhi + 1;
out_range.pohi = out_range.inhi + in_szpo;

out_range.pi  = out_range.pilo:out_range.pihi;
out_range.in  = out_range.inlo:out_range.inhi;
out_range.po  = out_range.polo:out_range.pohi;
out_range.all = out_range.pilo:out_range.pohi;

out_range.top = [out_range.pi, out_range.po];
out_range.notpi = [out_range.in, out_range.po];
out_range.notpo = [out_range.pi, out_range.in];




out_range.CONE_NODE    = 1;
out_range.CONE_EDGE    = 2;
out_range.CONE_IEDGE   = 6;
out_range.CONE_OEDGE   = 4;
out_range.CONE_ENTRIES = 6;
end
