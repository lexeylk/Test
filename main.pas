unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IBConnection, sqldb, FileUtil, Forms, Controls, Graphics,
  Dialogs, Menus, metadata, utableform, DBGrids, StdCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    DBConnection: TIBConnection;
    MainMenu: TMainMenu;
    MTables: TMenuItem;
    MAbout: TMenuItem;
    MFile: TMenuItem;
    SQLTransaction: TSQLTransaction;
    procedure FormCreate(Sender: TObject);
    procedure MAboutClick(Sender: TObject);
    procedure NewFormCreate (Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  ListOfTables: TListOfTable;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MAboutClick(Sender: TObject);
begin
  ShowMessage ('Цой Алексей Б8103а');
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: integer;
  Names: strings;
  MenuItem: TMenuItem;
begin
  ListOfTables := TListOfTable.Create;
  MainForm.DBConnection.Connected := True;
  Names := ListOfTables.GetTableCaption;
  for i := 0 to high (Names) do begin
    MenuItem := TMenuItem.Create (MainMenu);
    MenuItem.Caption := Names[i];
    MainMenu.Items.Items[1].Add (MenuItem);
    MenuItem.Tag := i;
    MenuItem.OnClick := @NewFormCreate;
  end;
end;

procedure TMainForm.NewFormCreate (Sender: TObject);
var
  NewForm: TTableForm;
begin
  NewForm := TTableForm.Create(MainForm);
  NewForm.SQLQuery.DataBase := DBConnection;
  NewForm.SQLQuery.Transaction := SQLTransaction;
  NewForm.Caption := ListOfTables.GetTableCaption[TMenuItem(Sender).Tag];
  NewForm.Show;
  ListOfTables.TableInfos[TMenuItem(Sender).Tag].Show(NewForm.SQLQuery, NewForm.DBGrid);
end;


end.

