program bsbt;
{$mode delphi}{$H+}
uses Classes, SysUtils, StrUtils, miscfunc;

var
  POSTVars: TPostVarList;
  GETVars: TPostVarList;
  Cookies: TPostVarList;
  HasPOST: Boolean;
  HasGET: Boolean;

procedure Init;
begin
  // Check for any POST or GET variables
  POSTVars := TPostVarList.Create;
  GETVars := TPostVarList.Create;  
  HasGET := GetHTTPVars(GETVars,vtGET);
  if GetEnvironmentVariable('REQUEST_METHOD') = 'POST' then 
  begin
    HasPOST := GetHTTPVars(POSTVars,vtPOST);
  end
  else HasPOST := false;  
  // Find the cookie!
  if GetEnvironmentVariable('HTTP_COOKIE') <> '' then
  begin
    GetHTTPVars(Cookies,vtCookie);
  end;
end;

procedure dumpPOST;
var
  i: Integer;
begin
  for i := 0 to POSTVars.Count -1 do
  begin
    writeln(POSTVars[i].key, '=', POSTVars[i].value);
  end;
end;

procedure CleanUp;
begin
  POSTVars.Clear;
  GETVars.Clear;
end;

begin
  writeln('Set-cookie: widget=value');  
  writeln('Content-Type: text/html',#10#13);    
  Init;  
  if HasPOST then dumpPOST;
  CleanUp;
end.