%{
#include<stdio.h>
#include<string.h>
#include<ctype.h>
#define YYSTYPE char *
#include "sqlite3.h"

	
	int row_no=0;
	int f_type_no=0;
	void find_field(char s[20]);
	void enter_field(char *s);
	
	
	static int callback(void *NotUsed, int argc, char **argv, char **azColName)
	{
	  int i;
	  for(i=0; i<argc; i++)
	  {
	    printf("%s = %s\n", azColName[i], argv[i] ? argv[i] : "NULL");
	  }
	  printf("\n");
	  return 0;
	}
	
	typedef struct 
	{

		 char bibtype[100];
		 char howpublished[100];  
		 char filename[100];
		 char label[100];
		 char author[100];
		 char editor[100];
		 char booktitle[100];
		 char title[100];
		 char crossref[100];
		 char chapter[100];
		 char journal[100];
		 char volume[100];
		 char type[100];
		 char number[100];
		 char institution[100];
		 char organization[100];
		 char publisher[100];
		 char school[100];
		 char address[100];
		 char edition[100];
		 char pages[100];
		 char day[100];
		 char month[100];
		 char year[100];
		 char CODEN[100];
		 char DOI[100];
		 char ISBN[100];
		 char ISBN13[100];
		 char ISSN[100];
		 char LCCN[100];
		 char MRclass[100];
		 char MRnumber[100];
		 char MRreviewer[100];
		 char bibdate[100];
		 char bibsource[100];
		 char bibtimestamp[100];
		 char note[100];
		 char key[100];
		 char series[100];
		 char URL[100];
		 char abstract[100];
		 char keywords[100];
		 char remark[100];
		 char subject[100];
		 char TOC[100];
		 char ZMnumber[100];
		 char entry[100];
	} bibtable;
bibtable contents[1500];
void yyerror(const char *str)
{
        printf("error: %s\n",str);
}

int yywrap()
{
        return 1;
} 


%}

%token TOKEN_ABBREV	1
%token TOKEN_AT		2
%token TOKEN_COMMA	3
%token TOKEN_COMMENT	4
%token TOKEN_ENTRY	5
%token TOKEN_EQUALS	6
%token TOKEN_FIELD	7
%token TOKEN_INCLUDE	8
%token TOKEN_INLINE	9
%token TOKEN_KEY	10
%token TOKEN_LBRACE	11
%token TOKEN_LITERAL	12
%token TOKEN_NEWLINE	13
%token TOKEN_PREAMBLE	14
%token TOKEN_RBRACE	15
%token TOKEN_HASH	16
%token TOKEN_SPACE	17
%token TOKEN_STRING	18
%token TOKEN_VALUE	19
%token TOKEN_NUMBER
%token TOKEN_UNKNOWN	
%nonassoc TOKEN_EQUALS                                   /* These lines resolve the ambiguity */
%left TOKEN_SPACE TOKEN_INLINE TOKEN_NEWLINE
%left TOKEN_HASH

%%
file:		  opt_space
			{printf("\n\nFile parsed successfully");}
		| opt_space object_list opt_space
			{printf("f\n\nFile parsed successfully");}
		;

object_list:	  object
			//{printf("object-1\n");}
		| object_list opt_space object
			//{printf("object-2\n");}
		;

object:	  	  TOKEN_AT opt_space at_object
			//{printf("object\n");}
		;

at_object:	  comment
			///{printf("comment\n");}
		| entry
			//{printf("entry\n");}
		| include
			//{printf("include\n");}
		| preamble
			//{printf("preamble\n");}
		| string
			//{printf("string\n");}
		| error TOKEN_RBRACE
			{printf("\n\n Syntax error detected\n");}
		;

comment:	  TOKEN_COMMENT opt_space TOKEN_LITERAL
			//{printf("comment\n");}
		;

entry:		  entry_head assignment_list TOKEN_RBRACE
			{ row_no++; }//printf("entry-1\n");}
		| entry_head assignment_list TOKEN_COMMA opt_space TOKEN_RBRACE
			{ row_no++; }//printf("entry-2\n");}
		| entry_head TOKEN_RBRACE
			{ row_no++; }//printf("entry-3\n");}
		;

