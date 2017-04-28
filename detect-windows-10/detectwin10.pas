unit detectwin10;
{$mode objfpc}{$H+}
interface

uses Classes, SysUtils, process;

function IsWin10: Boolean;

implementation

function IsWin10: Boolean;
var
 output: String;
begin
 output := '';
 Result := false;
 if RunCommand('cmd.exe',['/C','ver'],output) then
 begin
   if AnsiPos('[Version 10',output) > 0 then Result := true;
 end;
end;

end.