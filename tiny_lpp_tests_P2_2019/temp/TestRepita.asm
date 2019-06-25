global main
extern printf
section .data
true dd 1
false dd 0
a dd 0
const1 dd 100
const0 dd 1
temp0 dd 0
temp1 dd 0
fmt0 db "%d", 0

section .text
main:
mov eax, dword[const0]
mov dword[a], eax
label0:
push dword[a]
push fmt0
call printf
add esp, 8
mov eax, dword[a]
add eax, dword[const0]
mov dword[temp1],eax
mov eax, dword[temp1]
mov dword[a], eax
mov eax, dword[a]
cmp eax, dword[const1]
setg al
cbw
cwd
mov dword[temp0], eax
cmp dword[temp0], 1
je label1
jmp label0
label1:
ret
