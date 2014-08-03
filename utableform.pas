unit utableform;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqldb, db, FileUtil, Forms, Controls, Graphics, Dialogs,
  DBGrids, StdCtrls, metadata, filters;

type

  { TTableForm }

  TTableForm = class(TForm)
    BFilter: TButton;
    Datasource: TDatasource;
    DBGrid: TDBGrid;
    FScrollBox: TScrollBox;
    SQLQuery: TSQLQuery;
    procedure BFilterClick(Sender: TObject);
  private
    TTable: TTableInfo;
    { private declarations }
  public
    { public declarations }
  end;

var
  TableForm: TTableForm;
  FFilter: TFilter;

implementation

{$R *.lfm}

{ TTableForm }

procedure TTableForm.BFilterClick(Sender: TObject);
begin
  FFilter.CreateFilter (FScrollBox);
end;

end.

