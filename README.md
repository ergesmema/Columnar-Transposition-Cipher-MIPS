# Columnar-Transposition-Cipher-MIPS

Encrypting a message in MIPS written in a horizontal grid with fixed width, and read off vertically in order to produce the cyphertext. The decryption is performed the same way around.

## Description

As an example, if the plaintext is “ATTACKATDAWN” and the grid width of 4, it is written as follows:

| A | T | T | A |
| C | K | A | T |
| D | A | W | N |

Reading it vertically will yield the ciphertext “ACDTKATAWATN”. To decrypt it, it will have to be written vertically into the same grid (height = 12/ 4 = 3) and read horizontally, to come up with the original plaintext.
The above example assumes that the length of 12 characters is an exact multiple of 4, so that a rectangle is perfectly formed. If this is not the case during encryption, the remaining empty cells are filled with padding(_).
Note: The text is in ASCII.

## Getting Started

### Dependencies

MARS is an acronym for MIPS Assembler and Runtime Simulator. It is an emulator developed at Missouri State University for the 32-bit MIPS ISA. MARS is written in Java language and therefore can be used on all operating systems that have the Java Virtual Machine installed. It is developed for learning purposes and published for such use under the MIT license. It provides many useful features for the testing and execution of programs written in assembly language. MARS offers a simple graphical user interface, easily editable register and memory values, step-by-step running and a command line for real time tests among others. 

### Comparison of variables in C++ and Assembly

A C++ version is included in the repository.

```
**C++		MIPS Assembly**
text		$t0, $t9 (backup)
action 		$s3
key		$t3
stringLength	$t1
rows		$t6
matrixSize	$s0
j		$t7
temp, i		$t2
_ (underscore)	$s2
matrix[i][j]	$t5
```

### Executing program

The .asm can be executed by using MARS.
The program will ask for the string to encrypt/decrypt, operation to perform (E/D) and the grid size to be used.
It will do any necessary validation of inputs and print error messages if inputs are invalid (such as negative grid width).

### Sample Output
```
Enter text: ATTACKATDAWN
Encrypt(E) or Decrypt(D): E
Enter key: 4
ACDTKATAWATN
```

## Authors

Contributors names and contact info:

Erges Mema  
[@MemaErges](https://twitter.com/memaerges)

## Version History

* 0.1
    * Initial Release


