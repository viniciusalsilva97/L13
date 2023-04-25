#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function L13E03
    Ler o texto do arquivo criado no exercício anterior e apresentá-lo em uma mensagem para o usuário
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function L13E03()
    Local cPasta   := "C:\Users\TOTVS\AppData\Local\Temp\lista 13 - ex1\"
    Local cArquivo := "L13E02.txt"
    Local cTxtLinha := ""
    Local oArq      := FwFileReader():New(cPasta + cArquivo)

    //? Verifica se conseguiu ou não abrir o arquivo
    if oArq:Open()
        if !oArq:EOF() //? Verifica se o arquivo está vazio ou não
            while oArq:HasLine()
                cTxtLinha += oArq:GetLine(.T.)
            end
        endif

        oArq:Close()
    endif

    FwAlertSucces(cTxtLinha, "Conteúdo do arquivo:")
Return 
