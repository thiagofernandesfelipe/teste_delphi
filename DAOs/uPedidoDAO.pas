unit uPedidoDAO;

interface

uses
  FireDAC.Comp.Client, uPedidoModel, uPedidoProdutoModel, System.SysUtils, uConexaoDAO, System.Classes;

type
  TPedidoDAO = class
  private
    FConnection: TFDConnection;
  public
    constructor Create(AConnection: TFDConnection);
    function GravarPedido(APedido: TPedido): Boolean;
    function CarregarPedido(ANumeroPedido: Integer): TPedido;
    function CancelarPedido(ANumeroPedido: Integer): Boolean;
    function GetNextPedidoNumero: Integer;
  end;

implementation

constructor TPedidoDAO.Create(AConnection: TFDConnection);
begin
  FConnection := AConnection;
end;

function TPedidoDAO.GetNextPedidoNumero: Integer;
var
  vQuery: TFDQuery;
begin
  vQuery := TFDQuery.Create(nil);
  try
    vQuery.Connection := FConnection;
    vQuery.SQL.Text   := 'select max(numeropedido) as max from pedidos';
    vQuery.Open;

    Result := vQuery.FieldByName('max').AsInteger + 1;
  finally
    vQuery.Free;
  end;
end;

function TPedidoDAO.GravarPedido(APedido: TPedido): Boolean;
var
  vPedidoQuery, vProdutoQuery: TFDQuery;
  vProduto: TPedidoProduto;
  PedidoExiste: Boolean;
begin
  Result := False;
  FConnection.StartTransaction;
  try
    vPedidoQuery := TFDQuery.Create(nil);
    try
      vPedidoQuery.Connection := FConnection;
      vPedidoQuery.SQL.Text   := 'select count(*) as total from pedidos'+
                                 ' where numeropedido = :numeropedido';

      vPedidoQuery.ParamByName('numeropedido').AsInteger := APedido.NumeroPedido;
      vPedidoQuery.Open;

      PedidoExiste := vPedidoQuery.FieldByName('total').AsInteger > 0;
    finally
      vPedidoQuery.Free;
    end;

    if PedidoExiste then
    begin
      vPedidoQuery := TFDQuery.Create(nil);
      try
        vPedidoQuery.Connection := FConnection;
        vPedidoQuery.SQL.Text := 'update pedidos'+
                                 ' set dataemissao    = :dataemissao,'+
                                 ' codigocliente      = :codigocliente,'+
                                 ' valortotal         = :valortotal' +
                                 ' where numeropedido = :numeropedido';

        vPedidoQuery.ParamByName('numeropedido').AsInteger  := APedido.NumeroPedido;
        vPedidoQuery.ParamByName('dataemissao').AsDateTime  := APedido.DataEmissao;
        vPedidoQuery.ParamByName('codigocliente').AsInteger := APedido.CodigoCliente;
        vPedidoQuery.ParamByName('valortotal').AsCurrency   := APedido.ValorTotal;
        vPedidoQuery.ExecSQL;
      finally
        vPedidoQuery.Free;
      end;

      vProdutoQuery := TFDQuery.Create(nil);
      try
        vProdutoQuery.Connection := FConnection;
        vProdutoQuery.SQL.Text   := 'delete from pedidoprodutos'+
                                    ' where numeropedido = :numeropedido';

        vProdutoQuery.ParamByName('numeropedido').AsInteger := APedido.NumeroPedido;
        vProdutoQuery.ExecSQL;
      finally
        vProdutoQuery.Free;
      end;
    end
    else
    begin
      vPedidoQuery := TFDQuery.Create(nil);
      try
        vPedidoQuery.Connection := FConnection;
        vPedidoQuery.SQL.Text := 'insert into pedidos (numeropedido, dataemissao, codigocliente, valortotal)' +
                                 ' values (:numeropedido, :dataemissao, :codigocliente, :valortotal)';

        vPedidoQuery.ParamByName('numeropedido').AsInteger  := APedido.NumeroPedido;
        vPedidoQuery.ParamByName('dataemissao').AsDateTime  := APedido.DataEmissao;
        vPedidoQuery.ParamByName('codigocliente').AsInteger := APedido.CodigoCliente;
        vPedidoQuery.ParamByName('valortotal').AsCurrency   := APedido.ValorTotal;
        vPedidoQuery.ExecSQL;
      finally
        vPedidoQuery.Free;
      end;
    end;

    vProdutoQuery := TFDQuery.Create(nil);
    try
      vProdutoQuery.Connection := FConnection;
      vProdutoQuery.SQL.Text := 'insert into pedidoprodutos (numeropedido, codigoproduto, quantidade, valorunitario, valortotal)' +
                                ' values (:numeropedido, :codigoproduto, :quantidade, :valorunitario, :valortotal)';

      for vProduto in APedido.Produtos do
      begin
        vProdutoQuery.ParamByName('numeropedido').AsInteger   := vProduto.NumeroPedido;
        vProdutoQuery.ParamByName('codigoproduto').AsInteger  := vProduto.CodigoProduto;
        vProdutoQuery.ParamByName('quantidade').AsInteger     := vProduto.Quantidade;
        vProdutoQuery.ParamByName('valorunitario').AsCurrency := vProduto.ValorUnitario;
        vProdutoQuery.ParamByName('valortotal').AsCurrency    := vProduto.ValorTotal;
        vProdutoQuery.ExecSQL;
      end;
    finally
      vProdutoQuery.Free;
    end;

    FConnection.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      FConnection.Rollback;
      raise Exception.Create('Erro ao gravar pedido: ' + E.Message);
    end;
  end;
