#INCLUDE 'Totvs.ch'

/*/{Protheus.doc} User Function MT410INC
    Ponto de entrada para permitir gerar um relatório em pdf e o seu log assim que gravar o pedido de venda
    @type  Function
    @author Vinicius Silva
    @since 24/04/2023
/*/
User Function MT410INC()

    if ExistBlock("L13C01")
        ExecBlock("L13C01", .F., .F.,)
    endif   

Return 
