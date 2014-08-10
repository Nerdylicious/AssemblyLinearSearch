;Author: Irish Medina

;Purpose: A linear search in an unsorted array. Returns the position of the element if found.

;R0 - the position where the element is found (-1 if not found)
;R1 - the number to search for
;R2 - the number of elements in array n
;R3 - the address of the array
;R4 - current value working with
;R5 - the negation (the opposite sign) of the number to search for
;R6 - the difference in the value to search for and the current value
;R7 - bit 48

	.orig x3000

	and 	r0,r0,#0
	and 	r1,r1,#0
	and	r2,r2,#0
	and	r3,r3,#0
	and	r4,r4,#0
	and	r5,r5,#0
	and	r6,r6,#0
	and	r7,r7,#0
	
	ld	r7,bit_48	;need a bit 48 to find correct ASCII value later
	ld	r1,key		;store number to search for in r1

	add	r0,r0,#-1	;assume not found at first

	not	r5,r1		;not it
	add	r5,r5,#1	;then add one to get is opposite sign
	
	ld	r2,n		;store the number of elements in r2
	lea	r3,data		;store the starting address of array in r3

	add	r2,r2,#-1	;the current index to get
	
	brn	done		;done if index <= 0
	add	r3,r3,r2	;compute position of last element

loop
	and	r4,r4,#0	;clear r4
	ldr	r4,r3,#0	;load content in array to r4

	and	r6,r6,#0
	add	r6,r5,r4	;take the current value and add it to the
				;value to search for's negative value

	brnp	loop_cont	;if not found then keep looping
	brz	if_found	;if the sum is zero then the value has been found


if_found
	
	and	r6,r6,#0	;use r6 temporarily
	add	r6,r2,#-9	;check to see if the position is >9


	
	brnz	if_less_than	;then pos <= 9
	brp	if_greater_than	;then pos > 9


if_less_than

	and	r0,r0,#0
	lea	r0,is_found_message
	puts
	
	and	r7,r7,#0
	ld	r7,bit_48

	and	r0,r0,#0
	add	r0,r0,r2	;if the value is found store it's position in r0
	add	r0,r0,r7	;it must take on its ASCII encoding
	
	OUT

	br	done


if_greater_than
	
	and	r0,r0,#0
	lea	r0,is_greater_message
	puts
	
	br	done

	
loop_cont	

	add	r3,r3,#-1	;move to previous element
	add	r2,r2,#-1	;decrease number of elements left

	brzp 	loop		;keep looping if number elements still positive or zero

	;otherwise we didn't find it
	;r0 will be -1 at this point (then cleared to output message)

	and	r0,r0,#0
	lea	r0,not_found_message
	puts

done

	and	r0,r0,#0
	lea	r0,eopMessage
	puts

	halt

bit_48	.fill	#48		;need this to print out position later
n	.fill	10		;array size

data	.fill	100
	.fill	29
	.fill	16
	.fill	-3
	.fill	3
	.fill	-23
	.fill	60
	.fill	123
	.fill	0
	.fill	-64

key	.fill	29

is_found_message	.stringz	"\nFound at position: "
not_found_message	.stringz	"\nNot found."
is_greater_message	.stringz	"\nFound at position: > 9"
eopMessage		.stringz	"\n\nProcessing complete.\n"

	.end
