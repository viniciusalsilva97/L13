#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function L13E04
    Criar uma pasta com o nome “Lista 13” no rootpath (protheus_data) e copiará o arquivo do exercício 2 para essa pasta
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function L13E04()
    Local cCaminho   := "C:\TOTVS12\Protheus\protheus_data\"
    Local cNomePasta := "Lista 13\"


    //? Verifica se a pasta existe ou não
    if !ExistDir(cCaminho + cNomePasta)
        MakeDir(cCaminho + cNomePasta) 
    endif 

    CopyArq(cCaminho, cNomePasta)

Return 

Static Function CopyArq(cCaminho, cNomePasta)
    Local cPastaOrig := "C:\Users\TOTVS\AppData\Local\Temp\lista 13 - ex1\"
    Local cPastaDest := "\Lista 13\" 
    Local aArquivos  := Directory(cPastaOrig + "*.*", 'D',,,1)
    Local nI         := 0
    Local nTamanho   := Len(aArquivos)

    if nTamanho > 0
        for nI := 3 to nTamanho
            if !CpyT2S(cPastaOrig + aArquivos[nI][1], cPastaDest)
                MsgStop("Houve um erro ao copiar o arquivo" + aArquivos[nI][1])
            endif
        next
        
        FwAlertSucces("Arquivo(s) copiado com sucesso!", "Concluido")

    else
        FwALertInfo("A pasta não contém nenhum arquivo ou subpasta!", "Atenção")
    endif
Return
