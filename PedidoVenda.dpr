program PedidoVenda;

uses
  Vcl.Forms,
  uConexaoDAO in 'DAOs\uConexaoDAO.pas',
  uClienteModel in 'Models\uClienteModel.pas',
  uPedidoModel in 'Models\uPedidoModel.pas',
  uProdutoModel in 'Models\uProdutoModel.pas',
  uClienteDAO in 'DAOs\uClienteDAO.pas',
  uPedidoDAO in 'DAOs\uPedidoDAO.pas',
  uPedidoController in 'Controllers\uPedidoController.pas',
  uPedidoProdutoModel in 'Models\uPedidoProdutoModel.pas',
  uProdutoDAO in 'DAOs\uProdutoDAO.pas',
  uFrmPedidoVendaView in 'Views\uFrmPedidoVendaView.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFrmPedidoVendaView, FrmPedidoVendaView);
  Application.Run;
end.
