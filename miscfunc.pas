unit miscfunc;
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, StrUtils;

type
  TArray = array of string;
  PPostPair = ^TPostPair;
  TPostPair = record
    key: String;
    value: String;
  end;
  TPostVarList = class(TList)
  private
    function Get(Index: Integer): PPostPair;
  public
    destructor Destroy; override;
    function Add(key,value: String): Integer;
    procedure Delete(Index: Integer);
    procedure Clear;
    property Items[Index: Integer]: PPostPair read Get; default;
 end;
  
function explode(cDelimiter,  sValue : string; iCount : integer) : TArray;
function implode(cDelimiter: String; arr: TArray): String;
function inArray(sText: String; arr: TArray): Boolean;

implementation

function explode(cDelimiter,  sValue : string; iCount : integer) : TArray;
var
  s : string; i,p : integer;
begin
  s := sValue;
  i := 0;
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

function implode(cDelimiter: String; arr: TArray): String;
var
  i: integer;
begin
  Result := '';
  for i := Low(arr) to High(arr) do
  begin
    Result := Result + arr[i] + cDelimiter;
  end;
  Result := TrimRightSet(Result,[' ',cDelimiter[1]]);
end;

function inArray(sText: String; arr: TArray): Boolean;
var
  i: Integer;
begin
  Result := false;
  for i := Low(arr) to High(arr) do
  begin
    if sText = arr[i] then Result := true;
  end;
end;

{ TPostVarList }

function TPostVarList.Add(key,value: String): Integer;
var
  PostItem: PPostPair;
begin
  new(PostItem);
  PostItem^.key := key;
  PostItem^.value := value;
  Result := inherited Add(PostItem);
end;

function TPostVarList.Get(Index: Integer): PPostPair;
begin
  Result := PPostPair(inherited Get(Index));
end;

procedure TPostVarList.Clear;
var
  i: integer;
begin
  for i := Count-1 downto 0 do
    FreeMem(Items[i]);
  inherited Clear;
end;

procedure TPostVarList.Delete(Index: Integer);
begin
  FreeMem(Items[Index]);
  inherited Delete(Index);
end;

destructor TPostVarList.Destroy;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    FreeMem(Items[i]);
  inherited;
end;

end.