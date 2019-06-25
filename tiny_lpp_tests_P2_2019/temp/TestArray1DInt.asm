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
fmt0 db "%d", 0

section .text
main:
mov eax, dword[const0]
mov dword[x], eax
mov eax, dword[const1]
mov dword[x], eax
mov eax, dword[const2]
mov dword[x], eax
mov eax, dword[const3]
mov dword[x], eax
mov eax, dword[const4]
mov dword[x], eax
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
