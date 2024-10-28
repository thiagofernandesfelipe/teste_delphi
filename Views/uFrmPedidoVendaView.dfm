object FrmPedidoVendaView: TFrmPedidoVendaView
  Left = 200
  Top = 200
  Caption = 'Pedido de Venda'
  ClientHeight = 535
  ClientWidth = 784
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 13
  object lblCodigoCliente: TLabel
    Left = 34
    Top = 15
    Width = 73
    Height = 13
    Caption = 'C'#243'digo Cliente:'
  end
  object lblNomeCliente: TLabel
    Left = 240
    Top = 15
    Width = 3
    Height = 13
  end
  object lblCodigoProduto: TLabel
    Left = 29
    Top = 48
    Width = 78
    Height = 13
    Caption = 'C'#243'digo Produto:'
  end
  object lblDescricaoProduto: TLabel
    Left = 240
    Top = 48
    Width = 3
    Height = 13
  end
  object lblQuantidade: TLabel
    Left = 47
    Top = 79
    Width = 60
    Height = 13
    Caption = 'Quantidade:'
  end
  object lblValorUnitario: TLabel
    Left = 192
    Top = 80
    Width = 68
    Height = 13
    Caption = 'Valor Unit'#225'rio:'
  end
  object lblValorTotal: TLabel
    Left = 552
    Top = 496
    Width = 96
    Height = 23
    Caption = 'Valor Total:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblValorTotalValor: TLabel
    Left = 664
    Top = 498
    Width = 64
    Height = 23
    Caption = 'R$ 0,00'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtCodigoCliente: TEdit
    Left = 112
    Top = 12
    Width = 121
    Height = 21
    TabOrder = 0
    OnChange = edtCodigoClienteChange
  end
  object btnBuscarPedido: TButton
    Left = 564
    Top = 10
    Width = 100
    Height = 25
    Caption = 'Buscar Pedido'
    TabOrder = 1
    OnClick = btnBuscarPedidoClick
  end
  object btnCancelarPedido: TButton
    Left = 676
    Top = 10
    Width = 100
    Height = 25
    Caption = 'Cancelar Pedido'
    TabOrder = 2
    OnClick = btnCancelarPedidoClick
  end
  object edtCodigoProduto: TEdit
    Left = 112
    Top = 44
    Width = 121
    Height = 21
    TabOrder = 3
    OnChange = edtCodigoProdutoChange
    OnKeyDown = edtFieldsKeyDown
  end
  object edtQuantidade: TEdit
    Left = 112
    Top = 76
    Width = 57
    Height = 21
    TabOrder = 4
    Text = '1'
    OnKeyDown = edtFieldsKeyDown
  end
  object edtValorUnitario: TEdit
    Left = 272
    Top = 76
    Width = 89
    Height = 21
    TabOrder = 5
    OnKeyDown = edtFieldsKeyDown
  end
  object btnInserirProduto: TButton
    Left = 384
    Top = 74
    Width = 100
    Height = 25
    Caption = 'Inserir Produto'
    TabOrder = 6
    OnClick = btnInserirProdutoClick
  end
  object grdProdutos: TStringGrid
    Left = 16
    Top = 112
    Width = 760
    Height = 376
    DefaultColWidth = 150
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    TabOrder = 7
    OnKeyDown = grdProdutosKeyDown
  end
  object btnGravarPedido: TButton
    Left = 16
    Top = 494
    Width = 100
    Height = 25
    Caption = 'Gravar Pedido'
    TabOrder = 8
    OnClick = btnGravarPedidoClick
  end
  object FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink
    VendorLib = 'C:\dev\Projeto Delphi Novo\libmysql.dll'
    Left = 328
    Top = 576
  end
end
