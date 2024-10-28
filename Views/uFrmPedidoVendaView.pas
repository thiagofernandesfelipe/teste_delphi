unit uFrmPedidoVendaView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, ExtCtrls, uPedidoController, uProdutoModel, uPedidoProdutoModel,
  uClienteModel, FireDAC.Phys.MySQLDef, FireDAC.Stan.Intf, FireDAC.Phys,
  FireDAC.Phys.MySQL, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TFrmPedidoVendaView = class(TForm)
    edtCodigoCliente: TEdit;
    lblCodigoCliente: TLabel;
    lblNomeCliente: TLabel;
    btnBuscarPedido: TButton;
    btnCancelarPedido: TButton;
    grdProdutos: TStringGrid;
    edtCodigoProduto: TEdit;
    edtQuantidade: TEdit;
    edtValorUnitario: TEdit;
    lblCodigoProduto: TLabel;
    lblQuantidade: TLabel;
    lblValorUnitario: TLabel;
    btnInserirProduto: TButton;
    btnGravarPedido: TButton;
    lblValorTotal: TLabel;
    lblValorTotalValor: TLabel;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    lblDescricaoProduto: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnInserirProdutoClick(Sender: TObject);
    procedure btnGravarPedidoClick(Sender: TObject);
    procedure grdProdutosKeyDown(Sender: TObject; var Tecla: Word;
      Shift: TShiftState);
    procedure btnBuscarPedidoClick(Sender: TObject);
    procedure btnCancelarPedidoClick(Sender: TObject);
    procedure edtCodigoClienteChange(Sender: TObject);
    procedure edtCodigoProdutoChange(Sender: TObject);
    procedure edtFieldsKeyDown(Sender: TObject; var Tecla: Word;
      Shift: TShiftState);
  private
    FControlador: TPedidoController;
    FIndiceEdicao: Integer;
    FPedidoNovo: Boolean;
    procedure AtualizarValorTotal;
    procedure CarregarPedido(NumeroPedido: Integer);
    procedure LimparCamposProduto;
    procedure LimparPedido;
    procedure AtualizarEstadoGravarPedido;
  public
  end;

var
  FrmPedidoVendaView: TFrmPedidoVendaView;

implementation

{$R *.dfm}

procedure TFrmPedidoVendaView.AtualizarValorTotal;
begin
  lblValorTotalValor.Caption := FormatFloat('R$ ###,##0.00',FControlador.Pedido.ValorTotal);
end;

procedure TFrmPedidoVendaView.AtualizarEstadoGravarPedido;
begin
  if FPedidoNovo then
    btnGravarPedido.Caption := 'Gravar Pedido'
  else
    btnGravarPedido.Caption := 'Atualizar Pedido';
end;

procedure TFrmPedidoVendaView.btnBuscarPedidoClick(Sender: TObject);
var
  NumeroPedido: String;
begin
  if InputQuery('Carregar Pedido', 'Informe o número do pedido:', NumeroPedido) then
  begin
    CarregarPedido(StrToInt(NumeroPedido));
  end;
end;

procedure TFrmPedidoVendaView.btnCancelarPedidoClick(Sender: TObject);
var
  NumeroPedido: String;
begin
  if InputQuery('Cancelar Pedido', 'Informe o número do pedido:', NumeroPedido) then
  begin
    if FControlador.CancelarPedido(StrToInt(NumeroPedido)) then
    begin
      ShowMessage('Pedido cancelado com sucesso.');
      LimparPedido;
    end
    else
      ShowMessage('Erro ao cancelar pedido.');
  end;
end;

procedure TFrmPedidoVendaView.btnGravarPedidoClick(Sender: TObject);
begin
  if FControlador.GravarPedido then
  begin
    if FPedidoNovo then
      ShowMessage('Pedido gravado com sucesso.')
    else
      ShowMessage('Pedido atualizado com sucesso.');
    LimparPedido;
  end
  else
    ShowMessage('Erro ao gravar pedido.');
end;

procedure TFrmPedidoVendaView.btnInserirProdutoClick(Sender: TObject);
var
  Produto: TProduto;
  Quantidade: Integer;
  ValorUnitario, ValorTotal: Currency;
  Indice: Integer;
