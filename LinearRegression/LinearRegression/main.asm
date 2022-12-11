INCLUDE Irvine32.inc
INCLUDELIB Irvine32.lib
INCLUDELIB \masm32\lib\kernel32.lib
INCLUDELIB \masm32\lib\User32.lib

INCLUDE macros.inc

BUFFER_SIZE = 1024

.data
deathsy DWORD 3,5,6,8,8,8,9,9,9,9,14,16,17,17,17,17,18,19,19,19,21,21,22,22,22,23,24,25,27,28,29,33,34,39,43,45,47
yearsx DWORD 1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016
titleStr BYTE "Cancer Growth Linear Regression",0
welc BYTE "Welcome , Enter File name to display all data available (cancer2020.txt) , Press Enter To Proceed ! ",0
welc1 BYTE "Welcome , Enter a year to find our prediction for it (2022 for example) , Press Enter To Proceed ! ",0
filename    BYTE 80 DUP(0)
titleStr2 BYTE "Cancer Growth Prediction",0
msg2 BYTE "Would You Like to Check The Prediction for any specific Future Year ? ",0
titleStr3 BYTE "All Calculations",0
msg3 BYTE "Would You Like to Check All the Calculations that took place? ",0
yearinput byte 'Enter a year to find our prediction for it (2022 for example): ',0 
meanofX byte 'The mean of Years is: ',0 
meanofY byte 'The mean of Deaths is: ',0
deathoutput byte 'According to the Linear Regression Calculated',0 
deathoutput1 byte "The number of deaths in Entered year will be Approximately : ",0
gradient byte 'The gradient of the equation is: ',0 
y_intercept byte 'The y-intercept of the equation is: ',0 
co_relation byte 'The correlation constant of the equation is: ',0 
Std_X byte 'The Standard Deviation of X is: ',0 
Std_Y byte 'The Standard Deviation of Y is: ',0 
centr byte "                                             ",0
cal byte "Calculating ",0
loaders byte ". ",0

.data?
buffer BYTE BUFFER_SIZE DUP(?)
datarr DWORD BUFFER_SIZE DUP(?)
Y DWORD ?
X DWORD ?
A REAL8 ?
B REAL8 ?
R REAL8 ?
meanX REAL8 ?
meanY REAL8 ?
SX REAL8 ?
SY REAL8 ?
Xsub REAL8 ?
Ysub REAL8 ?
temp DWORD ?

.code
main PROC
LOCAL fileHandle:DWORD
;intro
	mov edx,offset welc
	mov ebx,offset titleStr
	call MsgBox
	
    mov eax,Black*4h+Cyan*4h
	call setTEXTcolor
	call clrscr

; Input File name (cancer2020.txt)
start:
    call clrscr
    mov dh,13
    mov dl,40
    call gotoxy
	mWrite "Enter an input filename: "
    call crlf
    mov dh,14
    mov dl,43
    call gotoxy
    mWrite "(cancer2020.txt)"
    mov dh,13
    mov dl,65
    call gotoxy
	mov	edx,OFFSET filename
	mov	ecx,SIZEOF filename
	call	Readstring


; Open the cancer2020 file for input
	mov	edx,OFFSET filename
	call	OpenInputFile
	mov	fileHandle,eax

; Check for errors.
	cmp	eax,INVALID_HANDLE_VALUE ; error opening file?
	jne	file_ok					 ; no: skip
    call clrscr
    mov dh,13
    mov dl,37
    call gotoxy
	mWrite <"Cannot open file, Try again with proper name",0dh,0ah>
    mov eax,2000
    call delay
	jmp	start	

file_ok:

; Read the file into array.
call clrscr
mov esi,0
invoke SetFilePointer,filehandle,0,NULL,FILE_BEGIN
INVOKE SetConsoleTitle, ADDR titleStr
mov ecx,35
l2:
mov ebx,ecx
	mov	edx,OFFSET buffer
	mov	ecx,56
	mov eax,filehandle
	call	ReadFromFile
	
	mov	edx,offset buffer
	mov datarr[esi],edx
	
	mov eax,edx
	call writestring
	
	mov ecx,ebx
	add esi,4
	loop l2

close_file:
	mov	eax,fileHandle
	call	CloseFile
;boxforprediction
mov edx,offset msg2
mov ebx,offset titleStr2
call msgboxask
cmp eax,IDYES
jne quit
		call clrscr
        ;mov edx,offset welc1
	    ;mov ebx,offset titleStr2
	    ;call MsgBox
	    mov eax,Black*4h+Cyan*4h
	    call setTEXTcolor
	    call clrscr
        mov edx,offset centr
        call writestring
        call loader
        
        mov eax,1000
        call delay
		call MeanofArr
        mov eax,3000
        call delay

        call crlf
        call clrscr
        mov edx,offset centr
        call writestring
        call loader
       

        call StdDevofArr
         mov eax,3000
        call delay
        call crlf
        call clrscr
        mov edx,offset centr
        call writestring
        call loader
        
        call Correlation
         mov eax,3000
        call delay
        call crlf
        call clrscr
        mov edx,offset centr
        call writestring
        call loader
        
        call CalConstants
         mov eax,3000
        call delay
        call crlf
        call clrscr
        mov edx,offset centr
        call writestring
        call loader
        
        call clrscr
        call Equation
        
        
