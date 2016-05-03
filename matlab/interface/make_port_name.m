%**************************************************************************
% X38-02FO16
% jcds (jcds.x38e@gmail.com)
% 2016
%**************************************************************************

function [out_name] = make_port_name(in_portepr, in_source)
port = in_portepr.getPort();
name = char(port.getName());
if (port.isBus()), bit = ['(' num2str(in_portepr.getSingleBitPort().bitPosition()) ')']; else bit = ''; end
if (~in_portepr.isTopLevelPortRef())
    prefix = [char(in_portepr.getCellInstance().getName()) ','];
    suffix = '';
else
    prefix = '';
    if (in_source)
        if (~port.isInputOnly()),  suffix = '@O'; else suffix = ''; end
    else
        if (~port.isOutputOnly()), suffix = '@I'; else suffix = ''; end
    end
end
out_name = [prefix name bit suffix];
end
