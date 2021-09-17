INCLUDE Irvine32.inc 

displayLogo PROTO C
exitProgram PROTO C
input PROTO C
cusInput PROTO C

meal PROTO C
displayTakeOrDineIn PROTO C, x: DWORD
displayMenu PROTO C 
inputOrder PROTO C 
inputQuantity PROTO C
addOrder PROTO C

displayOrderHeader PROTO C
displayOrderDetails PROTO C, no: DWORD, itemSelected: DWORD, quantity: DWORD, subTotal: DWORD
displayGrandTotal PROTO C, x: DWORD

inputPaymentMethod PROTO C
inputPaymentAmount PROTO C, paymentMethod: DWORD, grandTotal: DWORD

displayResitHeader PROTO C, invNum: DWORD
displayPayment PROTO C, amountPaid: DWORD, change: DWORD


displayReportDetails PROTO C, no: DWORD, storeInvNum: DWORD, storePaymentMethod: DWORD, storeGrandTotal: DWORD
displayReportHeader PROTO C, countOrder: DWORD
displaySalesTotal PROTO C, sales: DWORD


inputRating PROTO C
calculatePercentage PROTO C, quotient: DWORD, remainder: DWORD, countOrder: DWORD, star: DWORD

displayRating PROTO C, countTotalRating: DWORD, count1: DWORD, count2: DWORD, count3: DWORD, count4: DWORD, count5: DWORD, countOrder: DWORD
displayRatingStar PROTO C, percentage: DWORD, star: DWORD
averageRating PROTO C quotient: DWORD, remainder: DWORD, totalRating: DWORD
isStaff PROTO C

inputStaffID PROTO C
displayInvalid PROTO C

continueInput PROTO C




;Menu(Item Price)
cheeseCake = 9
tiramisu = 7
milleCrepeCake = 9
brownies = 8
chocolateCake = 6
tea = 3
latte = 7
americano = 5



  

.data 

takeAway BYTE "Take Away", 0
dineIn BYTE "Dine In", 0
payDetails BYTE "Payment Method: ", 0
cash BYTE "Cash", 0
creditCard BYTE "Credit Card", 0
noOrderRecord BYTE "No ORDER RECORD", 0
displayPreviousSales BYTE "Previous Total Sales Amount: RM", 0
askForInvNum BYTE "Please enter Inv Number: ", 0
invalidInvNumMessage BYTE "Invalid Inv Number.", 0
ratingMessage BYTE "Take Note: This rating system only can be access by  our shop customer. ", 0
rating1Star BYTE "Percentage od customer rating 1 star: ", 0
rating2Star BYTE "Percentage od customer rating 2 star: ", 0
rating3Star BYTE "Percentage od customer rating 3 star: ", 0
rating4Star BYTE "Percentage od customer rating 4 star: ", 0
rating5Star BYTE "Percentage od customer rating 5 star: ", 0


userType DWORD ?
selectedModule DWORD ?

takeOrDineIn DWORD 54H ;T

noItem DWORD 1  ;Use for display purpose
itemSelected DWORD 5 dup(?) ;array to store food and drinks selected
quantity DWORD 5 dup (?)  ;array to store the quantity
subTotal DWORD 5 dup(?)  ;Store the sub Total (quantity * unitPrice)

respondOnAddOrder DWORD 59H ;Y(Yes)

grandTotal DWORD 0 
paymentMethod DWORD ?
amountPaid DWORD ?
change DWORD ?

orderNum DWORD 1  ;orderNum to calculate how many food customer order (same as order item)
invNum DWORD 1000


arrSizeOrder DWORD 0	;Use as array Size
countOrder DWORD 1		;how many order per day
storeGrandTotal DWORD 100 dup(?)
storePaymentMethod DWORD 100 dup(?)
storeInvNum DWORD 100 dup(?)
no DWORD 1 
sales DWORD 100 dup(?) ;array to store the total sales per day


