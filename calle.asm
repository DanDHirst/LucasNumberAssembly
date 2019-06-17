
.386 ; Specify instruction set
.model flat, stdcall ; Flat memory model, std. calling convention
.stack 4096 ; Reserve stack space
; Define functions that you would like to use from cpp file
readInteger PROTO C ; this allows us to use readInteger function in the

; main cpp file and it owuld use cdecl calling convention
printInteger PROTO C ; this allows us to use integer printing facility
printString PROTO C ; This allows us to print strings -- we need to
; send the address of the first letter for this to
; work.

.data ; data segment
; define your variables here
n DWORD ? ; this uninitialised varibale will hold n
nMinusOne DWORD ? ;n-1 stored
nMinusTwo DWORD ? ; n-2 stored
x DWORD 1; loop counter starting at 1 due to if n is 0 or 1 is unecessary
firstVal DWORD 2 ; starting value for lucas numbers
secondVal DWORD 1 ; second value of a lucas number
lastVal DWORD ? ; used for the last previous number n-1
lastValMinusOne DWORD ? ;n-2
quotient DWORD ? 
remainder DWORD ?
currentValue DWORD ? ; used for the current lucas number

prompt BYTE "Enter an integer: ", 0 ; string for prompting an input.
showQuotient BYTE "The result is: ", 0 ; string for showing quotient.
showRemainder BYTE "remainder: ", 0 ; string for showing remainder.
showLucas BYTE "Lucas Number: ", 0 ; string for showing lucas number.
showLucasMinusOne BYTE "Lucas Number - 1: ", 0 ; string for showing lucas number minus 1 ln(n-1).

.code ; code segment
addFunc PROC C ; cdecl calling convention -- callee

	; show prompt for n
	lea ebx, prompt ; get the address of the first letter
	push ebx ; push the address so that print function can access it
	call printString ; call printing function
	add esp, 4 ; remove reference to string from stack
	; read the first integer by calling the CPP fucntion
	call readinteger
	mov n, eax 

	;calculate lucas number for given n
	cmp n, 0;compare to see if value is 0
	JE setnto2 ;jump to set n to 1 
	cmp n,1 ; compare n to check if value is 1
	JE setnto1 ;jump to set n to 1
	
	;calcualte n-1
	mov ebx ,n ; move val of n to ebx
	sub ebx, 1
	mov edx,firstVal
	mov lastValMinusOne, edx ; assign n-2 to lastvalminusone
	mov edx, secondVal
	mov lastVal,edx ; assign n-1 to lastval 
	mov ecx, lastVal ; move lastval into ecx n-1
	add ecx,lastValMinusOne; add n-1 + n-2
	mov currentValue, ecx 
		
	whileLoop: ; loop for calulating n
		mov edx, lastVal
		mov lastValMinusOne, edx ;move lastval into new value
		mov edx, currentValue
		mov lastVal, edx ;set current value to last value
		inc x; x++
		mov ecx, lastVal ; move lastval into ecx n-1
		add ecx,lastValMinusOne; add n-1 + n-2
		mov currentValue, ecx 

		cmp x,ebx ; compare x to ebx
		jne whileLoop ; loop if less than n-1
		mov edx, lastVal
		mov nMinusOne, edx ; move last val into nMinusOne
		mov edx, lastValMinusOne
		mov nMinusTwo, edx ; move lastvalMinus one into last value minus 2
		lea ebx, currentValue ; set memory address for to ebx of current value for memory inspecting
		jmp Done ; jump to done
		
	
	setnto2:
		mov currentValue, 2
		mov nMinusOne,1
		jmp Done
	setnto1:
		mov currentValue, 1
		mov nMinusOne,2

	Done:
		;calulate the ratio
		;div ln / ln-1
		mov edx, 0
		mov eax, currentValue ; move ln(n) into dividend
		mov ecx, nMinusOne ; move ln(n-1) into divisor
		div ecx
		mov quotient, eax
		mov remainder, edx

	; show lucas number 
	lea ebx, showLucas ; get the address of the first letter
	push ebx ; push the address so that print function can access it
	call printString ; call printing function
	add esp, 4 ; remove reference to string from stack
	; push current value into the stack and then call print function
	push currentValue ; without pushing sum the function in CPP will not know
	; where to get the value.
	call printInteger
	add esp, 4 ; remove reference to sum from the stack

	; show lucas number -1
	lea ebx, showLucasMinusOne ; get the address of the first letter
	push ebx ; push the address so that print function can access it
	call printString ; call printing function
	add esp, 4 ; remove reference to string from stack
	; push nMinusOne into the stack and then call print function
	push nMinusOne ; without pushing nMinusone the function in CPP will not know
	; where to get the value.
	call printInteger
	add esp, 4 ; remove reference to sum from the stack

	; show Quotient 
	lea ebx, showQuotient ; get the address of the first letter
	push ebx ; push the address so that print function can access it
	call printString ; call printing function
	add esp, 4 ; remove reference to string from stack
	; push quotient into the stack and then call print function
	push quotient ; without pushing quotient the function in CPP will not know
	; where to get the value.
	call printInteger
	add esp, 4 ; remove reference to sum from the stack

	; show remainder 
	lea ebx, showRemainder ; get the address of the first letter
	push ebx ; push the address so that print function can access it
	call printString ; call printing function
	add esp, 4 ; remove reference to string from stack
	; push sum into the stack and then call print function
	push remainder ; without pushing remainder the function in CPP will not know
	; where to get the value.
	call printInteger
	add esp, 4 ; remove reference to sum from the stack
	; return function control to cpp
	ret
	; note we didn't invoke an ExitProcess here as entry and exit is
	; controller by cpp.
addFunc ENDP
END