end;


function TPedidoDAO.CarregarPedido(ANumeroPedido: Integer): TPedido;
var
  vPedidoQuery, vProdutoQuery: TFDQuery;
  Pedido: TPedido;
  PedidoProduto: TPedidoProduto;
begin
  Pedido := TPedido.Create;
  try
    vPedidoQuery := TFDQuery.Create(nil);
    try
      vPedidoQuery.Connection := FConnection;
      vPedidoQuery.SQL.Text   := 'select * from pedidos '+
                                 ' where numeropedido = :numeropedido';

      vPedidoQuery.ParamByName('numeropedido').AsInteger := ANumeroPedido;
      vPedidoQuery.Open;

      if not vPedidoQuery.IsEmpty then
      begin
        Pedido.NumeroPedido  := vPedidoQuery.FieldByName('numeropedido').AsInteger;
        Pedido.DataEmissao   := vPedidoQuery.FieldByName('dataemissao').AsDateTime;
        Pedido.CodigoCliente := vPedidoQuery.FieldByName('codigocliente').AsInteger;
        Pedido.ValorTotal    := vPedidoQuery.FieldByName('valortotal').AsCurrency;
      end
      else
        Exit(nil);
    finally
      vPedidoQuery.Free;
    end;

    vProdutoQuery := TFDQuery.Create(nil);
    try
      vProdutoQuery.Connection := FConnection;
      vProdutoQuery.SQL.Text := 'select * from pedidoprodutos'+
                                ' where numeropedido = :numeropedido';

      vProdutoQuery.ParamByName('numeropedido').AsInteger := ANumeroPedido;
      vProdutoQuery.Open;

      while not vProdutoQuery.Eof do
      begin
        PedidoProduto               := TPedidoProduto.Create;
        PedidoProduto.AutoInc       := vProdutoQuery.FieldByName('autoinc').AsInteger;
        PedidoProduto.NumeroPedido  := vProdutoQuery.FieldByName('numeropedido').AsInteger;
        PedidoProduto.CodigoProduto := vProdutoQuery.FieldByName('codigoproduto').AsInteger;
        PedidoProduto.Quantidade    := vProdutoQuery.FieldByName('quantidade').AsInteger;
        PedidoProduto.ValorUnitario := vProdutoQuery.FieldByName('valorunitario').AsCurrency;
        PedidoProduto.ValorTotal    := vProdutoQuery.FieldByName('valortotal').AsCurrency;
        Pedido.Produtos.Add(PedidoProduto);
        vProdutoQuery.Next;
      end;
    finally
      vProdutoQuery.Free;
    end;

    Result := Pedido;
  except
    Pedido.Free;
    raise;
  end;
end;

function TPedidoDAO.CancelarPedido(ANumeroPedido: Integer): Boolean;
var
  vQuery: TFDQuery;
begin
  Result := False;
  FConnection.StartTransaction;
  try
    vQuery := TFDQuery.Create(nil);
    try
      vQuery.Connection := FConnection;
      vQuery.SQL.Text   := 'delete from pedidoprodutos'+
                           ' where numeropedido = :numeropedido';

      vQuery.ParamByName('numeropedido').AsInteger := ANumeroPedido;
      vQuery.ExecSQL;
    finally
      vQuery.Free;
    end;

    vQuery := TFDQuery.Create(nil);
    try
      vQuery.Connection := FConnection;
      vQuery.SQL.Text   := 'delete from pedidos '+
                           ' where numeropedido = :numeropedido';

      vQuery.ParamByName('numeropedido').AsInteger := ANumeroPedido;
      vQuery.ExecSQL;
    finally
      vQuery.Free;
    end;

    FConnection.Commit;
    Result := True;
  except
    on E: Exception do
    begin
      FConnection.Rollback;
      raise Exception.Create('Erro ao cancelar pedido: ' + E.Message);
    end;
  end;
end;

end.