quit:
call ReadChar ; pause before closing
	exit
main ENDP

Equation PROC
    mov dh,13
    mov dl,27
    call gotoxy
    MOV edx,OFFSET yearinput
    call writestring
    call Readdec
    mov X,eax
    fild X
    fld B
    fmul st,st(1)
    fstp st(1)
    fld A
    fadd st(1),st(0)
    fstp st(0)
    frndint 
    fist Y
    call clrscr
    mov dh,13
    mov dl,35
    call gotoxy
    mov edx,OFFSET deathoutput
    call writestring
    call crlf
    mov dh,14
    mov dl,27
    call gotoxy
    mov edx,OFFSET deathoutput1
    call writestring
    mov eax,Y
    call writedec
ret
Equation ENDP
CalConstants PROC
    ;calculating B
    fld R
    fld SY
    fmul st(1),st(0)
    fstp st(0)
    fld SX
    fdiv
    fst B
    mov edx,OFFSET gradient
    call writestring
    call writefloat
    call crlf

    ;calculating A
    fld meanX
    fmul st(1),st(0)
    fstp st(0)
    fld meanY
    fsub st(0),st(1)
    mov edx, OFFSET y_intercept
    call writestring
    call writefloat
    call crlf
    fstp A
    fstp st(0)

ret
CalConstants ENDP

Correlation PROC
        ;calculating R
        mov esi,0
        mov ecx, LENGTHOF deathsy
        fldz
        fld meanX
        fld meanY
        
        corr:    
        fild yearsx[esi]
        fsub st,st(2)
        fild deathsy[esi]
        fsub st,st(2)
        fmul st,st(1)
        faddp st(4),st
        fstp st(0)
        add esi,TYPE deathsy
        LOOP corr
        fstp st(0)
        fstp st(0)
        fld Xsub
        fld Ysub
        fmul st(1),st(0)
        fstp st(0)
        fdiv
        mov edx,OFFSET co_relation
        call writestring
        call writefloat
        call crlf
        fstp R
        
Correlation ENDP

StdDevofArr PROC
        ;(y-ymean)^2
        mov ebx,TYPE deathsy
        mov ecx,LENGTHOF deathsy
        mov esi,0
     
        fldz
        fld meanY
        StdX:
        fild deathsy[esi]
        fsub st,st(1)
        fmul st,st
        faddp st(2),st
        add esi,ebx
        LOOP StdX
        fstp meanY
        mov eax,LENGTHOF deathsy
        dec eax
        mov temp,eax
        fild temp
        fdiv
        fsqrt
        fst Ysub ;saving (y-ymean)^@2
        mov edx,OFFSET Std_Y
        call writestring
        call writefloat
        call crlf
        fstp SY
        fincstp

        ;(x-xmean)^2
        mov ebx,TYPE yearsx
        mov ecx,LENGTHOF yearsx
        mov esi,0
     
        fldz
        fld meanX
        StdY:
        fild yearsx[esi]
        fsub st,st(1)
        fmul st,st
        faddp st(2),st
        add esi,ebx
        LOOP StdY
        fstp meanX
        mov eax,LENGTHOF yearsx
        dec eax
        mov temp,eax
        fild temp
        fdiv
        fsqrt
        fst Xsub ;saving (x-xmean)^@2
        mov edx,OFFSET Std_X
        call writestring
        call writefloat
        call crlf
        fstp SX


        ret 16
StdDevofArr ENDP

MeanofArr PROC
        mov ebx,TYPE deathsy
        mov ecx,lengthof deathsy
        MOV temp,ecx
        MOV esi,0 
        fldz
        MEDX : 
        fild deathsy[esi] 
        fadd
        ADD esi,TYPE DWORD
        LOOP MEDX
        fidiv temp
        fstp meanY
        fld meanY
        mov edx, OFFSET meanofY
        call WriteString
        call WriteFloat
        fstp meanY
        
        call crlf
        mov ebx,TYPE yearsx
        mov ecx,lengthof yearsx
        MOV temp,ecx
        MOV esi,0 
        fldz
        MEDY: 
        fild yearsx[esi] 
        fadd
        ADD esi,TYPE DWORD
        LOOP MEDY
        fidiv temp
        fstp meanX
        fld meanX
        mov edx,OFFSET meanofX
        call writestring
        call WriteFloat
        fstp meanX
        
        ret
MeanofArr ENDP
loader PROC
;mov eax,black*44h+white*44h
;call setTEXTcolor
mov dh,13
mov dl,46
call gotoxy
mov edx,offset cal
call writestring
mov edx,offset loaders
call writestring
mov eax,100
call delay
mov edx,offset loaders
call writestring
mov eax,100
call delay
mov edx,offset loaders
call writestring
mov eax,100
call delay
call clrscr
mov eax,Black*4h+Cyan*4h
	call setTEXTcolor
ret
loader ENDP

END main