entry_head:	  TOKEN_ENTRY opt_space TOKEN_LBRACE opt_space key_name opt_space TOKEN_COMMA opt_space
			{
				strcpy(contents[row_no].bibtype, $1);
				
				//printf("entry_head\n");
			}
		;

key_name:	TOKEN_KEY
		{
			strcpy(contents[row_no].key, $1);
			//printf("Key 1\n");
		}
		| TOKEN_ABBREV
		{	}//printf("Key 2\n");}
		;
		

include:	  TOKEN_INCLUDE opt_space TOKEN_LITERAL
			//{printf("include\n");}
		;

preamble:	  TOKEN_PREAMBLE opt_space TOKEN_LBRACE opt_space value opt_space TOKEN_RBRACE
			//{printf("preamble\n");}
		;

string:		  TOKEN_STRING opt_space TOKEN_LBRACE opt_space assignment opt_space TOKEN_RBRACE
			//{printf("string\n");}
		;



assignment_list:  assignment
			//{printf("single assignment\n");}
		| assignment_list TOKEN_COMMA opt_space assignment
			//{printf("assignment-list\n");}
		;

assignment:	  assignment_lhs opt_space TOKEN_EQUALS opt_space value opt_space
			{
				
				int l,m;
				
				char c='x';
				int i;
				int j=0;
				
	
				char s[20];
				char temp[100];
				char initial[100];
				strcpy(s,$1);
				find_field(s);
				strcpy(initial,$5);
				for(i=1;(i<99)&&(c!='\0');i++)
				{
					c=initial[i];
					if((initial[i]!='"')||((initial[i]=='"')&&(initial[i+1]!='\0')))
					{	temp[j]=c;
						j++;
					}
					if(c=='\'')
						j--;
				}
				//l=strlen(s);
				
				//printf("\n %s %d %d", $1,l,m);
				//strcpy(final,dq_remove(initial));
				enter_field(temp);
				//printf("\n %s", $5);
				//printf("assignment\n");
			}
		;

assignment_lhs:	  TOKEN_FIELD
			//{printf("assignment_lhs-1");}
		| TOKEN_ABBREV
			//{printf("assignment_lhs-2");}
		;

value:	  	  simple_value
			//{printf("value-1");}
		| value opt_space TOKEN_HASH opt_space simple_value
			/*{
			$$=strcat($1, $3);
			printf("value-2");}*/
		;

simple_value:	  TOKEN_VALUE
			//{printf("simple_value-1");}
		| TOKEN_ABBREV
			//{printf("simple_value-2");}
		;


opt_space:	/* empty */
			//{printf("opt_space-1\n");}
		| space
			//{printf("opt_space-2\n");}
		;

space:		  single_space
			//{printf("single space\n");}
		| space single_space
			//{printf("multiple spaces\n");}
		;

single_space:	  TOKEN_SPACE
		| TOKEN_INLINE
		| TOKEN_NEWLINE
		;
		
%%

