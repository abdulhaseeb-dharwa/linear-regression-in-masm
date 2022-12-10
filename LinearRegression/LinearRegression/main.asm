INCLUDE Irvine32.inc
INCLUDE macros.inc

.data
deathsy DWORD 3,5,6,8,8,8,9,9,9,9,14,16,17,17,17,17,18,19,19,19,21,21,22,22,22,23,24,25,27,28,29,33,34,39,43,45,47
yearsx DWORD 1980,1981,1982,1983,1984,1985,1986,1987,1988,1989,1990,1991,1992,1993,1994,1995,1996,1997,1998,1999,2000,2001,2002,2003,2004,2005,2006,2007,2008,2009,2010,2011,2012,2013,2014,2015,2016
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

yearinput byte 'Enter Year: ',0 
meanofX byte 'The mean of Years is: ',0 
meanofY byte 'The mean of Deaths is: ',0
deathoutput byte 'The number of deaths will happen in the entered year is: ',0 
gradient byte 'The gradient of the equation is: ',0 
y_intercept byte 'The y-intercept of the equation is: ',0 
co_relation byte 'The correlation constant of the equation is: ',0 
Std_X byte 'The Standard Deviation of X is: ',0 
Std_Y byte 'The Standard Deviation of Y is: ',0 
.code
main PROC
        call MeanofArr
        call crlf
        call StdDevofArr
        call Correlation
        call CalConstants
        call Equation
exit
main ENDP
Equation PROC
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
    mov edx,OFFSET deathoutput
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
END main