;Rating
inputInvNum DWORD ?		;checkInvNum  before rating
inputRepeatRating DWORD 59H
countRating DWORD 0
countTotalRating DWORD 0
ratingNum DWORD 100 dup(?) 
count1 DWORD 0
count2 DWORD 0
count3 DWORD 0
count4 DWORD 0
count5 DWORD 0
ratingStar DWORD 0, 1, 2, 3, 4, 5	; To store the marks(?
countRatingStar DWORD 6 DUP(?)		;To store nummber of total customer rate for 1 star, 2 star, 3 star, 4 star ang 5 star
totalRating DWORD ?	;countTotalRating * 5
sum DWORD 0


quotient DWORD 6 DUP(?)
remainder DWORD 6 DUP(?)
quotientAvg DWORD ?
remainderAvg DWORD ?
ratingPercentage DWORD 6 DUP(?)



noRatingMessage BYTE "No Rating Record", 0		;no customer rating
noCusRateMessage BYTE "No order made. Percentage Rating is NULL. ", 0




inputExit DWORD 59H
staffRespond DWORD 59H

;Staff ID and Password
staffID DWORD 12321, 12343, 12456, 12783, 12472
PwEncrypted DWORD 097890H, 897430H, 467590H, 253480H, 234350H
staffPassword DWORD 09789, 89743, 46759, 25348, 23435

countRepeatLogin DWORD 0
inputPw BYTE "Enter Password: ", 0
validMessage BYTE "~~~Login Successfully~~~", 0
invalidMessage BYTE "Login Unsuccessfully", 0
bufferMessage BYTE "Exceeded 3 attempts. Login again in 1 minutes to continue .", 0  ;Delay, wrong password 

inputID DWORD ?
inputPassword DWORD ?
validID DWORD 4EH	;N
respond DWORD 59H



.code 

;1st function

startProgram PROC C


; For sales report
mov  no, 1

call crlf
INVOKE displayLogo  ;displayLogo

.WHILE (inputExit == 59h)

	INVOKE input

	mov userType, EAX
		

.IF (userType == 1)
		
		INVOKE cusInput

		call crlf

		mov selectedModule, EAX	;order or rating

		.IF (selectedModule == 1)

			mov EAX, invNum
			mov ESI, arrSizeOrder
			mov storeInvNum[ESI], EAX

			mov grandTotal, 0
			mov ESI, 0
			mov EAX, 0
	
			mov noItem, 1
			mov orderNum, 1			;same as noItem

			mov respondOnAddOrder, 59H

			call HowToEat

			add arrSizeOrder, 4
			inc  countOrder
			inc invNum

		.ELSEIF (selectedModule == 2)
			JMP checkInvNum
			;call rating
		.ENDIF

.ELSEIF (userType == 2)	;Staff

		INVOKE isStaff
		mov staffRespond, EAX
		.IF (staffRespond == 59H)			
			call login	

			;exit
		.ELSE
			JMP startProgram
		.ENDIF
.ELSEIF (userType == 3)
		exit
	
.ENDIF

	INVOKE exitProgram
	mov inputExit, EAX



.ENDW

ret
startProgram ENDP



;2nd Function
HowToEat PROC C	; take Away or dine in

mov EAX, 0
mov EBX, 0

INVOKE meal

mov takeOrDineIn, EDX


.IF takeOrDineIn == 54H
	mov EDX, offset takeAway
.ElseIf takeOrDineIn == 44H
	mov EDX, offset dineIn
.ENDIF

call WriteString
call Crlf

call orderDetails  ;Function to calculate  price
call order			;Display all the order details
call payment


call printResit

ret
HowToEat ENDP



;3rd Function
orderDetails PROC C

mov EAX, 0
mov ESI, 0
mov EBX, 0

.WHILE respondOnAddOrder == 59H ;respond = yes

	INVOKE displayMenu
	;Select food and drinks (make order)
	INVOKE inputOrder
	mov itemSelected[ESI], EAX  ;Store the food and drinks Number that selected by customer

	;Quantity of the item selected
	INVOKE inputQuantity
	mov quantity[ESI], EAX ;Store quantity  ;Store the quantity of the selected item

	.IF itemSelected[ESI] == 1
		mov EBX, cheeseCake
	.ELSEIF itemSelected[ESI] == 2
		mov EBX, tiramisu
	.ELSEIF itemSelected[ESI] == 3
		mov EBX, milleCrepeCake
	.ELSEIF itemSelected[ESI] == 4
		mov EBX, brownies
	.ELSEIF itemSelected[ESI] == 5
		mov EBX, chocolateCake
	.ELSEIF itemSelected[ESI] == 6
		mov EBX, tea
	.ELSEIF itemSelected[ESI] == 7
		mov EBX, latte
	.ELSEIF itemSelected[ESI] == 8
		mov EBX, americano
	.ENDIF

	;Sub Total = Unit price of item * quantity
	mov EAX, quantity[ESI]
	mul EBX				;eax = eax * ebx = edx:eax

	mov subTotal[ESI], EAX  ;Sub Total

	add grandTotal, EAX	;totalPrice += eax

	add ESI, 4
	inc orderNum
	INVOKE addOrder
	mov respondOnAddOrder, EAX

.ENDW

mov ESI, 0
mov EDX, 0
mov ESI, arrSizeOrder
mov EDX, grandTotal
mov storeGrandTotal[ESI], EDX



ret 
orderDetails  ENDP 



;4th Function

order PROC C 

dec orderNum

INVOKE displayOrderHeader

mov ECX, 0
mov ECX, orderNum
mov ESI,0
mov noItem, 1

printOrder: 
	push ECX

	mov EAX, 0
	mov EAX, itemSelected[ESI]

	mov EBX, 0
	mov EBX, quantity[ESI]
	mov EDX, 0
	mov EDX, subTotal[ESI]

	INVOKE displayOrderDetails, noItem, EAX, EBX, EDX
	
	POP ECX
	inc noItem
	add ESI, 4
LOOP printOrder



INVOKE displayGrandTotal, grandTotal
call crlf

mov EAX, grandTotal
add sales, EAX


ret 
order  ENDP 





;5th Function

payment PROC C

INVOKE inputPaymentMethod
mov paymentMethod, EAX


mov EDX, 0
mov EDX, offset payDetails
call WriteString

.IF paymentMethod == 1
	mov EDX, offset cash
.ELSEIF paymentMethod == 2
	mov EDX, offset creditCard
.ENDIF

call WriteString
call crlf

mov EBX, 0
mov ESI, 0

mov ESI, arrSizeOrder
mov EBX, paymentMethod
mov storePaymentMethod[ESI], EBX


mov EBX, 0
mov ESI, 0



INVOKE inputPaymentAmount, paymentMethod, grandTotal

;Calculate Change amount
mov amountPaid, EAX
sub EAX, grandTotal ;Change = AmountPaid - GrandTotal

mov change, EAX

ret
payment ENDP




;6th Function
printResit PROC C

INVOKE displayResitHeader, invNum

.IF paymentMethod == 1
	mov EDX, offset cash
.ELSEIF paymentMethod == 2
	mov EDX, offset creditCard
.ENDIF

call WriteString
call crlf

INVOKE displayOrderHeader


mov ECX, 0
mov ECX, orderNum
mov ESI, 0
mov noItem, 1

printOrder: 
	push ECX
	mov EAX, 0
	mov EAX, itemSelected[ESI]

	mov EBX, 0
	mov EBX, quantity[ESI]
	mov EDX, 0
	mov EDX, subTotal[ESI]


	INVOKE displayOrderDetails, noItem, EAX, EBX, EDX
	
	POP ECX
	inc noItem
	add ESI, 4
LOOP printOrder

INVOKE displayGrandTotal, grandTotal
INVOKE displayPayment, amountPaid, change

call crlf

ret
printResit ENDP



;7th function
displayReport PROC C

call crlf
;Save previous total sales 
;mov EDX, offset displayPreviousSales
;call WriteString

;mov EAX, previousSales
;call WriteDec
;call Crlf

.IF countOrder == 1 ;1 = no order
	call crlf
	mov EDX, offset noOrderRecord
	call WriteString
	call Crlf
	dec countOrder
	call Crlf
	mov EDX, offset noCusRateMessage
	call WriteString
	call Crlf


.ELSE
	mov EAX, 0
	mov EBX, 0
	mov ECX, 0
	mov EDX, 0

	dec countOrder

	INVOKE displayReportHeader, countOrder


	mov ECX, countOrder
	mov ESI, 0

printResitDetails: 

	push ECX	
	
	mov EAX, 0	
	mov EAX, storeInvNum[ESI]

	mov EBX, 0
	mov EBX, storePaymentMethod[ESI]
	mov EDX, 0
	mov EDX, storeGrandTotal[ESI]

	INVOKE displayReportDetails, no, EAX, EBX, EDX
	

	inc no
	POP ECX
	add ESI, 4

LOOP printResitDetails


	;mov EAX, sales
	;mov previousSales, EAX

	INVOKE displaySalesTotal, sales
	call crlf

	

	mov EAX, countTotalRating
	;mov countRatingStar[0], EAX	;total number of customer rate 

	mov EBX, 5
	mul EBX
	mov totalRating, EAX  ;totalRating = countTotalRating * 5

	 
	mov EAX, count1	
	mov countRatingStar[4], EAX

	mov EAX, count2
	mov countRatingStar[8], EAX

	mov EAX, count3
	mov countRatingStar[12], EAX

	mov EAX, count4
	mov countRatingStar[16], EAX

	mov EAX, count5
	mov countRatingStar[20], EAX

	mov sum, 0
	
	.IF countTotalRating == 0
		mov EDX, offset noRatingMessage

	.ELSE



		mov ESI, 4
		mov ECX, 5
		calculateRating:
		
		PUSH ECX

		mov EAX, countRatingStar[ESI]	
		mov EBX, ratingStar[ESI]	
		mul EBX		; example: count1 * 1 ;get the rating marks
		add sum, EAX
		;mov totalRatingStar[ESI], EAX

		POP ECX
		add ESI, 4

		LOOP calculateRating	
		
		mov EDX, 0
		mov EAX, sum

		mov EBX, totalRating
		DIV EBX

		mov quotientAvg, EAX
		mov remainderAvg, EDX

 		mov ECX, 5
		mov ESI, 4

		calForStar:  ;Percentage of how many  percent of customer rate for each star
		
		mov EDX, 0

		mov EAX, countRatingStar[ESI]	
		mov EBX, countTotalRating 
		DIV EBX
		
		mov quotient[ESI], EAX
		mov remainder[ESI], EDX

		add ESI, 4
			
		LOOP calForStar



		
	.ENDIF

		mov EDX, 0

		INVOKE displayRating, countTotalRating, count1, count2, count3, count4, count5, countOrder
		
		mov EDX, 1
		INVOKE calculatePercentage, quotient[4], remainder[4], countTotalRating, EDX
		mov EDX, 2
		INVOKE calculatePercentage, quotient[8], remainder[8], countTotalRating, EDX
		mov EDX, 3
		INVOKE calculatePercentage, quotient[12], remainder[12], countTotalRating, EDX
		mov EDX, 4
		INVOKE calculatePercentage, quotient[16], remainder[16], countTotalRating, EDX
		mov EDX, 5
		INVOKE calculatePercentage, quotient[20], remainder[20], countTotalRating, EDX



		INVOKE averageRating, quotientAvg, remainderAvg, totalRating
		call crlf


.ENDIF

inc countOrder

JMP startProgram	;Jump back to the starting of the program
	

ret
displayReport ENDP





;8th Function
rating PROC C  

INVOKE inputRating

mov ESI, countRating
mov ratingNum[ESI], EAX

inc countTotalRating

.IF ratingNum[ESI] == 1
	inc count1
.ELSEIF ratingNum[ESI] == 2
	inc count2
.ELSEIF ratingNum[ESI] == 3
	inc count3
.ELSEIF ratingNum[ESI] == 4
	inc count4
.ELSEIF ratingNum[ESI] == 5
	inc count5
.ENDIF

add countRating, 4
JMP startProgram

ret
rating ENDP



;9th function
checkInvNum PROC C

mov EDX, offset ratingMessage 
call WriteString

call crlf
call crlf
mov EDX, offset askForInvNum
call WriteString
call ReadDec
mov inputInvNum, EAX
mov ESI, 0

mov ECX, countOrder

	check: 
		mov EAX, storeInvNum[ESI]
		cmp inputInvNum, EAX		
		JE validInvNum

		add ESI, 4
	LOOP check

JMP invalidInvNum

validInvNum:
	call rating


invalidInvNum:
	
	call crlf
	mov EDX, offset invalidInvNumMessage
	call WriteString
	call crlf
	call repeatInvNum


ret 
checkInvNum ENDP




;10th Function
repeatInvNum PROC C

INVOKE continueInput
mov inputRepeatRating, EAX

.IF inputRepeatRating == 59H
	call checkInvNum
.ELSE
	JMP startProgram
.ENDIF

ret
repeatInvNum ENDP




;11th Function
;Ask user want to continue login or exit program
repeatLogin PROC C

INVOKE continueInput
mov respond, EAX

.IF respond == 59H 

	add  countRepeatLogin, 1
	.IF countRepeatLogin == 3
		JMP Buffer
	.ELSE 
		call login		
	.ENDIF

.ELSE
	mov countRepeatLogin, 0
	JMP startProgram
.ENDIF

;Input 3 times invalid staff id and password, user need tp wait for 1 min to continue login (Delay)
Buffer: 
	call crlf
	mov  EDX, offset bufferMessage
	call WriteString
	mov EAX, 100000
	call delay
	call crlf
	call crlf
	mov EBX, 0
	call repeatLogin


ret 
repeatLogin ENDP








;12th Function
login PROC C
	
mov EAX, 0
mov EBX, 0
mov ECX, 0
mov EDX, 0


getInput: 

	INVOKE inputStaffID
	MOV inputID, EAX
	
	mov EDX, offset inputPw
	call WriteString
	call ReadHex

	mov inputPassword, EAX
	JMP checkID

checkID: 

	mov ECX, lengthOf staffID
	mov ESI, 0

	check: 

		mov EAX, staffID[ESI]
		cmp inputID, EAX		
		JE checkPassword

		add ESI, 4


	LOOP check

JMP invalidStaff

Exit

checkPassword:	

	mov EAX, PWEncrypted[ESI]
	
	shl inputPassword, 4
	cmp inputPassword, EAX
	JE validStaff
	JNE invalidStaff



validStaff:
	call Crlf
	mov EDX, offset validMessage
	call WriteString
	call crlf
	call displayReport
	

invalidStaff:
	
	call crlf
	mov EDX, offset invalidMessage
	call WriteString
	call crlf

	call crlf
	INVOKE displayInvalid

	call repeatLogin

ret
login ENDP








END 