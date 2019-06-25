global main
extern printf
section .data
true dd 1
false dd 0
c dd 0
a dd 0
b dd 0
const10 dd 9232
const9 dd 9236
const8 dd 5416
const7 dd 33876
const6 dd 53316
const12 dd 9231
const11 dd 5406
const0 dd 0
const13 dd 5395
const2 dd 567
const14 dd 9230
const4 dd 51492
const1 dd 134
const5 dd 20636
const3 dd 132
temp0 dd 0
temp1 dd 0
temp10 dd 0
temp2 dd 0
temp3 dd 0
temp4 dd 0
temp5 dd 0
temp6 dd 0
temp7 dd 0
temp8 dd 0
temp9 dd 0
fmt0 db "%d", 0

section .text
gcd:
push ebp
mov ebp, esp
sub esp, 0
mov eax, dword[ebp + 12]
cmp eax, dword[const0]
sete al
cbw
cwd
mov dword[temp0], eax
cmp dword[temp0], 0
je label0
mov eax, dword[ebp + 8]
mov esp, ebp
pop ebp
ret
jmp label1
label0:
mov eax, dword[ebp + 8]
mov ebx, dword[ebp + 8]
cdq
idiv ebx
mov dword[temp2], edx
push dword[temp2]
push dword[ebp + 12]
call gcd
add esp, 8
mov dword[temp1], eax
mov eax, dword[temp1]
mov esp, ebp
pop ebp
ret
label1:
mov esp, ebp
pop ebp
ret
main:
mov eax, dword[const1]
mov dword[a], eax
mov eax, dword[const2]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp3], eax
mov eax, dword[temp3]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
mov eax, dword[const3]
mov dword[a], eax
mov eax, dword[const2]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp4], eax
mov eax, dword[temp4]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
mov eax, dword[const4]
mov dword[a], eax
mov eax, dword[const5]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp5], eax
mov eax, dword[temp5]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
mov eax, dword[const6]
mov dword[a], eax
mov eax, dword[const7]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp6], eax
mov eax, dword[temp6]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
mov eax, dword[const8]
mov dword[a], eax
mov eax, dword[const9]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp7], eax
mov eax, dword[temp7]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
mov eax, dword[const8]
mov dword[a], eax
mov eax, dword[const10]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp8], eax
mov eax, dword[temp8]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
mov eax, dword[const11]
mov dword[a], eax
mov eax, dword[const12]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp9], eax
mov eax, dword[temp9]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
mov eax, dword[const13]
mov dword[a], eax
mov eax, dword[const14]
mov dword[b], eax
push dword[b]
push dword[a]
call gcd
add esp, 8
mov dword[temp10], eax
mov eax, dword[temp10]
mov dword[c], eax
push dword[c]
push fmt0
call printf
add esp, 8
ret
