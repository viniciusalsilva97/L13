#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function L13E01
    Criar um diretório chamado “Lista 13 – Ex1” na pasta temporária do Windows
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function L13E01()
    Local cCaminho   := GetTempPath()
    Local cNomePasta := "Lista 13 - Ex1\"

    if !ExistDir(cCaminho + cNomePasta)
        MakeDir(cCaminho + cNomePasta) 
    else
        FwAlertInfo("Essa pasta já existe!")
    endif 
Return 
