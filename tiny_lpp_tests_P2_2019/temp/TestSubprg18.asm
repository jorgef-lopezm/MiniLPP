global main
extern printf
section .data
true dd 1
false dd 0
b dd 0
a dd 0
const4 dd 473
const3 dd 374
const2 dd 765
const0 dd 1
const1 dd 567
fmt0 db "%d", 0

section .text
Suma:
push ebp
mov ebp, esp
sub esp, 0
push dword[const0]
push fmt0
call printf
add esp, 8
mov esp, ebp
pop ebp
ret
main:
mov eax, dword[const1]
mov dword[a], eax
mov eax, dword[const2]
mov dword[b], eax
mov eax, dword[const3]
mov dword[a], eax
mov eax, dword[const4]
mov dword[b], eax
ret
