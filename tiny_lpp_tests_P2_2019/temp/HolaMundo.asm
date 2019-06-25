global main
extern printf
section .data
true dd 1
false dd 0
str0 db "Hola Mundo", 0
fmt0 db "%s", 0

section .text
main:
push str0
push fmt0
call printf
add esp, 8
ret
