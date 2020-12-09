/*
 * Program to implement a scientific calculator
 * ***************************************************************
 *   * Author       Dept.           Date            Notes
 * ***************************************************************
 *   * Narry Z      ECSE            Dec 04 2020     Initial version.
 *   * Narry Z      ECSE            Dec 04 2020     Added Error cases.
 *   * Narry Z      ECSE            Nov 01 2020     Finished Error cases.
 *   * Narry Z      ECSE            Nov 02 2020     Finished calc.
 *   * Narry Z      ECSE            Nov 02 2020     All test cases passed.
 */

#include <stdio.h>
#include <string.h>
#include <stdbool.h>


struct logrecord
{
	char name[100];
	char IPAddress[50];
};

struct logrecord readLog(char *logline)
{
	struct logrecord lr;
	char *name = NULL;
	char *ip = NULL;
	name = strtok(logline, ",");
	strcpy(lr.name, name);
	for(int i=0; i<6; i++)
		ip = strtok(NULL,",");
	strcpy(lr.IPAddress, ip);
	return lr;

}

bool checkNameExists(FILE *csv, char *name, char *ip)
{
	char line[200];
	struct logrecord lr;

	while(!feof(csv))
	{
		fgets(line, 200, csv);
		if(feof(csv)) break; 
		
		lr = readLog(line);
		if(strcmp(lr.name, name) == 0)
		{
			strcpy(ip, lr.IPAddress);
			return true;
		}
	}
	return false;
}

bool findCollaborators(char *sname, char *sip, FILE *csv, FILE *rpt)
{
	char logline[200];
	struct logrecord lr;
	bool found = false;
	char prevname[100] = {'\0'};

	while(!feof(csv))
	{
		fgets(logline, 200, csv);
		if(feof(csv)) break;

		lr = readLog(logline);
		if(strcmp(lr.IPAddress, sip) == 0 && strcmp(lr.name, sname) != 0 && strcmp(lr.name, prevname) != 0)
		{
			found = true;
			strcpy(prevname, lr.name);
			fprintf(rpt, "%s\n", lr.name);
		}
	}
	return found;
}

int main (int argc, char *argv[])
{
	char logline[200];
	char sname[100];
	char sIPAddress[50];
	FILE *csv;
	FILE *rpt;
	bool found;
	//Cheking number of arguments
	if( argc != 4)
	{
		printf("Usage ./report <csvfile> \"<student name>\" <reportfile>\n");
		return 1;
	}
	csv = fopen(argv[1], "rt");
	if(csv == NULL)
	{
		printf("Error, unable to open csv file %s\n", argv[1]);
		return 1;
	}
	fgets(logline, 200, csv);
	if(checkNameExists(csv, argv[2], sIPAddress) == false)
	{
		printf("Error, unable to locate %s\n", argv[2]);
		return 1;
	}
	rpt = fopen(argv[3], "wt");
	if(rpt == NULL)
	{
		printf("Error, unable to open the output file %s\n",argv[3]);
		return 1;
	}

	fseek(csv, 0, SEEK_SET);
	fgets(logline, 200, csv);

	found = findCollaborators(argv[2], sIPAddress, csv, rpt);
	if(!found)
		fprintf(rpt, "No collaborators found for %s\n", argv[2]);

	fclose(csv);
	fclose(rpt);

	return 0;
}
