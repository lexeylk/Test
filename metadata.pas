unit metadata;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, db, sqldb, DBGrids, Dialogs;

type

  strings = array of string;

  TColumnInfo = record
    ColumnName: string;
    ColumnCaption: string;
    Reference: boolean;
    ReferenceTable: string;
    ReferenceName: string;
    Size: integer;
    FieldType: TFieldType;
  end;
  TColumnInfos = array of TColumnInfo;

  TTableInfo = class
    ColumnInfos: TColumnInfos;
    TableCaption: string;
    TableName: string;
    constructor Create (aCaption, aName: string);
    function GetColumnCaption: strings;
    procedure SendQuery (SQLQuery: TSQLQuery);
    procedure Show (SQLQuery: TSQLQuery; DBGrid: TDBGrid);
    function CreateQuery: string;
    //function GetTableName (aColumnName): string;
    procedure SetCaptions (DBGrid: TDBGrid);
    function AddColumn (aName, aCaption, aReferenceColumn: string;
      aSize: integer; aFieldType: TFieldType):TTableInfo;
  end;

  //TTableInfos =

  TListOfTable = class
    TableInfos: array of TTableInfo;
    constructor Create();
    function AddTable (aCaption, aName: string): TTableInfo;
    function GetTableCaption: strings;
  end;

implementation

constructor TTableInfo.Create (aCaption, aName: string);
begin
  TableCaption := aCaption;
  TableName := aName;
end;

function TTableInfo.AddColumn(aName, aCaption, aReferenceColumn: string;
  aSize: integer; aFieldType: TFieldType): TTableInfo;
begin
  SetLength (ColumnInfos, length (ColumnInfos) + 1);
  with ColumnInfos[high (ColumnInfos)] do begin
    ColumnName := aName;
    ColumnCaption := aCaption;
    if (aReferenceColumn <> '') then Reference := true;
    if (Reference) then begin
      ReferenceName := aReferenceColumn;
      ReferenceTable := Copy (aName, 1, length (aName) - 3) + 's';
    end;
    Size := aSize;
    FieldType := aFieldType;
  end;
  Result := self;
end;

function TListOfTable.AddTable (aCaption, aName: string): TTableInfo;
begin
  Result := TTableInfo.Create (aCaption, aName);
  SetLength (TableInfos, length (TableInfos) + 1);
  TableInfos[high (TableInfos)] := Result;
end;

constructor TListOfTable.Create ();
begin
  AddTable ('Преподаватели', 'Professors').
    AddColumn ('Name', 'Преподаватель', '', 200, ftString);
  AddTable ('Предметы', 'Subjects').
    AddColumn ('Name', 'Предмет', '', 400, ftString);
  AddTable ('Кабинеты', 'Rooms').
    AddColumn ('Name', 'Кабинет', '', 100, ftString).
    AddColumn ('Room_size', 'Вместимость', '', 200, ftInteger);
  AddTable ('Группы', 'Groups').
    AddColumn ('Name', 'Группа', '', 100, ftString).
    AddColumn ('Group_size', 'Количество человек', '', 100, ftInteger);
  AddTable ('Расписание', 'Schedule_items').
    AddColumn ('Professor_id', 'Преподаватель', 'Name', 200, ftString).
    AddColumn ('Subject_id', 'Предмет', 'Name', 400, ftString).
    AddColumn ('Subject_type_id', 'Тип', 'Name', 30, ftString).
    AddColumn ('Room_id', 'Кабинет', 'Name', 100, ftString).
    AddColumn ('Group_id', 'Группа', 'Name', 100, ftString).
    AddColumn ('Day_id', 'День недели', 'Name', 100, ftDate);
end;

function TTableInfo.GetColumnCaption: strings;
var
  i: integer;
begin
  SetLength (Result, length (ColumnInfos));
  for i := 0 to high (ColumnInfos) do
    Result[i] := ColumnInfos[i].ColumnCaption;
end;

function TListOfTable.GetTableCaption: strings;
var
  i: integer;
begin
  SetLength (Result, length (TableInfos));
  for i := 0 to high (TableInfos) do
    Result[i] := TableInfos[i].TableCaption;
end;

procedure TTableInfo.SendQuery (SQLQuery: TSQLQuery);
begin
  SQLQuery.Close;
  SQLQuery.Params.Clear;
  SQLQuery.SQL.Text := CreateQuery;
  SQLQuery.Open;
end;

{function TTableInfo.GetTableName (aColumnName): string;
begin

end; }

function TTableInfo.CreateQuery: string;
var
  i: integer;
begin
  Result := 'Select ';
  for i := 0 to High(ColumnInfos) do begin
    if ColumnInfos[i].Reference then
      Result += ColumnInfos[i].ReferenceTable + '.' +  ColumnInfos[i].ReferenceName
    else
      Result += TableName + '.' + ColumnInfos[i].ColumnName + ' ';
    if i < High(ColumnInfos) then Result += ', ';
  end;
  Result += ' From ' + TableName;
  for i := 0 to High(ColumnInfos) do begin
    if not ColumnInfos[i].Reference then continue;
    Result += ' inner join ';
    Result += ColumnInfos[i].ReferenceTable;
    Result += ' on ' + TableName + '.' + ColumnInfos[i].ColumnName + ' = ' + ColumnInfos[i].ReferenceTable + '.ID';
  end;
  Result += ';';
  //ShowMessage (Result);
end;

procedure TTableInfo.SetCaptions (DBGrid: TDBGrid);
var
  i: Integer;
begin
  for i := 0 to high(ColumnInfos) do begin
    DBGrid.Columns[i].Title.Caption := ColumnInfos[i].ColumnCaption;
    DBGrid.Columns[i].Width := ColumnInfos[i].Size;
  end;
end;

procedure TTableInfo.Show(SQLQuery: TSQLQuery; DBGrid: TDBGrid);
begin
  SendQuery(SQLQuery);
  SetCaptions(DBGrid);
end;
end.

