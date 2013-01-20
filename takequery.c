#include<stdio.h>
#include "sqlite3.h"
//#include "lex.yy.c"
//#include "y.tab.c"
static int callback(void *NotUsed, int argc, char **argv, char **azColName)
	{
	  int i;
	  for(i=0; i<argc; i++)
	  {
	    printf("%s|",  argv[i] ? argv[i] : "NULL");
	  }
	  printf("\n");
	  return 0;
	}

 void main(int argc, char **argv)
{
	sqlite3 *db; // sqlite3 db struct
	char *zErrMsg = 0;
	int rc,i;
	char userc[1000];
	printf("\n\n\n\n\n\n\n\n\n\n\n\n*************************************************VENKATESH'S BIBTEX COMPILER*************************************\n\n");
	
	// Open the test.db file
	rc = sqlite3_open(argv[1],&db);

	if( rc ){
	// failed
	fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
	}
	else
	{
	// success
	fprintf(stderr, "Open database successfully\n");
	}
	
	//int i;
	do
	{
		printf("\nEnter query here (type exit to quit)-->");
		//fflush(stdin);
		for(i=0;i<1000;i++)
		{
			scanf("%c",&userc[i]);
			//userc[i]=c;
			if(userc[i]=='\n')
			{
				userc[i]='\0';
				break;
			}
		}
		printf("\n%s",userc);
		rc = sqlite3_exec(db, userc, callback, 0, &zErrMsg);
			if( rc!=SQLITE_OK )
			{
				fprintf(stderr, "SQL error: %s\n", zErrMsg);
				sqlite3_free(zErrMsg);
				//break;
			}
	} 
	while(strcmp(userc,"exit")!=0);
	
	sqlite3_close(db);
	printf("\n");
}
