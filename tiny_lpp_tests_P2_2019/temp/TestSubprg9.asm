global main
extern printf
section .data
true dd 1
false dd 0
const0 dd 1
fmt0 db "%d", 0

section .text
main:
push dword[const0]
push fmt0
call printf
add esp, 8
ret
