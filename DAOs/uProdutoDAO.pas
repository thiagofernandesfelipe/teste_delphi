unit uProdutoDAO;

interface

uses
  FireDAC.Comp.Client, uProdutoModel, System.SysUtils, uConexaoDAO, System.Generics.Collections;

type
  TProdutoDAO = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function GetProdutoByCodigo(ACodigo: Integer): TProduto;
  end;

implementation

constructor TProdutoDAO.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

function TProdutoDAO.GetProdutoByCodigo(ACodigo: Integer): TProduto;
var
  vQuery: TFDQuery;
  Produto: TProduto;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FConnection;
    vQuery.SQL.Text := 'select * from produtos where codigo = :codigo';

    vQuery.ParamByName('codigo').AsInteger := ACodigo;
    vQuery.Open;

    if not vQuery.IsEmpty then
    begin
      Produto            := TProduto.Create;
      Produto.Codigo     := vQuery.FieldByName('codigo').AsInteger;
      Produto.Descricao  := vQuery.FieldByName('descricao').AsString;
      Produto.PrecoVenda := vQuery.FieldByName('precovenda').AsCurrency;
      Result := Produto;
    end
    else
      Result := nil;
  finally
    vQuery.Free;
  end;
end;

end.

