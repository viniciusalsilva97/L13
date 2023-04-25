#INCLUDE 'Totvs.ch'
#INCLUDE 'Topconn.ch'
#INCLUDE "Tbiconn.ch"
#INCLUDE 'FwPrintSetup.ch'
#INCLUDE 'RptDef.ch'

#DEFINE PRETO    RGB(0,0,0)

/*/{Protheus.doc} User Function L13C01
    Criar um relatorio dos pedidos de vendas e um log txt das etapas
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function L13C01()
    Local cLog     := "Esse � o log da execucao desse fonte" + CRLF
    Local cCaminho   := "C:\TOTVS12\Protheus\protheus_data\"
    Local cAlias     := SearchSql(@cLog)
    Local cNomePasta := "Pedidos de Venda\"
    Local cPasta     := cCaminho + cNomePasta
    Local cArquivo   := AllTrim((cAlias)->(C5_NUM)) + ".txt"
    Local oWriter    := FwFileWriter():New(cPasta + cArquivo, .T.)

    RegRel(@cLog)

    //? Verifica se a pasta existe ou nao
    if !ExistDir(cCaminho + cNomePasta)
        //? Cria a pasta no protheus_data
        MakeDir(cCaminho + cNomePasta) 
    endif
    cLog += "A pasta foi criada no protheus_data" + CRLF

    if !oWriter:Create() //? Verifica se o arquivo foi ou nao gerado
        FwAlertError("Houve um erro ao gerar o arquivo!" + CRLF + "Erro: " + oWriter:Error():Message, "Erro")
    else //? Escreve o conteudo no arquivo
        cLog += "O log foi preenchido com todas as informacoes acima" + CRLF
        oWriter:Write(cLog)
        oWriter:Close()
    endif

Return 

//! Funcao que faz a consulta SQL
Static Function SearchSql(cLog)
    Local aArea  := GetArea()
    Local cAlias := GetNextAlias()
    Local cQuery := ''

    cQuery += "SELECT A1_NOME, B1_DESC, C5_NUM, C6_PRCVEN, C6_VALOR, C6_QTDVEN, E4_DESCRI" + CRLF
	cQuery += "FROM " + RetSqlName('SC6') + " SC6" + CRLF
    cQuery += "LEFT JOIN " + RetSqlName('SC5') + " SC5 ON C6_NUM = C5_NUM AND SC5.D_E_L_E_T_ = ' '" + CRLF
    cQuery += "LEFT JOIN " + RetSqlName('SB1') + " SB1 ON B1_COD = C6_PRODUTO AND SB1.D_E_L_E_T_ = ' '" + CRLF
    cQuery += "LEFT JOIN " + RetSqlName('SE4') + " SE4 ON C5_CONDPAG = E4_CODIGO AND SE4.D_E_L_E_T_ = ' '" + CRLF
    cQuery += "LEFT JOIN " + RetSqlName('SA1') + " SA1 ON A1_COD = C5_CLIENTE AND SA1.D_E_L_E_T_ = ' '" + CRLF
	cQuery += "WHERE SC6.D_E_L_E_T_ = ' ' AND C6_NUM = '" + SC6->C6_NUM + "'"

    PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" TABLES "SC5" MODULO "FAT"
    TCQUERY cQuery ALIAS (cAlias) NEW

    (cAlias)->(DbGoTop())
    if (cAlias)->(EOF())
       cAlias := '' 
    endif
    
    cLog += "Foi feita uma consulta SQL" + CRLF

    RestArea(aArea)
Return cAlias

//! Funcao para fazer a regua do relatorio
Static Function RegRel(cLog)
    Local cAlias     := SearchSql(@cLog)

    if !Empty(cAlias) 
        Processa({|| MontaRel(cAlias, @cLog)}, "Aguarde...", "Imprimindo Relatorio...", .F.) 
    else 
        FwAlertError("Nenhum registro encontrado", "Atencao!")
    endif

    cLog += "A regua do relatorio foi executada" + CRLF
Return 

//! Funcao para montar o relatorio
Static Function MontaRel(cAlias, cLog)
    Local cPath    := "C:\TOTVS12\Protheus\protheus_data\Pedidos de Venda\"
    Local cArquivo := AllTrim((cAlias)->(C5_NUM)) + ".pdf" //*Nome do arquivo que será gerado

    Private nLinha     := 105
    Private nLinhaSec2 := 200 //* Linha para fazer o cabecalho da segunda sessao
    Private oPrint

    //! Fontes que serao usadas no relatorio
    Private oFont10  := TFont():New("Arial",/*C*/, 10,/*C*/, .F.,/*C*/,/*C*/,/*C*/,/*C*/, .F., .F.) 
    Private oFont10S := TFont():New("Arial",/*C*/, 10,/*C*/, .T.,/*C*/,/*C*/,/*C*/,/*C*/, .T., .F.) 
    Private oFont12  := TFont():New("Arial",/*C*/, 12,/*C*/, .T.,/*C*/,/*C*/,/*C*/,/*C*/, .F., .F.) 
    Private oFont14  := TFont():New("Arial",/*C*/, 14,/*C*/, .T.,/*C*/,/*C*/,/*C*/,/*C*/, .F., .F.) 
    Private oFont16  := TFont():New("Arial",/*C*/, 16,/*C*/, .T.,/*C*/,/*C*/,/*C*/,/*C*/, .T., .F.) 

    oPrint := FwMsPrinter():New(cArquivo, IMP_PDF, .F., "", .T.,/*TReport*/, @oPrint, "", /*LServer*/,/*C*/,/*RAW*/,.T.) 
    
    oPrint:cPathPDF := cPath
    
    oPrint:SetPortrait()
    
    oPrint:SetPaperSize(9)

    oPrint:StartPage()

    cLog += "As configuracoes do relatorio acabaram de ser definidas" + CRLF

    Cabecalho(@cLog)
    ImpDados(cAlias, @cLog)

    oPrint:EndPage()

    oPrint:Preview()

    cLog += "O relatorio foi finalizado e impresso" + CRLF
