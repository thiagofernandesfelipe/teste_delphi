unit uPedidoModel;

interface

uses
  System.Generics.Collections, uPedidoProdutoModel;

type
  TPedido = class
  private
    FNumeroPedido: Integer;
    FDataEmissao: TDateTime;
    FCodigoCliente: Integer;
    FValorTotal: Currency;
    FProdutos: TObjectList<TPedidoProduto>;
  public
    constructor Create;
    destructor Destroy; override;
    property NumeroPedido: Integer read FNumeroPedido write FNumeroPedido;
    property DataEmissao: TDateTime read FDataEmissao write FDataEmissao;
    property CodigoCliente: Integer read FCodigoCliente write FCodigoCliente;
    property ValorTotal: Currency read FValorTotal write FValorTotal;
    property Produtos: TObjectList<TPedidoProduto> read FProdutos;
  end;

implementation

constructor TPedido.Create;
begin
  FProdutos := TObjectList<TPedidoProduto>.Create(True);
end;

destructor TPedido.Destroy;
begin
  FProdutos.Free;
  inherited;
end;

end.