begin
  Produto := FControlador.GetProduto(StrToIntDef(edtCodigoProduto.Text, 0));
  if not Assigned(Produto) then
  begin
    ShowMessage('Produto não encontrado.');
    Exit;
  end;

  Quantidade := StrToIntDef(edtQuantidade.Text, 1);
  if edtValorUnitario.Text <> '' then
    ValorUnitario := StrToCurrDef(edtValorUnitario.Text, Produto.PrecoVenda)
  else
    ValorUnitario := Produto.PrecoVenda;
  ValorTotal := Quantidade * ValorUnitario;

  if FIndiceEdicao = -1 then
  begin
    FControlador.AdicionarProduto(Produto.Codigo, Quantidade,
      ValorUnitario, ValorTotal);

    with grdProdutos do
    begin
      RowCount := RowCount + 1;
      Cells[0, RowCount - 1] := Produto.Codigo.ToString;
      Cells[1, RowCount - 1] := Produto.Descricao;
      Cells[2, RowCount - 1] := Quantidade.ToString;
      Cells[3, RowCount - 1] := FormatFloat('###,##0.00', ValorUnitario);
      Cells[4, RowCount - 1] := FormatFloat('###,##0.00', ValorTotal);
    end;
  end
  else
  begin
    FControlador.AtualizarProduto(FIndiceEdicao, Quantidade, ValorUnitario);

    Indice := FIndiceEdicao + 1;
    grdProdutos.Cells[2, Indice] := Quantidade.ToString;
    grdProdutos.Cells[3, Indice] := FormatFloat('###,##0.00', ValorUnitario);
    grdProdutos.Cells[4, Indice] := FormatFloat('###,##0.00', ValorTotal);

    FIndiceEdicao := -1;
    edtCodigoProduto.Enabled := True;
    btnInserirProduto.Caption := 'Inserir Produto';
  end;

  AtualizarValorTotal;
  LimparCamposProduto;
end;

procedure TFrmPedidoVendaView.CarregarPedido(NumeroPedido: Integer);
var
  i: Integer;
  Produto: TProduto;
  PedidoProduto: TPedidoProduto;
begin
  LimparPedido;
  if FControlador.CarregarPedido(NumeroPedido) then
  begin
    FPedidoNovo := False;
    AtualizarEstadoGravarPedido;

    edtCodigoCliente.Text := FControlador.Pedido.CodigoCliente.ToString;

    edtCodigoClienteChange(nil);

    for i := 0 to FControlador.Pedido.Produtos.Count - 1 do
    begin
      PedidoProduto := FControlador.Pedido.Produtos[i];
      Produto := FControlador.GetProduto(PedidoProduto.CodigoProduto);
      with grdProdutos do
      begin
        RowCount := RowCount + 1;
        Cells[0, RowCount - 1] := PedidoProduto.CodigoProduto.ToString;

        if Assigned(Produto) then
          Cells[1, RowCount - 1] := Produto.Descricao
        else
          Cells[1, RowCount - 1] := '';

        Cells[2, RowCount - 1] := PedidoProduto.Quantidade.ToString;
        Cells[3, RowCount - 1] := FormatFloat('###,##0.00', PedidoProduto.ValorUnitario);
        Cells[4, RowCount - 1] := FormatFloat('###,##0.00', PedidoProduto.ValorTotal);
      end;
    end;

    AtualizarValorTotal;
  end
  else
    ShowMessage('Pedido não encontrado.');
end;

procedure TFrmPedidoVendaView.edtCodigoClienteChange(Sender: TObject);
var
  CodigoCliente: Integer;
  Cliente: TCliente;
begin
  CodigoCliente := StrToIntDef(edtCodigoCliente.Text, 0);
  if CodigoCliente > 0 then
  begin
    Cliente := FControlador.GetCliente(CodigoCliente);
    if Assigned(Cliente) then
    begin
      lblNomeCliente.Caption            := Cliente.Nome;
      FControlador.Pedido.CodigoCliente := CodigoCliente;
    end
    else
    begin
      lblNomeCliente.Caption            := 'Cliente não encontrado';
      FControlador.Pedido.CodigoCliente := 0;
    end;
  end
  else
  begin
    lblNomeCliente.Caption            := '';
    FControlador.Pedido.CodigoCliente := 0;
  end;

  btnBuscarPedido.Visible   := edtCodigoCliente.Text = '';
  btnCancelarPedido.Visible := edtCodigoCliente.Text = '';