main(int argc, char **argv)
{
	yyparse();
    
	sqlite3 *db; // sqlite3 db struct
	char *zErrMsg = 0;
	int rc,n;
	bibtable temp;
	char insert[1000];
	char userc[1000];
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
	
	 char *pSQL[3];
	 //char insert[5000];

  // Create a new aa in database
  pSQL[0] = "create table venkat1 ( bibtype varchar(100), howpublished varchar(100), filename varchar(100), label varchar(100), author varchar(100), editor varchar(100), booktitle varchar(100), title varchar(100), crossref varchar(100), chapter varchar(100), journal varchar(100), volume varchar(100), type varchar(100), number varchar(100), institution varchar(100), organization varchar(100), publisher varchar(100), school varchar(100), address varchar(100), edition varchar(100), pages varchar(100), day varchar(100), month varchar(100), year varchar(100), CODEN varchar(100), DOI varchar(100), ISBN varchar(100), ISBN13 varchar(100), ISSN varchar(100), LCCN varchar(100), MRclass varchar(100), MRnumber varchar(100), MRreviewer varchar(100), bibdate varchar(100), bibsource varchar(100), bibtimestamp varchar(100), note varchar(100), key varchar(100) primary key, series varchar(100), URL varchar(100), abstract varchar(100), keywords varchar(100), remark varchar(100), subject varchar(100), TOC varchar(100), ZMnumber varchar(100), entry varchar(100) );";

   	
  
  	
		rc = sqlite3_exec(db, pSQL[0], callback, 0, &zErrMsg);
		if( rc!=SQLITE_OK )
		{
			fprintf(stderr, "SQL error: %s\n", zErrMsg);
			sqlite3_free(zErrMsg);
		}	
		
		//takequery(userc);
		
		for(n=0;n<row_no;n++)
		{
			temp=contents[n];
			
			//printf("\n\n%d %d",row_no,n);
			
			//printf("\n%s",temp.author);
 sprintf(insert, "insert into venkat1 values ('%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s', '%s')",temp.bibtype, temp.howpublished, temp.filename, temp.label, temp.author, temp.editor, temp.booktitle, temp.title, temp.crossref, temp.chapter, temp.journal, temp.volume, temp.type, temp.number, temp.institution, temp.organization, temp.publisher, temp.school, temp.address, temp.edition, temp.pages, temp.day, temp.month, temp.year, temp.CODEN, temp.DOI, temp.ISBN, temp.ISBN13, temp.ISSN, temp.LCCN, temp.MRclass, temp.MRnumber, temp.MRreviewer, temp.bibdate, temp.bibsource, temp.bibtimestamp, temp.note, temp.key, temp.series, temp.URL, temp.abstract, temp.keywords, temp.remark, temp.subject, temp.TOC, temp.ZMnumber, temp.entry);

					
			rc = sqlite3_exec(db, insert, 0, 0, &zErrMsg);
			if( rc!=SQLITE_OK )
			{
				fprintf(stderr, "SQL error: %s\n", zErrMsg);
				sqlite3_free(zErrMsg);
				break;
			} 
		}
		
		
			rc = sqlite3_exec(db, pSQL[2], callback, 0, &zErrMsg);
			if( rc!=SQLITE_OK )
			{
				fprintf(stderr, "SQL error: %s\n", zErrMsg);
				sqlite3_free(zErrMsg);
				//break;
			}
		
	
	
	
	sqlite3_close(db);
	printf("\n Values entered");
	getchar();
}



