unit cmykutil;
{$IFDEF FPC}{$mode delphi}{$H+}{$ENDIF}
interface

uses SysUtils, Graphics, Math{$IFNDEF FPC}, Windows{$ENDIF};

type
  TCMYKColor = record
    C: Double;
    M: Double;
    Y: Double;
    K: Double;
  end;

function RGBToCMYK(c: TColor): TCMYKColor;
function CMYKToRGB(c: TCMYKColor): TColor;
function CMYKToString(c: TCMYKColor): String;

implementation

function RGBToCMYK(c: TColor): TCMYKColor;
var
  r,g,b,k: Double;
begin
  {$IFNDEF FPC}
  r := 1 - (GetRValue(c) / 255);
  g := 1 - (GetGValue(c) / 255);
  b := 1 - (GetBValue(c) / 255);
  {$ELSE}
  r := 1 - (Red(c) / 255);
  g := 1 - (Green(c) / 255);
  b := 1 - (Blue(c) / 255);
  {$ENDIF}
  k := min(r,min(g,b));
  if c = 0 then
  begin
    Result.C := 0.00;
    Result.M := 0.00;
    Result.Y := 0.00;
    Result.K := 1.00;
  end
  else
  begin
    Result.C := (r - k) / (1 - k);
    Result.M := (g - k) / (1 - k);
    Result.Y := (b - k) / (1 - k);
    Result.K := k;
  end;
end;

function CMYKToRGB(c: TCMYKColor): TColor;
var
  r,g,b: Byte;
begin
  r := Round(255 * (1-c.C) * (1-c.K));
  g := Round(255 * (1-c.M) * (1-c.K));
  b := Round(255 * (1-c.Y) * (1-c.K));
  {$IFNDEF FPC}
  Result := RGB(r,g,b);
  {$ELSE}
  Result := RGBToColor(r,g,b);
  {$ENDIF}
end;

function CMYKToString(c: TCMYKColor): String;
begin
  Result := FloatToStrF(c.C, ffGeneral, 3, 3);
  Result := Result + ',';
  Result := Result + FloatToStrF(c.M, ffGeneral, 3, 3);
  Result := Result + ',';
  Result := Result + FloatToStrF(c.Y, ffGeneral, 3, 3);
  Result := Result + ',';
  Result := Result + FloatToStrF(c.K, ffGeneral, 3, 3);
end;

end.
