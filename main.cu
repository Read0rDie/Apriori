#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>

long int factorial(int x);
long int nCr(int n, int r);

struct timeval start, end;

void starttime(){
	gettimeofday(&start, 0);
}

void endtime(const char * c){
	gettimeofday(&end, 0);
	double elapsed = (end.tv_sec - start.tv_sec) * 1000.0 + (end.tv_usec - start.tv_usec)/ 1000.0;
	printf("%s: %f ms\n", c, elapsed);
}

int main() {
	
	//Variable declarations
	FILE *fPointer;
//	char singleLine[100];
	int max = 0; //Contains the largest integer occurence in the given database
	int size = 0; //Contains the number of lines in the given database
	int cardinality = 1; //Contains the initial cardinality of the item sets
    	int temp;
	int i = 0;
	int j, k, num, count;
	int mSupport = 8000; //Contains the support count; set to approx 10% of all transactions
	char val;
//	int THREADS_PER_BLOCK = 1024;

	//While loop that traverses through the database and returns the number of transactions  
	fPointer = fopen("retail.dat", "r"); 
   	fscanf(fPointer, "%c", &val);
   	while(!feof(fPointer)){
        	if(val == '\n'){
            		size++;
        	}
       		fscanf(fPointer, "%c", &val);
    	}
    	fclose(fPointer);
  //  	printf("\nNumber of Transcations: %d\n", size);

    	fPointer = fopen("retail.dat", "r");
   	fscanf(fPointer, "%d", &temp);
 //	printf("ID number of first item: %d\n", temp);
	
	//Traverses through each transaction in order to find the max value.
    	while(!feof(fPointer)){
        	fscanf(fPointer, "%d", &temp);
        	if(max < temp){
            		max = temp;
        	}
    	}	
   	fclose(fPointer);


printf("DATA FILE PARSED\n");
printf("=========================================\n");
printf("Total number of transactions found: %d\n", size);
printf("Total number of unique items: %d\n", max + 1);
printf("=========================================\n");
printf("APRIORI IMPLEMENTATION BEGINS\n");
  // 	printf("Largest ID number found: %d\n", max);

	//Counting the number of necessary blocks.
	//int numblocks = size/THREADS_PER_BLOCK;
	//if (size % THREADS_PER_BLOCK != 0) {
	//	numblocks++; 
	//}
    	
//	printf("\nSH: initializing transaction array\n");
starttime();
	//Creation of table
	char *cTable = (char*)malloc(sizeof(char) * (max + 1) * size); //Allocates an array of characters for each transaction	
	
	for(i=0; i < (max+1)*size; i++) {
	//	memset(cTable[i], '\0', sizeof(char) * (max + 1) * size); //Initialize all values to 0.
		cTable[i] = '\0';
	}



//	printf("SH: initialization of transaction array COMPLETE\n");
	
//	printf("\nSH: populating transaction array\n");
		
    	char line[400];
    	char *cNum;
    	fPointer = fopen("retail.dat", "r");
	for(i = 0; i < size; i++){
		fgets(line, 400, fPointer);

        	cNum = strtok(line, " \n");
        	
		while(cNum != NULL){
            		num = atoi(cNum);
            		cTable[i * (max + 1) + num] = '1';
            		cNum = strtok(NULL, " \n");
        	}	
    	}

//	printf("SH: populating transaction array COMPLETE\n");

//	printf("\nSH: initializing cardinality '1' sets\n");
	
	//Creates a frequency table of iem sets with a Cardinality of 1; where the array index represents the item 
	//number. All the items have their counts initially set to zero
	int fTable[max + 1];
	for(i = 0; i < max + 1; i++){
		fTable[i] = 0;
	}

//	printf("SH: initialization of cardinality '1' sets COMPLETE\n");

//	printf("\nSH: counting of cardinality '1' sets\n");

	//Iterate though the frequency table and count the occurences of each item in the transcations from the cTable
	for(i = 0; i < size; i++){
		for(j = 0; j < max + 1; j++){
			if(cTable[i * (max + 1) + j] == '1'){
				fTable[j]++;
			}
		}
	}

//	printf("SH: counting of cardinality '1' sets COMPLETE\n");

	//Alter the value of 'i' to check the counts of any particular item in the transcation data set
	i = 32;
	char sInt[6];
	snprintf(sInt, 6, "%d", i);

	//printf("\nThere are %d instances of item'%s'\n", fTable[i], sInt);

//	printf("\nSH: removing item sets whose counts are below the support threshold\n");

	//invalidating elements that are below the support count and counting the remaining eligible elements
	count = 0;
	for(i = 0; i < (max + 1); i++){
		if (fTable[i] < mSupport){
			fTable[i] = 0;
		}
		else{
			count++;
		}
	}

//	printf("SH: removal of item sets COMPLETE\n");
//	printf("\nRemaining items sets: %d\n", count);

	//creating new table consisting of only valid items
        int iTable[count];
        j = 0;
        for(i = 0; i < (max + 1); i++){
                if (fTable[i] != 0){
                        iTable[j] = i;			
                        j++;
                }
        }

	//creating a tabel to hold the current valid items item and their the a variable for the count of the count
	int * vTable = iTable;
	int lastCount = count;

	while(count > 1){
		cardinality++;
//		printf("\nSH: initializating new cardinality '%d' sets\n", cardinality);	
	
		//temporary array that will hold the new item sets		
		int temp[nCr(count, cardinality) * (cardinality + 1)];
		
//		printf("SH: initialization of new cardinality '%d' sets COMPLETE\n", cardinality);

//		printf("\nSH: initializating old cardinality '%d' sets\n", cardinality - 1);		

		//array of previous items sets
		int oldSets[nCr(lastCount, cardinality - 1) * cardinality];

		//array that hold one old item set for insertion into table
		int oldEntry[cardinality - 1];

//		printf("SH: initialization of old cardinality '%d' sets COMPLETE\n", cardinality - 1);
		
//		 printf("\nSH: populating old  cardinality '%d' sets\n", cardinality - 1); 

                //function populates old  item set
                k = 0;
                if(cardinality - 1 <= lastCount){
                        for(i = 0; (oldEntry[i] = i) < cardinality - 2; i++); 
                        for(i = 0; i < cardinality - 1; i++){
                                oldSets[(k * cardinality) + i] = vTable[oldEntry[i]];
                        }
                        k++;
                        for(;;){
                                for( i = cardinality - 2; i >= 0 && oldEntry[i] == (lastCount - (cardinality - 1) + i); i--);
                                if(i < 0){
                                        break;
                                }
                                else{
                                        oldEntry[i]++;
                                        for(++i; i < cardinality - 1; i++){
                                                oldEntry[i] = oldEntry[i - 1] + 1;
                                        }
                                        for(j = 0; j < cardinality - 1; j++){
                                                oldSets[(k * cardinality) + j] = vTable[oldEntry[j]];
                                        }
                                        k++;
                                }
                        }
                }

                for(i = 0; i < nCr(lastCount, cardinality - 1); i++){
                        oldSets[(i * cardinality) + cardinality - 1] = 0;
                }

//		printf("SH: populating of old cardinality '%d' sets COMPLETE\n", cardinality - 1);

		//array that will hold the information for a single item set before it is added to the 
		//array of all item sets
		int entry[cardinality];

//		printf("\nSH: populating cardinality '%d' sets\n", cardinality);

		//function populates new item set
		k = 0;
		if(cardinality <= count){
			for(i = 0; (entry[i] = i) < cardinality - 1; i++);			
			for(i = 0; i < cardinality; i++){
				temp[(k*(cardinality + 1)) + i] = vTable[entry[i]];
			}
			k++;
			for(;;){
				for( i = cardinality - 1; i >= 0 && entry[i] == (count - cardinality + i); i--);
				if(i < 0){
					break;
				}
				else{
					entry[i]++;
					for(++i; i < cardinality; i++){
						entry[i] = entry[i - 1] + 1;
					}
					for(j = 0; j < cardinality; j++){
						temp[(k*(cardinality + 1)) + j] = vTable[entry[j]];
					}
					k++;
				}
			}
		}


						      
		for(i = 0; i < nCr(count, cardinality); i++){
			temp[(i*(cardinality + 1)) + cardinality ] = 0;
		}

//		printf("SH: populating of cardinality '%d' sets COMPLETE\n", cardinality);

//		printf("\nSH: counting  cardinality '%d' sets\n", cardinality);
		
		//counting the amount of instances of the item sets amongst the transactions
		
		int found = 0; 
		int b = 0; 
		for(i = 0; i < size; i++){
			for(j = 0; j < nCr(count, cardinality); j++){
				found = 1;
				for(k = 0; k < cardinality; k++){
					b = temp[(j*(cardinality+1))+k];
					if(cTable[(i*(max+1))+b] != '1'){
						found = 0;
					}
				}
				if(found == 1){
					temp[(j*(cardinality + 1))+cardinality]++;
				}
			}
		}

//		printf("SH: counting of cardinality '%d' sets COMPLETE\n\n", cardinality);

//		printf("\nSH: counting old cardinality '%d' sets\n", cardinality - 1);

                //counting the amount of instances of the item sets amongst the transactions

                for(i = 0; i < size; i++){
                        for(j = 0; j < nCr(lastCount, cardinality - 1); j++){
                                int found = 1;
                                for(k = 0; k < cardinality -1; k++){
					int b = oldSets[(j*cardinality)+k];
                                        if(cTable[(i*(max + 1))+b] != '1'){
                                                found = 0;
                                        }
                                }
                                if(found == 1){
                                        oldSets[(j*cardinality) + cardinality - 1]++;
              			}                  
                        }
                }

//		printf("SH: counting of old cardinality '%d' sets COMPLETE\n\n", cardinality - 1);
/*
		for(i = 0; i <= cardinality; i++){
			if(i == cardinality){
				printf("Count\n");
			}
			else{
				printf("Item '%d'\t", (i+1));
			}
		}
		for(i = 0; i < nCr(count, cardinality); i ++){
                        for(j = 0; j <= cardinality; j++){
                                printf("%d\t\t", temp[(i*(cardinality + 1))+j]);
                        }
                         printf("\n");
                }
*/
//		printf("\nSH: removing item sets whose counts are below the support threshold\n");
		//invalidating elements that are below the support count and counting the remaining eligible elements
        	int tCount = count;
		lastCount = tCount;
		count = 0;
        	for(i = 0; i < nCr(tCount, cardinality); i++){
                	if (temp[(i*(cardinality + 1)) + cardinality] < mSupport){
                        	temp[(i * (cardinality + 1)) + cardinality] = 0;
                	}	
                	else{
                        	count++;
                	}
        	}		

  //      	printf("SH: removal of item sets COMPLETE\n");
    //    	printf("\nRemaining items sets: %d\n", count);

		//set Table of valid items
		char valid[max + 1];
		for(i = 0; i <= max; i++){
			valid[i] = '\0';
		}
		for(i = 0; i < nCr(tCount, cardinality); i++){
			for(j = 0; j < cardinality; j++){
				if(temp[(i * (cardinality + 1)) + cardinality] > 0){
					valid[temp[(i * (cardinality + 1)) + j]] = '1';
				}
			}
		}

        	//creating new table consisting of only valid items
        	int rTable[count];
		count = 0;
        	j = 0;
        	for(i = 0; i <= max; i++){
                	if (valid[i] == '1'){
                        	rTable[j] = i;
                        	j++;
				count++;
	                }
        	}	
		vTable = rTable;

		if(count == 0){
			printf("\n----Most Frequent Item Sets----\n\n");
	   
	        	for(i = 0; i < nCr(lastCount, cardinality - 1); i++){
				if(oldSets[(i * cardinality) + (cardinality-1)] > mSupport){
                                        printf("Set: {");
                                }
               			for(j = 0; j < cardinality; j++){
					if(oldSets[(i * cardinality) + (cardinality-1)] > mSupport){
                               			if(j == cardinality - 1){
							printf("}\t\tCount: %d\n", oldSets[(i * cardinality) + j]);
						}
						else{
							printf("'%d'", oldSets[(i * cardinality) + j]);
						}
                       		 	}	
               		 	}        
			}
			printf("\n");	
		}
	}

	endtime("Total parallelized Implementation Time");
}

//factorial function
long int factorial(int x){
	int count = x;
	while (count > 1){
		x = x * (count - 1);
		count--;
	}
	if(x == 0){
		x = 1;
	}	
	return x;	
}

//combinatorics function
long int nCr(int n, int r){
	int y;
	int z;
	int w = n - 1;
	int init = n;
	int x;
	if(r > (n-r)){
	y = r;	
	}
	else{
		y = (n-r);
	}

	z = n - y;
	while(z > 1){
		n = n * w;
		w--;
		z--;
	}
	if( r > (init - r)){
		x = n/factorial(init - r);
	}
	else{
		x = n/factorial(r);
	}
	
	return  x;

}
