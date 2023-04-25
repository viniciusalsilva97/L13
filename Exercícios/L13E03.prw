#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function L13E03
    Ler o texto do arquivo criado no exerc�cio anterior e apresent�-lo em uma mensagem para o usu�rio
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function L13E03()
    Local cPasta   := "C:\Users\TOTVS\AppData\Local\Temp\lista 13 - ex1\"
    Local cArquivo := "L13E02.txt"
    Local cTxtLinha := ""
    Local oArq      := FwFileReader():New(cPasta + cArquivo)

    //? Verifica se conseguiu ou n�o abrir o arquivo
    if oArq:Open()
        if !oArq:EOF() //? Verifica se o arquivo est� vazio ou n�o
            while oArq:HasLine()
                cTxtLinha += oArq:GetLine(.T.)
            end
        endif

        oArq:Close()
    endif

    FwAlertSucces(cTxtLinha, "Conte�do do arquivo:")
Return 