Return 

Static Function Cabecalho(cLog)
    oPrint:Box(15, 15, 85, 580, "-8") 
    oPrint:Line(85, 15, 15, 580, PRETO, "-6") 
    
    oPrint:Say(35, 20, "Empresa / Filial: " + AllTrim(SM0->M0_NOME) + " / " + AllTrim(SM0->M0_FILIAL), oFont14,, PRETO)
    oPrint:Say(70, 220, "Pedido de Venda", oFont16,, PRETO)

    oPrint:Say(nLinha, 20,  "NOME CLIENTE"  , oFont12, /*Largura*/, PRETO)
    oPrint:Say(nLinha, 100, "COND. PAGAMENTO", oFont12, /*Largura*/, PRETO)

    nLinha += 5
    oPrint:Line(nLinha, 15, nLinha, 580, /*COR*/, "-6")

    nLinha += 20

    //! Parte responsável pela 2 sessao do relatorio
    oPrint:Say(nLinhaSec2, 20, "DESC. PROD"      , oFont12, /*Largura*/, PRETO)
    oPrint:Say(nLinhaSec2, 100, "PRECO VENDA"    , oFont12, /*Largura*/, PRETO)
    oPrint:Say(nLinhaSec2, 200, "QUANT. VENDIDA" , oFont12, /*Largura*/, PRETO)
    oPrint:Say(nLinhaSec2, 300, "VALOR COMPRA"   , oFont12, /*Largura*/, PRETO)

    nLinhaSec2 += 5
    oPrint:Line(nLinhaSec2, 15, nLinhaSec2, 580, /*COR*/, "-6")

    nLinhaSec2 += 20

    cLog += "O cabecalho do relatorio foi feito" + CRLF
Return 

//! Funcao para imprimir os dados no relatorio
Static Function ImpDados(cAlias, cLog)
    Local cString      := ""
    Local nTotalizador := 0

    DbSelectArea(cAlias)

    cString := AllTrim((cAlias)->(A1_NOME))
    VeriQuebLn(cString, 10, 20, @cLog)

    cString := AllTrim((cAlias)->(E4_DESCRI))
    oPrint:Say(nLinha, 100, cString, oFont10,,)

    //! Loop para mostrar os produtos do pedido de venda selecionado
    (cAlias)->(DbGoTop())
    while (cAlias)->(!EOF())
        cString := AllTrim((cAlias)->(B1_DESC))
        oPrint:Say(nLinhaSec2, 20, cString, oFont10,,)

        cString := AllTrim(Str((cAlias)->(C6_PRCVEN)))
        oPrint:Say(nLinhaSec2, 125, "R$ " + cString, oFont10,,)

        cString := AllTrim(Str((cAlias)->(C6_QTDVEN)))
        oPrint:Say(nLinhaSec2, 225, cString, oFont10,,)

        cString := AllTrim(Str((cAlias)->(C6_VALOR)))
        oPrint:Say(nLinhaSec2, 325, "R$ " + cString, oFont10,,)
        
        nTotalizador += (cAlias)->(C6_VALOR)

        nLinhaSec2 += 30
        IncProc() 
        (cAlias)->(DbSkip())
    end

    oPrint:Say(nLinhaSec2, 300, "Valor Total: R$ " + cValToChar(nTotalizador), oFont10S,,)

    cLog += "O relatorio acabou de ser preechido com as informacoes do banco de dados" + CRLF
    cLog += "Foi adicionado um totalizador para somar o valor total da compra" + CRLF
Return 

//! Funcao para verificar a quebra de linha
Static Function VeriQuebLn(cString, nQtdCar, nCol, cLog)
    Local cTxtLinha  := ""
    Local lTemQuebra := .F.
    Local nQtdLinhas := MLCount(cString, nQtdCar, /*TAB*/,.F.)
    Local nI         := 0

    if nQtdLinhas > 1
        lTemQuebra := .T.
        for nI := 1 to nQtdLinhas
            cTxtLinha := MemoLine(cString, nQtdCar, nI)
            oPrint:Say(nLinha, nCol, cTxtLinha, oFont10,,) 
            nLinha += 10  
        next
    else
        oPrint:Say(nLinha, nCol, cString, oFont10,,)   
    endif

    if lTemQuebra
        nLinha -= nQtdLinhas * 10
    endif

    cLog += "Alguns campos precisaram ter uma quebra de linha para aparecer no relatorio" + CRLF
Return 