end;

procedure TFrmPedidoVendaView.edtCodigoProdutoChange(Sender: TObject);
var
  CodigoProduto: Integer;
  Produto: TProduto;
begin
  CodigoProduto := StrToIntDef(edtCodigoProduto.Text, 0);
  if CodigoProduto > 0 then
  begin
    Produto := FControlador.GetProduto(CodigoProduto);
    if Assigned(Produto) then
    begin
      lblDescricaoProduto.Caption := Produto.Descricao;
      if edtValorUnitario.Text = '' then
        edtValorUnitario.Text := FormatFloat('###,##0.00', Produto.PrecoVenda);
    end
    else
    begin
      lblDescricaoProduto.Caption := 'Produto não encontrado';
      edtValorUnitario.Clear;
    end;
  end
  else
  begin
    lblDescricaoProduto.Caption := '';
    edtValorUnitario.Clear;
  end;
end;

procedure TFrmPedidoVendaView.edtFieldsKeyDown(Sender: TObject; var Tecla: Word;
  Shift: TShiftState);
begin
  if (Tecla = VK_ESCAPE) and (FIndiceEdicao <> -1) then
  begin
    LimparCamposProduto;
    Tecla := 0;
  end;
end;

procedure TFrmPedidoVendaView.FormCreate(Sender: TObject);
begin
  FControlador  := TPedidoController.Create;
  FIndiceEdicao := -1;
  FPedidoNovo   := True;
  AtualizarEstadoGravarPedido;
  with grdProdutos do
  begin
    ColCount := 5;
    Cells[0, 0] := 'Código';
    Cells[1, 0] := 'Descrição';
    Cells[2, 0] := 'Quantidade';
    Cells[3, 0] := 'Valor Unitário';
    Cells[4, 0] := 'Valor Total';
  end;
end;

procedure TFrmPedidoVendaView.grdProdutosKeyDown(Sender: TObject; var Tecla: Word;
  Shift: TShiftState);
var
  Indice: Integer;
begin
  Indice := grdProdutos.Row;
  if (Tecla = VK_DELETE) and (Indice > 0) then
  begin
    if MessageDlg('Deseja realmente excluir este produto?', mtConfirmation,
      [mbYes, mbNo], 0) = mrYes then
    begin
      FControlador.RemoverProduto(Indice - 1);
      grdProdutos.Rows[Indice].Clear;

      if Indice < grdProdutos.RowCount - 1 then
        grdProdutos.Rows[Indice].Assign(grdProdutos.Rows[grdProdutos.RowCount - 1]);

      grdProdutos.RowCount := grdProdutos.RowCount - 1;
      AtualizarValorTotal;
    end;
  end
  else if (Tecla = VK_RETURN) and (Indice > 0) then
  begin
    FIndiceEdicao               := Indice - 1;
    edtCodigoProduto.Text       := grdProdutos.Cells[0, Indice];
    lblDescricaoProduto.Caption := grdProdutos.Cells[1, Indice];
    edtQuantidade.Text          := grdProdutos.Cells[2, Indice];
    edtValorUnitario.Text       := grdProdutos.Cells[3, Indice];
    edtCodigoProduto.Enabled    := False;
    btnInserirProduto.Caption   := 'Atualizar Produto';
    edtQuantidade.SetFocus;
  end;
end;

procedure TFrmPedidoVendaView.LimparCamposProduto;
begin
  edtCodigoProduto.Clear;
  edtValorUnitario.Clear;
  edtQuantidade.Text          := '1';
  lblDescricaoProduto.Caption := '';
  edtCodigoProduto.Enabled    := True;
  btnInserirProduto.Caption   := 'Inserir Produto';
  FIndiceEdicao               := -1;
  edtCodigoProduto.SetFocus;
end;

procedure TFrmPedidoVendaView.LimparPedido;
begin
  FPedidoNovo := True;
  AtualizarEstadoGravarPedido;
  edtCodigoCliente.Clear;
  lblNomeCliente.Caption := '';
  grdProdutos.RowCount   := 1;
  if grdProdutos.RowCount > 1 then
    grdProdutos.Rows[1].Clear;
  FControlador.NovoPedido;
  AtualizarValorTotal;
end;

end.

