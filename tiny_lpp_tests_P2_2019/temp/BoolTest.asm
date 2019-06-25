global main
extern printf
section .data
true dd 1
false dd 0
x dd 0
fmt0 db "%d", 0

section .text
main:
mov eax, dword[true]
mov dword[x], eax
push dword[x]
push fmt0
call printf
add esp, 8
mov eax, dword[false]
mov dword[x], eax
push dword[x]
push fmt0
call printf
add esp, 8
ret
