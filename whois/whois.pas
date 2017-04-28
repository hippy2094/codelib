unit whois;
{$ifdef fpc}{$mode objfpc}{$H+}{$endif}
interface

uses Classes, SysUtils, Types, StrUtils, explodefunc, blcksock;

function Whois(host: String): String;

implementation

function Whois(host: String): String;
var
  b: TTCPBlockSocket;
  response: TStrings;
  rparts: TArray;
  refer: String;
  i: Integer;
begin
  refer := '';
  // First connect to whois.iana.org and find the whois server for the domain
  b := TTCPBlockSocket.Create;
  response := TStringList.Create;
  b.Connect(b.ResolveName('whois.iana.org'),'43');
  b.SendString(host + #13#10);
  response.Text := b.RecvPacket(60000);
  b.CloseSocket;
  b.Free;
  // Find the refer: line
  for i := 0 to response.Count -1 do
  begin
    if AnsiPos('refer:',response[i]) > 0 then
    begin
      rparts := explode(':',response[i],0);
      refer := trim(rparts[1]);
      break;
    end;
  end;
  if Length(refer) < 1 then Result := 'Could not lookup whois for ' + host
  else
  begin
    // Now we connect to the referred server
    b := TTCPBlockSocket.Create;
    b.Connect(b.ResolveName(refer),'43');
    // .com and .net are handled differently
    if (AnsiEndsStr('.com',host)) or (AnsiEndsStr('.net',host)) then
      b.SendString('domain ' + host + #13#10)
    else
      b.SendString(host + #13#10);
    response.Clear;
    response.Text := b.RecvPacket(60000);
    Result := response.Text;
    response.Free;
  end;
end;

end.