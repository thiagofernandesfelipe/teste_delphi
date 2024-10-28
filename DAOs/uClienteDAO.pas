unit uClienteDAO;

interface

uses
  FireDAC.Comp.Client, uClienteModel, System.SysUtils, uConexaoDAO, System.Generics.Collections;

type
  TClienteDAO = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function GetClienteByCodigo(ACodigo: Integer): TCliente;
  end;

implementation

{ TClienteDAO }

constructor TClienteDAO.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

function TClienteDAO.GetClienteByCodigo(ACodigo: Integer): TCliente;
var
  vQuery: TFDQuery;
  Cliente: TCliente;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FConnection;
    vQuery.SQL.Text   := 'select * from clientes where codigo = :codigo';
    vQuery.ParamByName('codigo').AsInteger := ACodigo;
    vQuery.Open;

    if not vQuery.IsEmpty then
    begin
      Cliente        := TCliente.Create;
      Cliente.Codigo := vQuery.FieldByName('codigo').AsInteger;
      Cliente.Nome   := vQuery.FieldByName('nome').AsString;
      Cliente.Cidade := vQuery.FieldByName('cidade').AsString;
      Cliente.UF     := vQuery.FieldByName('uf').AsString;
      Result         := Cliente;
    end
    else
      Result := nil;
  finally
    vQuery.Free;
  end;
end;

end.

