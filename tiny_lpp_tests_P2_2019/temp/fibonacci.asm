global main
extern printf
section .data
true dd 1
false dd 0
f dd 0
const13 dd 13
const12 dd 12
const11 dd 11
const10 dd 10
const9 dd 9
const8 dd 8
const7 dd 7
const6 dd 6
const1 dd 1
const0 dd 0
const2 dd 2
const3 dd 3
const4 dd 4
const5 dd 5
temp0 dd 0
temp1 dd 0
temp10 dd 0
temp11 dd 0
temp12 dd 0
temp13 dd 0
temp14 dd 0
temp15 dd 0
temp16 dd 0
temp17 dd 0
temp18 dd 0
temp19 dd 0
temp2 dd 0
temp20 dd 0
temp21 dd 0
temp3 dd 0
temp4 dd 0
temp5 dd 0
temp6 dd 0
temp7 dd 0
temp8 dd 0
temp9 dd 0
fmt0 db "%d", 0

section .text
fibonacci:
push ebp
mov ebp, esp
sub esp, 12
mov eax, dword[ebp + 8]
cmp eax, dword[const0]
sete al
cbw
cwd
mov dword[temp0], eax
mov eax, dword[ebp + 8]
cmp eax, dword[const1]
sete al
cbw
cwd
mov dword[temp1], eax
mov eax, dword[temp0]
or eax, dword[temp1]
mov dword[temp2],eax
cmp dword[temp2], 0
je label0
mov eax, dword[const1]
mov esp, ebp
pop ebp
ret
jmp label1
label0:
mov eax, dword[ebp + 8]
sub eax, dword[const1]
mov dword[temp4],eax
push dword[temp4]
call fibonacci
add esp, 4
mov dword[temp3], eax
mov eax, dword[ebp + 8]
sub eax, dword[const2]
mov dword[temp6],eax
push dword[temp6]
call fibonacci
add esp, 4
mov dword[temp5], eax
mov eax, dword[temp3]
add eax, dword[temp5]
mov dword[temp7],eax
mov eax, dword[temp7]
mov esp, ebp
pop ebp
ret
label1:
mov esp, ebp
pop ebp
ret
main:
push dword[const0]
call fibonacci
add esp, 4
mov dword[temp8], eax
mov eax, dword[temp8]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const1]
call fibonacci
add esp, 4
mov dword[temp9], eax
mov eax, dword[temp9]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const2]
call fibonacci
add esp, 4
mov dword[temp10], eax
mov eax, dword[temp10]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const3]
call fibonacci
add esp, 4
mov dword[temp11], eax
mov eax, dword[temp11]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const4]
call fibonacci
add esp, 4
mov dword[temp12], eax
mov eax, dword[temp12]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const5]
call fibonacci
add esp, 4
mov dword[temp13], eax
mov eax, dword[temp13]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const6]
call fibonacci
add esp, 4
mov dword[temp14], eax
mov eax, dword[temp14]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const7]
call fibonacci
add esp, 4
mov dword[temp15], eax
mov eax, dword[temp15]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const8]
call fibonacci
add esp, 4
mov dword[temp16], eax
mov eax, dword[temp16]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const9]
call fibonacci
add esp, 4
mov dword[temp17], eax
mov eax, dword[temp17]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const10]
call fibonacci
add esp, 4
mov dword[temp18], eax
mov eax, dword[temp18]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const11]
call fibonacci
add esp, 4
mov dword[temp19], eax
mov eax, dword[temp19]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const12]
call fibonacci
add esp, 4
mov dword[temp20], eax
mov eax, dword[temp20]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
push dword[const13]
call fibonacci
add esp, 4
mov dword[temp21], eax
mov eax, dword[temp21]
mov dword[f], eax
push dword[f]
push fmt0
call printf
add esp, 8
ret
