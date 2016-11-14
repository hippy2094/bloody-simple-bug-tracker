program bsbt;
{$mode objfpc}{$H+}
uses Dos, Classes, SysUtils, miscfunc, dzurl;

var
  POSTVars: TPostVarList;
  GETVars: TPostVarList;
  HasPOST: Boolean;
  HasGET: Boolean;

function POST(var pv: TPostVarList): Boolean;
var
  postVar: String;
  c: Char;
  i: Integer;
  postItems, pair: TArray;
  lTmp, rTmp: String;
begin
  postVar := '';
  Result := false;
  while not eof(input) do
  begin
    read(c);
    postVar := postVar + c;
  end;    
  if postVar <> '' then 
  begin
    postItems := explode('&',postVar,0);
    for i := 0 to High(postItems) do
    begin
      pair := explode('=',postItems[i],0);
      pv.Add(lTmp,rTmp);
    end;
    if pv.Count > 0 then Result := true;
  end;
end;

function GET(var pv: TPostVarList): Boolean;
var
  items, pair: TArray;
  i: Integer;
  qs: String;
begin
  qs := GetEnv('QUERY_STRING');
  Result := false;  
  if qs <> '' then   
  begin
    items := explode('&',qs,0);
    for i := 0 to High(items) do
    begin
      pair := explode('=',items[i],0);
      pv.Add(pair[0],UrlDecode(pair[1]));
    end;
    if pv.Count > 0 then Result := true;
  end;  
end;

procedure Init;
begin
  POSTVars := TPostVarList.Create;
  GETVars := TPostVarList.Create;
  HasPOST := POST(POSTVars);
  HasGET := GET(GETVars);
end;

procedure CleanUp;
begin
  POSTVars.Clear;
  GETVars.Clear;
end;

begin
  Init;
end.