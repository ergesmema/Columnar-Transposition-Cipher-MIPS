.data
 prompt: .asciiz "Encrypt(E) or Decrypt(D) ?"
 indata: .space 20
 text: .asciiz "Enter text: "
 data: .space 256
 Key: .asciiz "Key ?"
 WrongKeyword: .asciiz "\nInvalid character\n"
 WrongKey: .asciiz "\nInvalid key (positive integer needed)\n"
 space: .asciiz "\n"

.text
 
main:

 Text:
 # ask user to enter text
 la $a0,text
 li $v0,4
 syscall
 # store text in the reserved space of 256 bits (256 characters can be read)
 la $a0, data
 la $a1,256  			
 li $v0,8
 syscall
 # copy string(char array) to register $t0
 la $t0,($a0) 			
 la $t9, ($a0)
 # initialie variable to store string length
 li $t1,0 			
 Action:
 # print statement to ask user for action
 la $a0,prompt
 li $v0,4
 syscall
 
 # read user input and store it in $s3
 la $a0,indata
 la $a1,5
 li $v0,8
 syscall 
 lb $s3,0($a0)
 
 # check if action entered by user is acceptable (E/e or D/d), and branch to read key
 # check if $s3 is D
 beq $s3,68,ReadKey
 # check if $s3 is d
 beq $s3,100,ReadKey
 # check if $s3 is E
 beq $s3,69,ReadKey
 #check if $s3 is e
 beq $s3,101,ReadKey
 
 # print error if action is invalid
 la $a0,WrongKeyword
 li $v0,4
 syscall
 # ask for action again
 j Action
 
 InvalidKey:
 # print error if key is invalid
 la $a0,WrongKey
 li $v0,4
 syscall
 # ask for key again
 j ReadKey
 
 ReadKey:
 # print statement to ask user for key
 la $a0,Key
 li $v0,4
 syscall
 # accept user input
 li $v0,5
 syscall
 # branch if key is not positive integer
 blez $v0, InvalidKey
 # store user input of key at $t3
 move $t3,$v0 		
 
 # loop to count string length
 countStringLength:
 	# load character(byte) to $t4
 	lb $t4, 0($t0)
 	# branch if $t4 equals '\n', which means string's end
 	beq $t4,10,numberOfRows 
 	# branch if $t4 equals 0	 	
 	beqz $t4,numberOfRows
 	# increment char array index by 1 
 	addi $t0, $t0, 1
 	# increment counter (string length) by 1
 	addi $t1,$t1,1
 	# jump to the beginning of loop
 	j countStringLength
 
 # calculating number of rows
 numberOfRows:
 	# dividing string length / number of columns, key=number of columns
 	divu $t1, $t3
 	# store remainder in $t6
 	mfhi $t6
 	# branch if remainder is greater than 0
 	bgtz $t6, numberOfRows2
 	# else store quotient (number of rows) in $t6, 
 	mflo $t6	
 	# jump to calculate size of 2-dimensional array to be created		
 	j sizeOfMatrix 
 	
 # continuing calculation of row numbers if remainder > 0
 numberOfRows2:
 	# store quotient in $t6
 	mflo $t6
 	# increment quotient by 1 and store it in $t6 (number of rows)
 	addi $t6, $t6, 1
 	
 # calculating size of two dimensional array	
 sizeOfMatrix:
 	# total number of elements = rows*key, stroing it in $s0
 	mul $s0, $t6, $t3  	
 	# calculating number of padding needed (empty entries of the array) = sizeOfMatrix-stringLength
 	sub $s1, $s0, $t1		
 	
 # padding empty entries of array	
replacePadding:
 	# loading the underscore (_) character in $s2
	li $s2,95
	# branch if there is no more padding needed
	beq $s1, $zero, initializeMatrix0
	# since $t0 is already at the first entry to be padded (before stopped at end of stringLength)
	sb $s2, 0($t0)
	# increment char array index by 1
	addi $t0, $t0, 1
	# decrement padding number
	addi $s1, $s1, -1
	# jump to the beginning of loop
	j replacePadding

# copy from string (char array) to two-dimensional array (matrix)
initializeMatrix0:
    	# branch to change values if user wants decryption
   	beq $s3,68, changeValues
   	beq $s3,100, changeValues
   	# else continue with copying
    	j initializeMatrix
    	
