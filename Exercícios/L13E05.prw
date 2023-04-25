#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function L13E05
    Deletar a pasta criada no exercício 1
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function L13E05()
    Local cPasta    := "C:\Users\TOTVS\AppData\Local\Temp\lista 13 - ex1\"
    Local aArquivos := Directory(cPasta + "*.*", "D",,,1)
    Local nI        := 0

    //? Confirma se o diretório existe
    if ExistDir(cPasta)
        if MsgYesNo("Confirma a exclusão da pasta?", "Atenção")
            if Len(aArquivos) > 0 //? Para deletar os arquivos da pasta
                for nI := 3 to Len(aArquivos)
                    if FErase(cPasta + aArquivos[nI][1]) == -1
                        MsgStop("Houve um erro ao apagar o arquivo" + aArquivos[nI][1])
                    endif
                next
            endif

            //? Para deletar a pasta
            if DirRemove(cPasta)
                FwAlertSuccess("Pasta apagada com sucesso", "Concluido")
            else
                FwAlertError("Houve um erro ao excluir a pasta", "Erro")
            endif
        endif
    endif    
Return 
