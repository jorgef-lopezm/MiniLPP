global main
extern printf
section .data
true dd 1
false dd 0
b dd 0
a dd 0
const3 dd 473
const2 dd 374
const0 dd 567
const1 dd 765
temp0 dd 0
temp1 dd 0
temp2 dd 0
fmt0 db "%d", 0

section .text
Suma:
push ebp
mov ebp, esp
sub esp, 0
mov eax, dword[ebp + 8]
add eax, dword[ebp + 12]
mov dword[temp0],eax
push dword[temp0]
push fmt0
call printf
add esp, 8
mov esp, ebp
pop ebp
ret
main:
mov eax, dword[const0]
mov dword[a], eax
mov eax, dword[const1]
mov dword[b], eax
push dword[b]
push dword[a]
call Suma
add esp, 8
mov dword[temp1], eax
mov eax, dword[const2]
mov dword[a], eax
mov eax, dword[const3]
mov dword[b], eax
push dword[b]
push dword[a]
call Suma
add esp, 8
mov dword[temp2], eax
ret