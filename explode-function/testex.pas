program testexplode;
{$ifdef fpc}{$mode objfpc}{$H+}{$endif}
uses explodefunc;

var
  s: String;
  i: Integer;
  a: TArray;

begin
  s := 'hello there how are you?';
  a := explode(' ',s,0);
  for i := 0 to High(a) do writeln('a[',i,']=',a[i]);
end.
