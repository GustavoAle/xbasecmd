#include <hbclass.ch>
#include <hbsocket.ch>
#include <inkey.ch>
#include "classes/math.ch"

#xcommand TRY              => bError	:=	errorBlock( {|oErr| break( oErr ) } ) ;;
	                                 BEGIN SEQUENCE
#xcommand CATCH [<!oErr!>] => errorBlock( bError ) ;;
	                                 RECOVER [USING <oErr>] <-oErr-> ;;
	                                 errorBlock( bError )
#define CRLF (Chr(13)+chr(10))

/*
FUNCTION Main(cFile)
	LOCAL 	aSeq,;
			i,;
			local_xCom,;
			xteste, nCurRow
	PUBLIC 	lEcho:=.f.,;
			output_xReply,;
			lExit_signal := .F.,;
			cPrefix := "--> ",;
			oExecErr

	SET COLOR TO "RB/N+"
	SET KEY K_CTRL_C TO QUIT()
	If upper(HB_ATOKENS(memoread(cFile),CRLF)[1]) = 'NOGUI' .or. upper(HB_ATOKENS(memoread(cFile),CRLF)[1]) = 'HIDE'
		//load_fromfile(cFile)
	Else
		clear()

		ECHO("[ xBase, CA-Clipper and Harbour Command Interpreter ]")
		ECHO("[ Open source. GUI Build: Nov. 5th 2013             ]")
		ECHO("[ Last version: Nov. 09, 2019 | " + XBCMD_VER+ "              ]")

		ECHO(".")

		output_xReply := "NULL"
		i := 0

		nCurRow := ROW()

		IF(file(cFile))
			PARSE_FROM_FILE(cFile)
			ECHO("[-----File parsed-----]")
		END IF


		WHILE (!lExit_signal)

		nCurRow = ROW()

		ACCEPT cPrefix TO local_xCom


		if(!EMPTY(local_xCom))
			EXEC_XCOM(local_xCom)
			local_xCom := space(128)
		Endif

		ENDDO

	Endif

RETURN NIL
*/

PROCEDURE _INIT()
	PUBLIC 	lEcho:=.f.,;
		output_xReply,;
		lExit_signal := .F.,;
		cPrefix := "--> ",;
		oExecErr

	output_xReply := "NULL"

RETURN 

/*
PROCEDURE TEST()
	PRINTC("HELLO WORLD")
RETURN 
*/

PROCEDURE PARSE_FROM_FILE(cFile)
	LOCAL aInstructions, i

	aInstructions := HB_ATOKENS(memoread(cFile),CRLF)

	FOR i := 1 TO len(aInstructions)
		IF(EMPTY(ALLTRIM(aInstructions[i])))
			LOOP
		END IF
		EXEC_XCOM(aInstructions[i])
	NEXT i

RETURN

FUNCTION ECHO(...)

	//QOUT(...)
	PRINTC(...)

RETURN NIL

FUNCTION VERSION()

	ECHO("xBaseCMD v"+ALLTRIM(XBCMD_VER))

RETURN NIL

FUNCTION CLEAR()
	CLEAR SCREEN
RETURN

FUNCTION EXEC_XCOM(input_xCom)
	LOCAL cEc

	if AT("INPUT_XCOM",upper(input_xCom)) != 0
		ECHO("[Illegal recursive instruction: INPUT_XCOM]")
		ECHO("[Forced return]")
		RETURN
	endif
	//if TYPE(input_xCom)="U"
		//ECHO(cPrefix+input_xCom)
	Try
		output_xReply	:=	&input_xCom
	Catch oExecErr

		if(valtype(oExecErr) == "O")
			ECHO("["+ oExecErr:subsystem()+ "/"			;
			+ ALLTRIM(STR(oExecErr:subcode())) + ":"	;
			+ ALLTRIM(STR(oExecErr:gencode())) + "] "	;
			+ oExecErr:description() + ": "				;
			+ oExecErr:operation())
		//ECHO("["+oExecErr+"]"
		endif

	End
	if lEcho == .T.
	cEc := valtype(output_xReply)
		if cEc == "N"
			ECHO(input_xCom+" [=] "+STR(output_xReply))
		endif
		if cEc == "C"
			ECHO(input_xCom+" [=] "+output_xReply)
		endif
		if cEc == "A"
			ECHO(input_xCom+" [=] ARRAY")
		endif
		if cEc == "L"
			if output_xReply == .t.
				ECHO(input_xCom+" [=] .T.")
			else
				ECHO(input_xCom+" [=] .F.")
			endif
		endif
		output_xReply := nil
	endif
	//elseif !(":=" $ input_xCom)
	//	ECHO("[Undefined or wrong: "+ALLTRIM(input_xCom)+"]")
	//endif

