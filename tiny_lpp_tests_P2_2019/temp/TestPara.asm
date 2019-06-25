global main
extern printf
section .data
true dd 1
false dd 0
i dd 0
const1 dd 100
const0 dd 1
fmt0 db "%d", 0

section .text
main:
mov eax, dword[const0]
mov dword[i], eax
label0:
mov eax, dword[const1]
cmp dword[i], eax
jg label1
push dword[i]
push fmt0
call printf
add esp, 8
inc dword[i]
jmp label0
label1:
ret
