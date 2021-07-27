#include <iostream>												//start program
#include <string>												//including required libraries
#include <cstring>
using namespace std;

//--declaring function headers
	int numberOfRows(int,int);
	int sizeOfMatrix(int,int);
	
int main() {													//start of main function
	
	string text;												//declaring variable text of type string to store the user input of ciphertext or plaintext
	char action;												//declaring variable actin of type char, to store user choice of encryption or decryption
	int key;													//declaring variable key of type int, to store user input of key (columnar width)
	cout<<"Enter text: ";										//ask user to enter text
	cin>>text;													//inputed text from user
	
    cout<<"Encrypt(E) or Decrypt(D): ";							//ask user to choose action
	cin>>action;												//inputed action from user
	
	if(action!='E' && action!='D'){								//checks if entered action is acceptable
	cout<<"Invalid character";									//if not show error
	return 0;													//end program
	}
	
	cout<<"Enter key: ";										//ask user for key
	cin>>key;													//inputed key from user

	int stringLength=text.length();								//find string length using predefined function length()
	int rows=numberOfRows(stringLength, key);					//call function to find number of rows and store it at rows
	int matrixSize=sizeOfMatrix(rows,key);						//call function to find number of elements inside matrix and store it at matrixSize
    
    char string[matrixSize];									//declaring character array to store string
    strcpy(string, text.c_str());								//copy from string to char array
	
//--replace padding with underscore (_)
	for(int i=0; i<matrixSize; i++){							//start of for loop to replace empty entries of array with underscore (_)
		if(string[i]=='\0'){									//if condition to check which entries are entry
		
			string[i]='_';										//padding with underscore (_)
		}	
	}
	
//--initalize values for decryption	
	if(action=='D')												//if condition to check if user's action is decription
	{
		int temp;												//exchanging values of rows and key with each other to enable decryption
		temp=key;												//set key to temp value
		key=rows;												//set key to value of rows
		rows=temp;												//set rows to value of key
	}
	
//--copy from char array to two dimensional char array
	char matrix[rows][key];										//declare matrix 2-dimensional array with size rows*key
	 
//--initializing for loop to populate 2-dimensional array with the entries of char array
	for( int i=0; i < rows; i++ ){								//initializong counter (i) for rows												
          for( int j=0; j < key; j++ ){							//initializing counter (j) for columns, columns=key
		  
             matrix[i][j]=string[j+i*key];						//populating matrix with the content of char array 
            // cout<<matrix[i][j];								//remove comment to see text in matrix form
		}
		//cout<<endl;											//remove comment to see text in matrix form
      }
      
//---columnar transposition of 2-dimensional array
      for( int i = 0; i < key; i++ ){							//initializing for loop, now counter (i) is for key
          for( int j = 0; j < rows; j++ ){						//initalizing counter (j), now for columns
		  
            cout << matrix[j][i];								//print the transposed text in the matrix
         	
      }
      //cout << endl;											//remove comment to see transposition in matrix form
	  }
}

//--functions
	int numberOfRows(int stringLength, int key){				//function to calculate nuber of rows
		if(stringLength%key>0){									//if condition to check if remainder is higher than 0
			return stringLength/key+1;							//if condition is met, the row number is incremented by 1
		}else 
			return stringLength/key;							//else the row is number of characters over key
	
	}
	int sizeOfMatrix(int rows,int key){							//function to calculate size of matrix
		return rows*key;										//return size of matrix, which is the multiplication of rows and columns	
	}