RETURN

FUNCTION _FSTEP(nStart,nEnd,nStep,aAction)
	Local i,a,cAct
	if EMPTY(nStart) .and. EMPTY(nEnd)
      RETURN
  	 endif
   	if EMPTY(nStep)
      nStep	:=	1
   endif

	for i	:=	nStart to nEnd Step nStep
		for a	:=	1 to len(aAction)
			cAct	:=	aAction[a]
			Try
				output_xReply	:=	&cAct
			Catch oExecErr
				if(valtype(oExecErr) == "O")
					ECHO("["+ oExecErr:subsystem()+ "/"			;
					+ ALLTRIM(STR(oExecErr:subcode())) + ":"	;
					+ ALLTRIM(STR(oExecErr:gencode())) + "] "	;
					+ oExecErr:description() + ": "				;
					+ oExecErr:operation())
				//ECHO("["+oExecErr+"]"
				endif
			End
		Next a
	next i

RETURN

FUNCTION _WHILE(xCondition,aAction)
	Local i,a,cAct

	if(EMPTY(xCondition) .or. TYPE(xCondition) <> "L")
		RETURN
	endif

	WHILE(&xCondition)
		for a	:=	1 to len(aAction)
			cAct	:=	aAction[a]
			Try
				output_xReply	:=	&cAct
			Catch oExecErr
				if(valtype(oExecErr) == "O")
					ECHO("["+ oExecErr:subsystem()+ "/"			;
					+ ALLTRIM(STR(oExecErr:subcode())) + ":"	;
					+ ALLTRIM(STR(oExecErr:gencode())) + "] "	;
					+ oExecErr:description() + ": "				;
					+ oExecErr:operation())
				//ECHO("["+oExecErr+"]"
				endif
			End
		Next a
	ENDDO

RETURN

FUNCTION VAR( cDATAN,xCont)
	PUBLIC &cDATAN	:=	xCont
RETURN nil


FUNCTION QUIT()
	lExit_signal := .T.
RETURN


***********************************************************************************************
***********************************************************************************************
#pragma BEGINDUMP

#include "hbapi.h"
#include "hbvm.h"
#include <hbapiitm.h>
#include <stdio.h>

char *xbs_parse(const char *input)
{
    PHB_ITEM pResult;
    char *sResult;
	PHB_ITEM pInput;

	pInput = hb_itemPutC( NULL, (const char*)input );
	char HbFuncName[]  = "EXEC_XCOM";
	//printf("Pointer: %p",(void*)pInput);

	pResult = hb_itemDoC( HbFuncName, 1, (PHB_ITEM) pInput);
	sResult = hb_itemGetC( pResult );
	hb_itemRelease( pInput );

    return sResult ;
}

void xbs_call_proc(const char *input){
	hb_itemDoC(input, 0);
}

void test_from_c(void)
{

	char HbFuncName[]  = "VERSION";
	hb_itemDoC( HbFuncName, 0);
}

HB_FUNC (PRINTC){
	char * in = (char*)hb_parc(1);

	printf("\n%s",in);

}
/*

HB_FUNC (SCANC){
	char * out = (char*)hb_param(1,0);
	int eeee;
	scanf("%d",&eeee);
	scanf("%[^\n]s",out);

	hb_retc(out);
}


	Here comes C codes as follow:

HB_FUNC(functionname){
	hb_parnl(i) // for parameters
	hb_retc(something) //to return something as char
}
*/

#pragma ENDDUMP
***********************************************************************************************
***********************************************************************************************
