                                ;------------------ВАРИАНТ №19------------------
;Разработать программу, использующую динамическое выделение памяти под массив,
;которая вводит одномерный массив A[N], формирует из элементов массива  А новый массив В по правилам:
;Правило №19 Замена нулевых элементов, предшествующих первому отрицательному, единицей.

format PE console
entry start
 
include 'win32a.inc'
 
section '.data' data readable writeable
ru db 'Russian',0
sm dd ' ',0
m1 db 'Введите элементы массива: ',13,10,0
strArray db 'Массив А: ',13,10,0
strArrayB db 'Массив В, составленный по правилу №19: ',13,10,0
strNumber db 'Введите длину массива: ',13,10,0
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
   cinvoke setlocale,0,ru ;устанавливаем локаль
   call readArray          ; Запускаем процедуру, для заполнения массива
   push qq
   call [printf]
   push qqn
   call [printf]
   push strArray            ; Выводим еще одно сообщение
   call [printf]
   call printarray         ; Выводим массив А
   push qqn
   call [printf]
   push qqn
   call [printf]
   push qq
   call [printf]
   push qqn
   call [printf]
   call makearrayB          ; Создаем массив В
   push strArrayB
   call [printf]
   call printarrayB        ; Выводим массив В
   call [getch]
   push 0            ;Вызов функций, для выхода из программы
   call [ExitProcess]

proc readArray
   invoke printf, strNumber  ; Выводим сообщение
   invoke scanf, string, N
   invoke GetProcessHeap
   mov [array], eax
   mov ecx, 4
   imul ecx, [N]             ; Динамически выделаем память под введенный размер
   invoke HeapAlloc, [array],0,ecx
   mov [array], eax
   push m1
   call [printf]
   add esp, 16
   lpl:
        invoke scanf, string, A ;считываю цифру
        add esp, 8   ;удаление из стека лишних push'ей, чтобы процедура верно работала
        mov edx, [array]  ;массив кладется в регистр, чтобы можно было обратиться к его ячейке

        mov ebx, [A]   ; кладется введенное значение в регистр
        inc [i]        ;  увеличивается счетчик
        mov eax, [i] ; кладется счетчик в регистр

        mov [edx+eax*4],ebx  ; кладется значение А в ячейку массива

        cmp eax, [N] ;  сравнение с длиной массива, чтобы выйти из цикла
        jne lpl   ; если != длина, то повторяем цикл
    ret
endp

proc makearrayB
   invoke GetProcessHeap
   mov [arrayB], eax
   mov ecx, 4           ;Динамически выделаем память под введенный размер
   imul ecx, [N]
   invoke HeapAlloc, [arrayB],0,ecx
   mov [arrayB], eax
   ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
      transfer:
        mov edx, [array]   ;кладем массивы и счетчик в регистры
        mov ecx, [arrayB]
        inc [j]
        mov eax, [j]
        mov ebx, [edx+eax*4] ;обращаемся к ячейке массива
        cmp ebx, 0           ;делаем проверку на <0
        jl afterminus            ;если верно, то идем в метку afterminus, где просто копируем оставшиеся элементы из А в В
        cmp ebx, 0
        je zero              ;делаем проверку на ==0, если верно, то идем в метку zero где в массив B вставляем на это место 1
        mov ebx, [edx+eax*4]
        mov [ecx+eax*4], ebx  ;если верхние проверки не прошли, то просто добавляем
                             ;в текущую ячейку массива В элемент из массива А и повторяем цикл
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
        mov eax, [plus]     ;Добавление в текущую ячейку массива B значения -1
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
        call [printf]     ;Проходимся циклом по ячейкам массива А и вызываем printf
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
        call [printf]   ;Проходимся циклом по ячейкам массива B и вызываем printf
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
                                     ;импортированные библиотеки и функции
import msvcrt,\
       setlocale,'setlocale',\
       printf,'printf',\
       scanf,'scanf',\
       system,'system',\
       getch, '_getch'