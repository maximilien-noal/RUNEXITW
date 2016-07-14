program Runexit;

{$D-,I-,L-,R-,S-,Y-}

uses
  Forms, ShellApi, SysUtils, WinProcs, WinTypes;

var
  h: Word;
  pathName: String;
  fileName: String;
  params: String;
  i, num: Integer;

begin
  { Split first parameter into path and filename }
  i := Pos ('\', ParamStr (1));
  if (i > 0) then
  begin
    { Make it a path, find last occurrence of directory separator }
    pathName := ParamStr (1);
    i := (StrRScan (@pathName [1], '\') - @pathName [1]) + 1;
    fileName := Copy (pathName, i + 1, Length (pathName) - i);
    pathName := Copy (pathName, 1, i);
  end else begin
    fileName := ParamStr (1);
  end;

  { Concatenate any remaining parameters }
  num := ParamCount;
  for i := 2 to num do
  begin
    if (i > 2) then params := params + ' ';
    params := params + ParamStr (i);
  end;

  { Add trailing NUL bytes }
  fileName := fileName + #0;
  pathName := pathName + #0;
  params := params + #0;

  { Execute the command }
  h := ShellExecute (0, nil, @fileName [1], @params [1], @pathName [1], SW_SHOWNORMAL);
  if (h >= 32) then
  begin
    { Wait for it to complete }
    repeat
      Application.ProcessMessages;
    until GetModuleUsage (h) = 0;
    { And shut down Windows }
    ExitWindows (0, 0);
  end;
end.
