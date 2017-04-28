unit copydir;
{$ifdef fpc}{$mode objfpc}{$H+}{$endif}
interface

uses Classes, SysUtils, Types;

procedure CopyDirectoryStructure(inDir: String; outDir: String);

implementation

procedure CopyDirectoryStructure(inDir: String; outDir: String);
var
  s: TSearchRec;
  nInDir, nOutDir: String;
begin
  if FindFirst(IncludeTrailingPathDelimiter(inDir) + '*',faDirectory, s) = 0 then
  begin
    repeat
      if (s.Name <> '.') and (s.Name <> '..') and ((s.Attr and faDirectory) = faDirectory) then
      begin
        nInDir := IncludeTrailingPathDelimiter(inDir) + s.Name;
        nOutDir := IncludeTrailingPathDelimiter(outDir) + s.Name;
        // Create new subdirectory in outDir
        mkdir(nOutDir);
        // Recurse into subdirectory in inDir
        copyDirectoryStructure(nInDir,nOutDir);
      end;
    until FindNext(s) <> 0;
  end;
  FindClose(s);
end;

end.