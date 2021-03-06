                                ;------------------������� �19------------------
;����������� ���������, ������������ ������������ ��������� ������ ��� ������,
;������� ������ ���������� ������ A[N], ��������� �� ��������� �������  � ����� ������ � �� ��������:
;������� �19 ������ ������� ���������, �������������� ������� ��������������, ��������.

format PE console
entry start
 
include 'win32a.inc'
 
section '.data' data readable writeable
ru db 'Russian',0
sm dd ' ',0
m1 db '������� �������� �������: ',13,10,0
strArray db '������ �: ',13,10,0
strArrayB db '������ �, ������������ �� ������� �19: ',13,10,0
strNumber db '������� ����� �������: ',13,10,0
A dd ?
array dd ?
arrayB dd ?
i dd 0
k dd 0
j dd 0
p dd 0
N dd ?
plus dd 1
string dd '%d', 0
space db '%d ', 0
qq db '-----------------',13,10,0
qqn db ' ', 13,10,0
 
section '.code' code readable executable
start:
   cinvoke setlocale,0,ru ;������������� ������
   call readArray          ; ��������� ���������, ��� ���������� �������
   push qq
   call [printf]
   push qqn
   call [printf]
   push strArray            ; ������� ��� ���� ���������
   call [printf]
   call printarray         ; ������� ������ �
   push qqn
   call [printf]
   push qqn
   call [printf]
   push qq
   call [printf]
   push qqn
   call [printf]
   call makearrayB          ; ������� ������ �
   push strArrayB
   call [printf]
   call printarrayB        ; ������� ������ �
   call [getch]
   push 0            ;����� �������, ��� ������ �� ���������
   call [ExitProcess]

proc readArray
   invoke printf, strNumber  ; ������� ���������
   invoke scanf, string, N
   invoke GetProcessHeap
   mov [array], eax
   mov ecx, 4
   imul ecx, [N]             ; ����������� �������� ������ ��� ��������� ������
   invoke HeapAlloc, [array],0,ecx
   mov [array], eax
   push m1
   call [printf]
   add esp, 16
   lpl:
        invoke scanf, string, A ;�������� �����
        add esp, 8   ;�������� �� ����� ������ push'��, ����� ��������� ����� ��������
        mov edx, [array]  ;������ �������� � �������, ����� ����� ���� ���������� � ��� ������

        mov ebx, [A]   ; �������� ��������� �������� � �������
        inc [i]        ;  ������������� �������
        mov eax, [i] ; �������� ������� � �������

        mov [edx+eax*4],ebx  ; �������� �������� � � ������ �������

        cmp eax, [N] ;  ��������� � ������ �������, ����� ����� �� �����
        jne lpl   ; ���� != �����, �� ��������� ����
    ret
endp

proc makearrayB
   invoke GetProcessHeap
   mov [arrayB], eax
   mov ecx, 4           ;����������� �������� ������ ��� ��������� ������
   imul ecx, [N]
   invoke HeapAlloc, [arrayB],0,ecx
   mov [arrayB], eax
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      transfer:
        mov edx, [array]   ;������ ������� � ������� � ��������
        mov ecx, [arrayB]
        inc [j]
        mov eax, [j]
        mov ebx, [edx+eax*4] ;���������� � ������ �������
        cmp ebx, 0           ;������ �������� �� <0
        jl afterminus            ;���� �����, �� ���� � ����� afterminus, ��� ������ �������� ���������� �������� �� � � �
        cmp ebx, 0
        je zero              ;������ �������� �� ==0, ���� �����, �� ���� � ����� zero ��� � ������ B ��������� �� ��� ����� 1
        mov ebx, [edx+eax*4]
        mov [ecx+eax*4], ebx  ;���� ������� �������� �� ������, �� ������ ���������
                             ;� ������� ������ ������� � ������� �� ������� � � ��������� ����
        cmp eax, [N]
        je finish
        jmp transfer

      afterminus:
        mov edx, [array]
        mov ecx, [arrayB]
        mov eax, [j]
        mov ebx, [edx+eax*4]
        mov [ecx+eax*4], ebx
        cmp eax, [N]
        je finish
        inc [j]
        jmp afterminus

      zero:
        mov edx, [arrayB]
        mov ecx, [j]
        mov eax, [plus]     ;���������� � ������� ������ ������� B �������� -1
        mov [edx+ecx*4], eax
        cmp ecx, [N]
        je finish
        jmp transfer

      finish:
        ret
ret
endp


proc printarray

    printprocess:
        mov edx, [array]
        inc [k]
        mov eax, [k]
        mov ecx,  [edx+eax*4]
        push ecx
        push space
        call [printf]     ;���������� ������ �� ������� ������� � � �������� printf
        push sm
        call [printf]
        add esp, 12

        mov eax, [k]
        cmp eax,[N]
        jne printprocess

     ret
endp
proc printarrayB

    printprocess1:
        mov edx, [arrayB]
        inc [p]
        mov eax, [p]
        mov ecx,  [edx+eax*4]
        push ecx
        push space
        call [printf]   ;���������� ������ �� ������� ������� B � �������� printf
        push sm
        call [printf]
        add esp, 12

        mov eax, [p]
        cmp eax,[N]
        jne printprocess1

     ret
endp

section '.idata' import data readable
 
library kernel,'kernel32.dll',\
        msvcrt,'msvcrt.dll'
 
import kernel,\
       ExitProcess,'ExitProcess',\
       HeapAlloc, 'HeapAlloc',\
       GetProcessHeap, 'GetProcessHeap'
                                     ;��������������� ���������� � �������
import msvcrt,\
       setlocale,'setlocale',\
       printf,'printf',\
       scanf,'scanf',\
       system,'system',\
       getch, '_getch'