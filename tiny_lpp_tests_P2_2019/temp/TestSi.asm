global main
extern printf
section .data
true dd 1
false dd 0
b dd 0
a dd 0
const0 dd 10

section .text
main:
mov eax, dword[const0]
mov dword[a], eax
ret
