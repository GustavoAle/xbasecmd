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

#define XBCMD_VER "1.9.11"

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

		echo("[ xBase, CA-Clipper and Harbour Command Interpreter ]")
		echo("[ Open source. GUI Build: Nov. 5th 2013             ]")
		echo("[ Last version: July 11, 2018 | " + XBCMD_VER+ "              ]")

		echo(".")

		output_xReply := "NULL"
		i := 0

		nCurRow := ROW()
		WHILE (!lExit_signal)

		nCurRow = ROW()

		ACCEPT cPrefix TO local_xCom


		if(!empty(local_xCom))
			exec_xCom(local_xCom)
			local_xCom := space(128)
		Endif

		ENDDO

	Endif



RETURN NIL


PROCEDURE PARSE(cFile)
	LOCAL aInstructions, i

	aInstructions := HB_ATOKENS(memoread(cFile),CRLF)

	FOR i := 1 TO len(aInstructions)
		IF(EMPTY(ALLTRIM(aInstructions[i])))
			LOOP
		END IF
		EXEC_XCOM(aInstructions[i])
	NEXT i

RETURN

/*
FUNCTION echo(input_printchar)
	//LOCAL new_printchar

	if valtype(input_printchar) == "N"
		input_printchar := str(input_printchar)
	endif

	if(valtype(input_printchar) == "C")
		? alltrim(input_printchar)
	endif


	if(valtype(input_printchar) == "L")
		if(input_printchar)
			? "true"
		else
			? "false"
		endif
	endif


RETURN
*/

FUNCTION ECHO(...)

	QOUT(...)

RETURN NIL

FUNCTION VERSION()

	QOUT("xBaseCMD v"+ALLTRIM(XBCMD_VER))

RETURN NIL

FUNCTION CLEAR()
	CLEAR SCREEN
RETURN

FUNCTION exec_xCom(input_xCom)
	LOCAL cEc

	if at("INPUT_XCOM",upper(input_xCom)) != 0
		echo("[Illegal recursive instruction: INPUT_XCOM]")
		echo("[Forced return]")
		RETURN
	endif
	//if type(input_xCom)="U"
		//echo(cPrefix+input_xCom)
	Try
		output_xReply	:=	&input_xCom
	Catch oExecErr

		if(valtype(oExecErr) == "O")
			echo("["+ oExecErr:subsystem()+ "/"			;
			+ alltrim(str(oExecErr:subcode())) + ":"	;
			+ alltrim(str(oExecErr:gencode())) + "] "	;
			+ oExecErr:description() + ": "				;
			+ oExecErr:operation())
		//echo("["+oExecErr+"]"
		endif

	End
	if lEcho == .T.
	cEc := valtype(output_xReply)
		if cEc == "N"
			echo(input_xCom+" [=] "+str(output_xReply))
		endif
		if cEc == "C"
			echo(input_xCom+" [=] "+output_xReply)
		endif
		if cEc == "A"
			echo(input_xCom+" [=] ARRAY")
		endif
		if cEc == "L"
			if output_xReply == .t.
				echo(input_xCom+" [=] .T.")
			else
				echo(input_xCom+" [=] .F.")
			endif
		endif
		output_xReply := nil
	endif
	//elseif !(":=" $ input_xCom)
	//	echo("[Undefined or wrong: "+alltrim(input_xCom)+"]")
	//endif

RETURN

FUNCTION _fstep(nStart,nEnd,nStep,aAction)
	Local i,a,cAct
	if empty(nStart) .and. empty(nEnd)
      RETURN
  	 endif
   	if empty(nStep)
      nStep	:=	1
   endif

	for i	:=	nStart to nEnd Step nStep
		for a	:=	1 to len(aAction)
			cAct	:=	aAction[a]
			Try
				output_xReply	:=	&cAct
			Catch oExecErr
				if(valtype(oExecErr) == "O")
					echo("["+ oExecErr:subsystem()+ "/"			;
					+ alltrim(str(oExecErr:subcode())) + ":"	;
					+ alltrim(str(oExecErr:gencode())) + "] "	;
					+ oExecErr:description() + ": "				;
					+ oExecErr:operation())
				//echo("["+oExecErr+"]"
				endif
			End
		Next a
	next i

RETURN

FUNCTION _while(xCondition,aAction)
	Local i,a,cAct

	if(empty(xCondition) .or. type(xCondition) <> "L")
		RETURN
	endif

	WHILE(&xCondition)
		for a	:=	1 to len(aAction)
			cAct	:=	aAction[a]
			Try
				output_xReply	:=	&cAct
			Catch oExecErr
				if(valtype(oExecErr) == "O")
					echo("["+ oExecErr:subsystem()+ "/"			;
					+ alltrim(str(oExecErr:subcode())) + ":"	;
					+ alltrim(str(oExecErr:gencode())) + "] "	;
					+ oExecErr:description() + ": "				;
					+ oExecErr:operation())
				//echo("["+oExecErr+"]"
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
#include <stdio.h>

/*
HB_FUNC (SCANC){
	char * out = (char*)hb_param(1,0);
	int eeee;
	scanf("%d",&eeee);
	scanf("%[^\n]s",out);

}

HB_FUNC (PRINTC){
	char * in = (char*)hb_parc(1);

	printf("\n%s",in);

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
