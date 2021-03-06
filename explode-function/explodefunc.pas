unit explodefunc;
{$ifdef fpc}{$mode objfpc}{$H+}{$endif}
interface

uses Classes, Types;

type
  TArray = array of string;

function explode(cDelimiter,  sValue : string; iCount : integer) : TArray;

implementation

function explode(cDelimiter,  sValue : string; iCount : integer) : TArray;
var
  s : string; i,p : integer;
begin
  s := sValue; i := 0;
  while length(s) > 0 do
  begin
    inc(i);
    SetLength(result, i);
    p := pos(cDelimiter,s);
    if ( p > 0 ) and ( ( i < iCount ) OR ( iCount = 0) ) then
    begin
      result[i - 1] := copy(s,0,p-1);
      s := copy(s,p + length(cDelimiter),length(s));
    end else
    begin
      result[i - 1] := s;
      s :=  '';
    end;
  end;
end;

end.
