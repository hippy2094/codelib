unit whois;
{$ifdef fpc}{$mode objfpc}{$H+}{$endif}
interface

uses Classes, SysUtils, Types, StrUtils, blcksock;

function LookupWhois(host: String): String;

implementation

function LookupWhois(host: String): String;
var
  b: TTCPBlockSocket;
  rparts: TStrings;
  refer: String;
  i: Integer;
  response: TStringStream;
  rlines: TStrings;
begin
  refer := '';
  // First connect to whois.iana.org and find the whois server for the domain
  b := TTCPBlockSocket.Create;
  response := TStringStream.Create('');
  b.Connect(b.ResolveName('whois.iana.org'),'43');
  b.SendString(host + #13#10);
  b.RecvStreamRaw(response,60000);
  b.CloseSocket;
  b.Free;
  // Find the refer: line
  rlines := TStringList.Create;
  rlines.Text := response.DataString;
  for i := 0 to rlines.Count -1 do
  begin
    if AnsiPos('refer:',rlines[i]) > 0 then
    begin
      rparts := TStringList.Create;
      ExtractStrings([':'], [], PChar(rlines[i]), rparts);
      refer := trim(rparts[1]);
      rparts.Free;
      break;
    end;
  end;
  rlines.Free;
  if Length(refer) < 1 then Result := 'Could not lookup whois for ' + host
  else
  begin
    // Now we connect to the referred server
    b := TTCPBlockSocket.Create;
    b.ConvertLineEnd := false;
    b.Connect(b.ResolveName(refer),'43');
    // .com and .net are handled differently
    if (AnsiEndsStr('.com',host)) or (AnsiEndsStr('.net',host)) then
      b.SendString('domain ' + host + #13#10)
    else
      b.SendString(host + #13#10);
    response := TStringStream.Create('');
    b.RecvStreamRaw(response,60000);
    Result := response.DataString;
    response.Free;
  end;
  b.CloseSocket;
  b.Free;
end;

end.