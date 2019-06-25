global main
extern printf
section .data
true dd 1
false dd 0
const1 dd 379
const0 dd 837
temp0 dd 0
temp1 dd 0
fmt0 db "%d", 0

section .text
Suma:
push ebp
mov ebp, esp
sub esp, 0
mov eax, dword[ebp + 8]
add eax, dword[ebp + 12]
mov dword[temp0],eax
mov eax, dword[temp0]
mov esp, ebp
pop ebp
ret
mov esp, ebp
pop ebp
ret
main:
push dword[const0]
push dword[const1]
call Suma
add esp, 8
mov dword[temp1], eax
push dword[temp1]
push fmt0
call printf
add esp, 8
ret
