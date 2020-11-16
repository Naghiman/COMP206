#include <stdio.h>


/*
 Program to implement a scientific calculator
 ***************************************************************
 * Author	Dept.		Date		Notes
 ***************************************************************
 * Narry Z	ECSE		Oct 28 2020	Initial version.
 * Narry Z	ECSE		Oct 29 2020	Added Error cases.
 * Narry Z	ECSE		Nov 01 2020	Finished Error cases.
 * Narry Z	ECSE		Nov 02 2020	Finished calc.
 * Narry Z	ECSE		Nov 02 2020	All test cases passed.
*/


int main (int argc, char *argv[])
{
	//operands
	int n1[1000];
	int n2[1000];
	//number of digits
	int nd1 = 0;
	int nd2 = 0;
	//temp variables
	int i,j,l;
	int m = 0;
	//carry
	int cr = 0;
	//temps
	int temp1, temp2;
	//result
	int rs[1001];

	//Cheking number of arguments
	if( argc != 4)
	{
		printf("Error: invalid number of arguments!\n");
		printf("scalc <operand1> <operator> <operand2>\n");
		return 1;
	}

	//Checking if the operator is +
	if( *argv[2] != 43)
	{
		printf("Error: operator can only be + !\n");
		return 1;
	}
	//Check if the first operand is positive integer
	//put first operand in n1 variable as int value
	for(i=0; *(argv[1]+i) != 0; i++)
	{
		if( *(argv[1]+i) == 45 || *(argv[1]+i) == 46 )
		{
			printf("Error!! operand can only be positive integers\n");
			return 1;
		}
		n1[i] = *(argv[1]+i)-48;
		nd1++;
	}
	n1[i] = '\0';

	//Check if the second operand is positive integer
	//put second operand in n2 variable as int value
	for(j=0; *(argv[3]+j) != 0; j++)
	{
		if( *(argv[3]+j) == 45 || *(argv[3]+j) == 46 )
		{
			printf("Error!! operand can only be positive integers\n");
			return 1;
		}
		n2[j] = *(argv[3]+j)-48;
		nd2++;
	}
	n2[j] = '\0';
	
	//Add the digits up to the point they both have digits
	for( int k=nd1-1, l = nd2-1; k != -1 && l != -1; k-- , l--)
	{
		rs[m] = (n1[k]+n2[l]+cr)%10;
		cr = (n1[k]+n2[l]+cr)/10;
		m++;
	}
	//Add digit from the bigger number
	temp1 = (nd1 > nd2) ? nd1 : nd2;
	temp2 = (nd1 > nd2) ? nd2 : nd1;
	for(int k = temp1 - temp2 -1; k != -1; k--)
	{
		if( nd1 > nd2)
		{
			rs[m] = (n1[k]+cr)%10;
			cr = (n1[k]+cr)/10;
			m++;
		}
		if( nd1 < nd2)
		{
			rs[m] = (n2[k]+cr)%10;
			cr = (n2[k]+cr)/10;
			m++;
		}
	}

	//add carry at the end if there was a carry left.
	if(cr == 1){
		rs[m] = 1;
		m++;
		rs[m]= '\0';
	}
	else
	{
		rs[m] = '\0';
	}

	//print the result
	for(int k=m-1; k != -1; k--)
		printf("%d",rs[k]);

	printf("\n");
	return 0;
	
}
