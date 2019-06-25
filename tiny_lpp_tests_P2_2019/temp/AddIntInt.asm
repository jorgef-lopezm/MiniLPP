global main
extern printf
section .data
true dd 1
false dd 0
z dd 0
x dd 0
_y dd 0
const1 dd 27
const0 dd 65
temp0 dd 0
fmt0 db "%d", 0

section .text
main:
mov eax, dword[const0]
mov dword[x], eax
mov eax, dword[const1]
mov dword[_y], eax
mov eax, dword[x]
add eax, dword[_y]
mov dword[temp0],eax
mov eax, dword[temp0]
mov dword[z], eax
push dword[z]
push fmt0
call printf
add esp, 8
ret
