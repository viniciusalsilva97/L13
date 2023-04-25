#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function L13C02
    Copia os arquivos do challenge anterior para uma pasta que deve estar no c do meu pc
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
    @see: https://tdn.totvs.com/display/tec/ADir
/*/
User Function L13C02()
    Local cCaminho   := "C:\"
    Local cNomePasta := "Vendas Protheus\"

    if !ExistDir(cCaminho + cNomePasta)
        MakeDir(cCaminho + cNomePasta) 
    endif 

    CopArq(cCaminho, cNomePasta)
Return 

Static Function CopArq(cCaminho, cNomePasta)
    Local cPastaOrig := "\pedidos de venda\"
    Local cPastaDest := "C:\Vendas Protheus\"
    Local aArquivos  := {}
    Local nI         := 0 

    //? Preenche o array com as informa��es dos arquivos e/ou da pasta
    aDir(cPastaOrig + "*.pdf", aArquivos)

    if Len(aArquivos) > 0
        for nI := 1 to Len(aArquivos)
            //! Fun��o respons�vel por realizar a copia dos arquivos de uma pasta p/ outra
            __CopyFile(cPastaOrig + aArquivos[nI], cPastaDest + aArquivos[nI])
        next
        FwAlertSuccess("O relat�rio acabou de ser copiado", "Deu certo")
    else
        FwAlertError("A pasta selecionada n�o tem arquivos", "Aten��o")
    endif
Return

