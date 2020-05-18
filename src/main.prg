#include <hbclass.ch>
#include <hbsocket.ch>
//#include <hbapicom.h>
/*#include <inkey.ch>*/
#include "classes/math.ch"

//#require "hbcomm"

#xcommand TRY              => bError	:=	errorBlock( {|oErr| break( oErr ) } ) ;;
	                                 BEGIN SEQUENCE
#xcommand CATCH [<!oErr!>] => errorBlock( bError ) ;;
	                                 RECOVER [USING <oErr>] <-oErr-> ;;
	                                 errorBlock( bError )
#define CRLF (Chr(13)+chr(10))

PROCEDURE _INITVARS()
	PUBLIC 	lEcho:=.f.,;
		output_xReply,;
		lExit_signal := .F.,;
		cPrefix := "--> ",;
		oExecErr

	output_xReply := "NULL"
	//setbuffer()

RETURN 

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

FUNCTION ECHO(cMsg)

	IF(VALTYPE(cMsg) <> "C")
		PRINTC(str(cMsg))
	ELSE
		PRINTC(cMsg)
	ENDIF

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


PROCEDURE QUIT()
	C_EXIT()
RETURN


PROCEDURE EXIT()
	C_EXIT()
RETURN



***********************************************************************************************
***********************************************************************************************
#pragma BEGINDUMP

#include "hbapi.h"
#include "hbvm.h"
#include <hbapiitm.h>
#include <stdio.h>

//char stdout_second_buffer[1921];

char *xbs_parse(const char *input)
{
    PHB_ITEM pResult;
    char *sResult;
	PHB_ITEM pInput;

	pInput = hb_itemPutC( NULL, (const char*)input );
	char HbFuncName[]  = "EXEC_XCOM";
	
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
/*
HB_FUNC (SETBUFFER){
	stdout_second_buffer[0] = '\0';
	setbuf(stdout,stdout_second_buffer);
}

HB_FUNC (GETBUFFER){
	hb_retc(stdout_second_buffer);
}
*/

HB_FUNC (C_EXIT){
	exit(0);
}

HB_FUNC (PRINTC){
	char * in = (char*)hb_parc(1);

	printf("%s\n",in);

}


/*
	Here comes C codes as follow:

HB_FUNC(functionname){
	hb_parnl(i) // for parameters
	hb_retc(something) //to return something as char
}
*/

#pragma ENDDUMP
***********************************************************************************************
***********************************************************************************************