# changing values, to enable decrypting transposition using the same function as encryption
changeValues:
   	# add key (column) value to temporary register $t2
    	addi $t2, $t3,0
    	# set key value to row value
    	addi $t3, $t6, 0
    	# set row value to initial key value saved in temp
    	addi $t6, $t2,0    

initializeMatrix:
    	# initialize rowIndex (i) outer-loop counter to 0
    	li $t2, 0               
    	# set index of $t0 to 0
    	la $t0, 0($t9)	    	
   
   
initializeMatrixRow:
	# check if outer loop reached maximum and branch
    	bge $t2, $t6, startTransposition
    	# initialize columnIndex inner-loop counter to 0
    	li $t7, 0               
    
initializeMatrixColumn:
    	# branch if inner loop reached maximum and branch
    	bge $t7, $t3 , loopEnd
	# multiply columnSize * rowIndex
    	multu  $t3, $t2  
    	# store mupltiplication value in $t5     
    	mflo $t5
    	# add columnIndex in $t5 = (columnSize * rowIndex) + columnIndex
    	add $t5, $t5, $t7       
    	
    	# since we are using ASCII, and characters are 1 byte we don't need an instruction to multiply with dataSize
    	#(dataSize * (columnSize * rowIndex + columnIndex)
    	
    	# add base address in $t5 = baseAddress + (dataSize * (columnSize * rowIndex + columnIndex))
    	# in case of decryption formula after changeValues is: baseAddress + (dataSize * (columnIndex * rowSize + rowIndex)) 
    	add $t5, $t9, $t5       
	
	# jump and link to copyToMatrix function, that copies values from character array to two dimensional array
	jal copyToMatrix
	
	# increment inner-loop (j) counter
    	addiu $t7, $t7, 1       
	# branch unconditionally back to beginning of the inner loop
    	b initializeMatrixColumn    

loopEnd:
	# increment outer-loop (i) counter 
    	addiu $t2, $t2, 1      
    	# branch unconditionally back to beginning of the outer loop 
    	b initializeMatrixRow    
    
    
copyToMatrix:
   	# load bytes from char array in $t0
   	lb $a0, 0($t0)
   	# store bytes loaded to two dimensional array $t5
   	sb $a0, 0($t5)
   	# increment char array index by 1
    	addi $t0,$t0,1
    	# jump back to the caller
    	jr $ra
    

# columnar transposition
startTransposition: 
	# print new line
    	addi $v0, $zero, 4  	
    	la $a0, space       	
    	syscall
    	# initialize outer-loop counter to 0
	li $t7, 0               	

initializeTranspositionOuterLoop:
	# branch if outer loop reaches maximum
    	bge $t7, $t3, programEnd
    	# initialize inner-loop counter to 0
    	li $t2, 0              	 

initializeTranspositionInnerLoop:
	# branch if inner loop reaches maximum
    	bge $t2, $t6 , transpositionLoopEnd
    	# multiply columnSize * rowIndex
    	multu  $t3, $t2      	 
    	# store multiplication value in $t5
    	mflo $t5
    	# add columnIndex to $t5 = columndIndex + (columnSize * rowIndex) 
    	add $t5, $t5, $t7     	
    	
    	# since we are using ASCII, and characters are 1 byte we don't need an instruction to multiply with dataSize
    	#(dataSize * (columnSize * rowIndex + columnIndex)
    	   
    	# add base address to $t5 = baseAddress + (dataSize * (columnSize * rowIndex + columnIndex))
    	add $t5, $t9, $t5    	 
	
	# load character from matrix to $a0 and print it    
    	lb $a0, ($t5)
    	li $v0,11
    	syscall
   
        # increment inner-loop counter
    	addiu $t2, $t2, 1      

	# branch unconditionally back to beginning of the inner loop
    	b initializeTranspositionInnerLoop    

transpositionLoopEnd:
	# increment outer-loop counter
    	addiu $t7, $t7, 1  
    	
	# branch unconditionally back to beginning of the outer loop
    	b initializeTranspositionOuterLoop    
    
programEnd:
    # terminate program
    li $v0,10
    syscall
