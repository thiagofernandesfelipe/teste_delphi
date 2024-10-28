unit uPedidoController;

interface

uses
  uPedidoModel, uPedidoDAO, uConexaoDAO, uProdutoDAO, uProdutoModel,
  uPedidoProdutoModel, uClienteDAO, uClienteModel, System.SysUtils;

type
  TPedidoController = class
  private
    FPedido: TPedido;
    FPedidoDAO: TPedidoDAO;
    FProdutoDAO: TProdutoDAO;
    FClienteDAO: TClienteDAO;
    FConexaoDAO: TConexaoDAO;
  public
    constructor Create;
    destructor Destroy; override;
    procedure NovoPedido;
    function GravarPedido: Boolean;
    function CarregarPedido(ANumeroPedido: Integer): Boolean;
    function CancelarPedido(ANumeroPedido: Integer): Boolean;
    procedure AdicionarProduto(ACodigoProduto, AQuantidade: Integer;
      AValorUnitario, AValorTotal: Currency);
    procedure RemoverProduto(AIndex: Integer);
    procedure AtualizarProduto(AIndex, AQuantidade: Integer;
      AValorUnitario: Currency);
    function GetProduto(ACodigoProduto: Integer): TProduto;
    function GetCliente(ACodigoCliente: Integer): TCliente;
    property Pedido: TPedido read FPedido;
  end;

implementation

constructor TPedidoController.Create;
begin
  FConexaoDAO := TConexaoDAO.Create;
  FPedidoDAO  := TPedidoDAO.Create(FConexaoDAO.GetConn);
  FProdutoDAO := TProdutoDAO.Create(FConexaoDAO.GetConn);
  FClienteDAO := TClienteDAO.Create(FConexaoDAO.GetConn);

  FPedido               := TPedido.Create;
  FPedido.NumeroPedido  := FPedidoDAO.GetNextPedidoNumero;
  FPedido.DataEmissao   := Now;
  FPedido.CodigoCliente := 0;
end;

destructor TPedidoController.Destroy;
begin
  FPedido.Free;
  FPedidoDAO.Free;
  FProdutoDAO.Free;
  FClienteDAO.Free;
  FConexaoDAO.Free;
  inherited;
end;

procedure TPedidoController.NovoPedido;
begin
  FPedido.Free;
  FPedido               := TPedido.Create;
  FPedido.NumeroPedido  := FPedidoDAO.GetNextPedidoNumero;
  FPedido.DataEmissao   := Now;
  FPedido.CodigoCliente := 0;
end;

function TPedidoController.GravarPedido: Boolean;
begin
  Result := FPedidoDAO.GravarPedido(FPedido);
end;

function TPedidoController.CarregarPedido(ANumeroPedido: Integer): Boolean;
var
  PedidoCarregado: TPedido;
begin
  PedidoCarregado := FPedidoDAO.CarregarPedido(ANumeroPedido);
  if Assigned(PedidoCarregado) then
  begin
    FPedido.Free;
    FPedido := PedidoCarregado;
    Result := True;
  end
  else
    Result := False;
end;

function TPedidoController.CancelarPedido(ANumeroPedido: Integer): Boolean;
begin
  Result := FPedidoDAO.CancelarPedido(ANumeroPedido);
end;

procedure TPedidoController.AdicionarProduto(ACodigoProduto, AQuantidade: Integer;
  AValorUnitario, AValorTotal: Currency);
var
  PedidoProduto: TPedidoProduto;
begin
  PedidoProduto               := TPedidoProduto.Create;
  PedidoProduto.NumeroPedido  := FPedido.NumeroPedido;
  PedidoProduto.CodigoProduto := ACodigoProduto;
  PedidoProduto.Quantidade    := AQuantidade;
  PedidoProduto.ValorUnitario := AValorUnitario;
  PedidoProduto.ValorTotal    := AValorTotal;

  FPedido.Produtos.Add(PedidoProduto);
  FPedido.ValorTotal := FPedido.ValorTotal + AValorTotal;
end;

procedure TPedidoController.RemoverProduto(AIndex: Integer);
var
  ValorTotalProduto: Currency;
begin
  ValorTotalProduto := FPedido.Produtos[AIndex].ValorTotal;
  FPedido.Produtos.Delete(AIndex);
  FPedido.ValorTotal := FPedido.ValorTotal - ValorTotalProduto;
end;

procedure TPedidoController.AtualizarProduto(AIndex, AQuantidade: Integer;
  AValorUnitario: Currency);
var
  PedidoProduto: TPedidoProduto;
  ValorTotalAnterior, ValorTotalNovo: Currency;
begin
  PedidoProduto      := FPedido.Produtos[AIndex];
  ValorTotalAnterior := PedidoProduto.ValorTotal;

  PedidoProduto.Quantidade    := AQuantidade;
  PedidoProduto.ValorUnitario := AValorUnitario;
  PedidoProduto.ValorTotal    := AQuantidade * AValorUnitario;

  ValorTotalNovo     := PedidoProduto.ValorTotal;
  FPedido.ValorTotal := FPedido.ValorTotal - ValorTotalAnterior + ValorTotalNovo;
end;

function TPedidoController.GetProduto(ACodigoProduto: Integer): TProduto;
begin
  Result := FProdutoDAO.GetProdutoByCodigo(ACodigoProduto);
end;

function TPedidoController.GetCliente(ACodigoCliente: Integer): TCliente;
begin
  Result := FClienteDAO.GetClienteByCodigo(ACodigoCliente);
end;

end.

