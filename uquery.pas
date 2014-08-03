unit uquery;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb;

implementation

{function CreateQuery (Table: TTableInfo): string;
var
  i: integer;
begin
  Result := 'SELECT';
  for i := 0 to high (Table.ColumnInfos) - 1 do begin
    Result += Format ('%s.%s, ', [Table.TableName, Table.ColumnInfos[i].ColumnName]);
  end;
  Result += Format ('%s.%s', [Table.TableName, Table.ColumnInfos[high (Table.ColumnInfos)].ColumnName]);
  Result += 'FROM ' + Table.TableName;
end; }

end.

