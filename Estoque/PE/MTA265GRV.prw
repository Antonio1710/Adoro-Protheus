#INCLUDE 'protheus.ch'
#INCLUDE 'parmtype.ch'

USER FUNCTION MTA265GRV()

	RECLOCK( "SDA", .F. )
	
		SDA->DA_XUSER := CUSERNAME
		
	MSUNLOCK()
RETURN