void find_field(char s[20])
{
	
	if((s[0]=='h')&&(s[1]=='o')&&(s[2]=='w')&&(s[3]=='p'))
		{f_type_no=1;}
	if((s[0]=='l')&&(s[1]=='a')&&(s[2]=='b')&&(s[3]=='e'))
		{f_type_no=2;}
	if((s[0]=='a')&&(s[1]=='u')&&(s[2]=='t')&&(s[3]=='h'))
		{f_type_no=3;}
	if((s[0]=='e')&&(s[1]=='d')&&(s[2]=='i')&&(s[3]=='t')&&(s[4]=='o'))
		f_type_no=4;
	if((s[0]=='b')&&(s[1]=='o')&&(s[2]=='o')&&(s[3]=='k'))
		f_type_no=5;
	if((s[0]=='t')&&(s[1]=='i')&&(s[2]=='t')&&(s[3]=='l'))
		f_type_no=6;
	if((s[0]=='c')&&(s[1]=='r')&&(s[2]=='o')&&(s[3]=='s'))
		f_type_no=7;
	if((s[0]=='c')&&(s[1]=='h')&&(s[2]=='a')&&(s[3]=='p'))
		f_type_no=8;
	if((s[0]=='j')&&(s[1]=='o')&&(s[2]=='u')&&(s[3]=='r'))
		f_type_no=9;
	if((s[0]=='v')&&(s[1]=='o')&&(s[2]=='l')&&(s[3]=='u'))
		f_type_no=10;
	if((s[0]=='t')&&(s[1]=='y')&&(s[2]=='p')&&(s[3]=='e'))
		f_type_no=11;
	if((s[0]=='n')&&(s[1]=='u')&&(s[2]=='m')&&(s[3]=='b'))
		f_type_no=12;
	if((s[0]=='i')&&(s[1]=='n')&&(s[2]=='s')&&(s[3]=='t'))
		f_type_no=13;
	if((s[0]=='o')&&(s[1]=='r')&&(s[2]=='g')&&(s[3]=='a'))
		f_type_no=14;
	if((s[0]=='p')&&(s[1]=='u')&&(s[2]=='b')&&(s[3]=='l'))
		f_type_no=15;
	if((s[0]=='s')&&(s[1]=='c')&&(s[2]=='h')&&(s[3]=='o'))
		f_type_no=16;
	if((s[0]=='a')&&(s[1]=='d')&&(s[2]=='d')&&(s[3]=='r'))
		f_type_no=17;
	if((s[0]=='e')&&(s[1]=='d')&&(s[2]=='i')&&(s[3]=='t')&&(s[4]=='i'))
		f_type_no=18;
	if((s[0]=='p')&&(s[1]=='a')&&(s[2]=='g')&&(s[3]=='e'))
		f_type_no=19;
	if((s[0]=='d')&&(s[1]=='a')&&(s[2]=='y'))
		f_type_no=20;
	if((s[0]=='m')&&(s[1]=='o')&&(s[2]=='n')&&(s[3]=='t'))
		f_type_no=21;
	if((s[0]=='y')&&(s[1]=='e')&&(s[2]=='a')&&(s[3]=='r'))
		f_type_no=22;
	if((s[0]=='C')&&(s[1]=='O')&&(s[2]=='D')&&(s[3]=='E'))
		f_type_no=23;
	if((s[0]=='I')&&(s[1]=='S')&&(s[2]=='B')&&(s[3]=='N'))
		f_type_no=24;
	if((s[0]=='I')&&(s[1]=='S')&&(s[2]=='B')&&(s[3]=='B')&&(s[4]=='1'))
		f_type_no=25;
	if((s[0]=='I')&&(s[1]=='S')&&(s[2]=='S')&&(s[3]=='N'))
		f_type_no=26;
	if((s[0]=='L')&&(s[1]=='C')&&(s[2]=='C')&&(s[3]=='N'))
		f_type_no=27;
	if((s[0]=='M')&&(s[1]=='R')&&(s[2]=='c')&&(s[3]=='l'))
		f_type_no=28;
	if((s[0]=='M')&&(s[1]=='R')&&(s[2]=='n')&&(s[3]=='u'))
		f_type_no=29;
	if((s[0]=='M')&&(s[1]=='R')&&(s[2]=='r')&&(s[3]=='e'))
		f_type_no=30;
	if((s[0]=='b')&&(s[1]=='i')&&(s[2]=='b')&&(s[3]=='d'))
		f_type_no=31;
	if((s[0]=='b')&&(s[1]=='i')&&(s[2]=='b')&&(s[3]=='s'))
		f_type_no=32;
	if((s[0]=='b')&&(s[1]=='i')&&(s[2]=='b')&&(s[3]=='t'))
		f_type_no=33;
	if((s[0]=='n')&&(s[1]=='o')&&(s[2]=='t')&&(s[3]=='e'))
		f_type_no=34;
	if((s[0]=='k')&&(s[1]=='e')&&(s[2]=='y')&&(s[3]=='w'))
		f_type_no=39;
	if((s[0]=='k')&&(s[1]=='e')&&(s[2]=='y'))
		f_type_no=35;
	if((s[0]=='s')&&(s[1]=='e')&&(s[2]=='r')&&(s[3]=='i'))
		f_type_no=36;
	if((s[0]=='U')&&(s[1]=='R')&&(s[2]=='L'))
		f_type_no=37;
	if((s[0]=='a')&&(s[1]=='b')&&(s[2]=='s')&&(s[3]=='t'))
		f_type_no=38;
	if((s[0]=='r')&&(s[1]=='e')&&(s[2]=='m')&&(s[3]=='a'))
		f_type_no=40;
	if((s[0]=='s')&&(s[1]=='u')&&(s[2]=='b')&&(s[3]=='j'))
		f_type_no=41;
	if((s[0]=='T')&&(s[1]=='O')&&(s[2]=='C'))
		f_type_no=42;
	if((s[0]=='Z')&&(s[1]=='M')&&(s[2]=='n')&&(s[3]=='u'))
		f_type_no=43;
	if((s[0]=='e')&&(s[1]=='n')&&(s[2]=='t')&&(s[3]=='r'))
		f_type_no=44;
}

