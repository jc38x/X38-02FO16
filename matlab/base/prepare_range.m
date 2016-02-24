%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_range] = prepare_range(in_pilo, in_pihi, in_inlo, in_inhi, in_polo, in_pohi)
out_range.pilo = in_pilo;
out_range.pihi = in_pihi;
out_range.inlo = in_inlo;
out_range.inhi = in_inhi;
out_range.polo = in_polo;
out_range.pohi = in_pohi;
out_range.pi = out_range.pilo:out_range.pihi;
out_range.in = out_range.inlo:out_range.inhi;
out_range.po = out_range.polo:out_range.pohi;
out_range.szpi = out_range.pihi - out_range.pilo + 1;
out_range.szin = out_range.inhi - out_range.inlo + 1;
out_range.szpo = out_range.pohi - out_range.polo + 1;
out_range.sz = out_range.pohi - out_range.pilo + 1;
end
