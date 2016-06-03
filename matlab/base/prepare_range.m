%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_range] = prepare_range(in_szpi, in_szin, in_szpo)
out_range = C_range();

out_range.szpi = in_szpi;
out_range.szin = in_szin;
out_range.szpo = in_szpo;
out_range.sz   = in_szpi + in_szin + in_szpo;

if (in_szpi < 1)
    out_range.pilo = 0;
    out_range.pihi = 0;
    out_range.pi   = [];
else
    out_range.pilo = 1;
    out_range.pihi = in_szpi;
    out_range.pi   = out_range.pilo:out_range.pihi;
end

if (in_szin < 1)
    out_range.inlo = 0;
    out_range.inhi = 0;
    out_range.in   = [];
else
    out_range.inlo = out_range.pihi + 1;
    out_range.inhi = out_range.pihi + in_szin;
    out_range.in   = out_range.inlo:out_range.inhi;
end

if (in_szpo < 1)
    out_range.polo = 0;
    out_range.pohi = 0;
    out_range.po   = [];
else
    out_range.polo = out_range.inhi + 1;
    out_range.pohi = out_range.inhi + in_szpo;
    out_range.po   = out_range.polo:out_range.pohi;
end

out_range.all = [out_range.pi, out_range.in, out_range.po];

out_range.top   = [out_range.pi, out_range.po];
out_range.notpi = [out_range.in, out_range.po];
out_range.notpo = [out_range.pi, out_range.in];
end
