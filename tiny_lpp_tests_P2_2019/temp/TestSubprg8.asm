global main
extern printf
section .data
true dd 1
false dd 0
x times 5 dd 0
const4 dd 938
const3 dd 253
const2 dd 197
const0 dd 354
const1 dd 642
temp0 dd 0
fmt0 db "%d", 0

section .text
ModificaArreglo:
push ebp
mov ebp, esp
sub esp, 0
mov eax, dword[const0]
mov dword[ebp + 8], eax
mov eax, dword[const1]
mov dword[ebp + 8], eax
mov eax, dword[const2]
mov dword[ebp + 8], eax
mov eax, dword[const3]
mov dword[ebp + 8], eax
mov eax, dword[const4]
mov dword[ebp + 8], eax
mov esp, ebp
pop ebp
ret
main:
push dword[x]
call ModificaArreglo
add esp, 4
mov dword[temp0], eax
push dword[x]
push fmt0
call printf
add esp, 8
push dword[x]
push fmt0
call printf
add esp, 8
push dword[x]
push fmt0
call printf
add esp, 8
push dword[x]
push fmt0
call printf
add esp, 8
push dword[x]
push fmt0
call printf
add esp, 8
ret
