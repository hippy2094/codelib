program testwhois;
{$ifdef fpc}{$mode objfpc}{$H+}{$endif}
uses SysUtils, whois;

var
  s: String;

begin
  if ParamCount > 0 then
  begin
    s := LookupWhois(ParamStr(1));
    writeln(s);
  end
  else writeln('Please specify a domain!');
end.