void enter_field(char *s)
{
	if(f_type_no==1)
		strcpy(contents[row_no].howpublished, s);
	if(f_type_no==2)
		strcpy(contents[row_no].label, s);
	if(f_type_no==3)
		strcpy(contents[row_no].author, s);
	if(f_type_no==4)
		strcpy(contents[row_no].editor, s);
	if(f_type_no==5)
		strcpy(contents[row_no].booktitle, s);
	if(f_type_no==6)
		strcpy(contents[row_no].title, s);
	if(f_type_no==7)
		strcpy(contents[row_no].crossref, s);
	if(f_type_no==8)
		strcpy(contents[row_no].chapter, s);
	if(f_type_no==9)
		strcpy(contents[row_no].journal, s);
	if(f_type_no==10)
		strcpy(contents[row_no].volume, s);
	if(f_type_no==11)
		strcpy(contents[row_no].type, s);
	if(f_type_no==12)
		strcpy(contents[row_no].number, s);
	if(f_type_no==13)
		strcpy(contents[row_no].institution, s);
	if(f_type_no==14)
		strcpy(contents[row_no].organization, s);
	if(f_type_no==15)
		strcpy(contents[row_no].publisher, s);
	if(f_type_no==16)
		strcpy(contents[row_no].school, s);
	if(f_type_no==17)
		strcpy(contents[row_no].address, s);
	if(f_type_no==18)
		strcpy(contents[row_no].edition, s);
	if(f_type_no==19)
		strcpy(contents[row_no].pages, s);
	if(f_type_no==20)
		strcpy(contents[row_no].day, s);
	if(f_type_no==21)
		strcpy(contents[row_no].month, s);
	if(f_type_no==22)
		strcpy(contents[row_no].year, s);
	if(f_type_no==23)
		strcpy(contents[row_no].CODEN, s);
	if(f_type_no==24)
		strcpy(contents[row_no].ISBN, s);
	if(f_type_no==25)
		strcpy(contents[row_no].ISBN13, s);
	if(f_type_no==26)
		strcpy(contents[row_no].ISSN, s);
	if(f_type_no==27)
		strcpy(contents[row_no].LCCN, s);
	if(f_type_no==28)
		strcpy(contents[row_no].MRclass, s);
	if(f_type_no==30)
		strcpy(contents[row_no].MRreviewer, s);
	if(f_type_no==31)
		strcpy(contents[row_no].bibdate, s);
	if(f_type_no==32)
		strcpy(contents[row_no].bibsource, s);
	if(f_type_no==33)
		strcpy(contents[row_no].bibtimestamp, s);
	if(f_type_no==34)
		strcpy(contents[row_no].note, s);
	if(f_type_no==35)
		strcpy(contents[row_no].key, s);
	if(f_type_no==36)
		strcpy(contents[row_no].series, s);
	if(f_type_no==37)
		strcpy(contents[row_no].URL, s);
	if(f_type_no==38)
		strcpy(contents[row_no].abstract, s);
	if(f_type_no==39)
		strcpy(contents[row_no].keywords, s);
	if(f_type_no==40)
		strcpy(contents[row_no].remark, s);
	if(f_type_no==41)
		strcpy(contents[row_no].subject, s);
	if(f_type_no==42)
		strcpy(contents[row_no].TOC, s);
	if(f_type_no==43)
		strcpy(contents[row_no].ZMnumber, s);
	if(f_type_no==44)
		strcpy(contents[row_no].entry, s);
	if(f_type_no==29)
		strcpy(contents[row_no].MRnumber, s);
	
}


	
	
