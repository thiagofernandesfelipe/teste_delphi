unit uConexaoDAO;

interface

uses
  FireDAC.Comp.Client, FireDAC.Stan.Def, System.SysUtils, IniFiles, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, Data.DB, FireDAC.DApt, FireDAC.VCLUI.Wait, Vcl.Dialogs;

type
  TConexaoDAO = class
  private
    FConn: TFDConnection;
    procedure ConfigurarConexao;
  public
    constructor Create;
    destructor Destroy; override;
    function GetConn: TFDConnection;
    function CriarQuery: TFDQuery;
  end;

implementation

procedure TConexaoDAO.ConfigurarConexao;
var
  IniFilePath: string;
  IniFile: TIniFile;
  Database, Username, Server, PortStr, Password, LibPath: string;
begin
  IniFilePath := ExtractFilePath(ParamStr(0)) + 'config.ini';

  if not FileExists(IniFilePath) then
  begin
    ShowMessage('Arquivo config.ini não encontrado em ' + IniFilePath);
    Exit;
  end;

  IniFile := TIniFile.Create(IniFilePath);
  try
    Database := IniFile.ReadString('Database', 'Database', '');
    Username := IniFile.ReadString('Database', 'Username', '');
    Server   := IniFile.ReadString('Database', 'Server', '');
    PortStr  := IniFile.ReadString('Database', 'Port', '');
    Password := IniFile.ReadString('Database', 'Password', '');
    LibPath  := IniFile.ReadString('Database', 'Library', '');

    if (Database = '') or (Username = '') or (Server = '') then
    begin
      ShowMessage('Informações de conexão incompletas no arquivo config.ini');
      Exit;
    end;

    FConn.Params.Clear;

    FConn.DriverName := 'MySQL';

    FConn.Params.Database                := Database;
    FConn.Params.UserName                := Username;
    FConn.Params.Password                := Password;
    FConn.Params.Values['Server']        := Server;
    FConn.Params.Values['Port']          := PortStr;
    FConn.Params.Values['CharacterSet']  := 'utf8mb4';
    FConn.Params.Values['ServerCharSet'] := 'utf8mb4';
    FConn.Params.Values['UseSSL']        := '0';

    if LibPath <> '' then
      FConn.Params.Values['VendorLib'] := LibPath;

    FConn.LoginPrompt := False;
  finally
    IniFile.Free;
  end;
end;



constructor TConexaoDAO.Create;
begin
  FConn := TFDConnection.Create(nil);
  try
    ConfigurarConexao;
    FConn.Connected := True;
  except
    on E: Exception do
    begin
      ShowMessage('Erro ao conectar no banco de dados: ' + E.Message);
      raise;
    end;
  end;
end;

function TConexaoDAO.CriarQuery: TFDQuery;
var
  VQuery: TFDQuery;
begin
  VQuery := TFDQuery.Create(nil);
  VQuery.Connection := FConn;
  Result := VQuery;
end;

destructor TConexaoDAO.Destroy;
begin
  FConn.Free;
  inherited;
end;

function TConexaoDAO.GetConn: TFDConnection;
begin
  Result := FConn;
end;

end.

