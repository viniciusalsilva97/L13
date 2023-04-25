#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function L13E02
    Criar um arquivo TXT com um texto qualquer e salvar dentro da pasta criada no exercício anterior
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function L13E02()
    Local cPasta   := "C:\Users\TOTVS\AppData\Local\Temp\lista 13 - ex1\"
    Local cArquivo := "L13E02.txt"
    Local oWriter  := FwFileWriter():New(cPasta + cArquivo, .T.)

    //? Verifica se o arquivo existe
    if File(cPasta + cArquivo)
        FwAlertInfo("O arquivo já existe!", "Atenção")
    else
        if !oWriter:Create() //? Verifica se o arquivo foi ou não gerado
            FwAlertError("Houve um erro ao gerar o arquivo!" + CRLF + "Erro: " + oWriter:Error():Message, "Erro")
        else
            oWriter:Write("L13E02" + CRLF + "Um texto qualquer para esse arquivo txt.")
            oWriter:Close()
        endif
    endif
Return 
