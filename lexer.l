%{
    	
    	#include "y.tab.h"
    	#include<stdio.h>
    	#include<string.h>
 
    	static int brace_level = 0;
    	static int paren_level = 0;
    	static int number=0;
    	static int quotes=0;
    	 int braced_string(void);
    	 int braced_literal(void);
    	  int last_object = TOKEN_UNKNOWN;
	  int last_token = TOKEN_UNKNOWN;
    
	
    		
 
%}

				
N		[A-Za-z][-A-Za-z0-:.+/' ]*
					/* BibTeX entry opening delimiter */
O		[({]
					/* one white space character */
					/* \013 == \v, but lex doesn't */
					/* recognize \v */
W		[ \f\r\t\013]
					/* optional `horizontal' space */
S		{W}*

P		{N}{S}

X		[ ]

%%



[@]				{
					last_object= TOKEN_UNKNOWN;
					
					last_token= TOKEN_AT;
					return(TOKEN_AT); 
				}

[Cc][Oo][Mm][Mm][Ee][Nn][Tt]	{  	if(last_token==TOKEN_AT)
						return(TOKEN_COMMENT);
					else
				           return(TOKEN_ABBREV);
				}
				
[Ii][Nn][Cc][Ll][Uu][Dd][Ee]	{  
					printf("\n @INCLUDE ENCOUNTERED........it will be ignored");	
					if(last_token==TOKEN_AT)
				    {
				    	last_object=TOKEN_INCLUDE;
				         return(TOKEN_INCLUDE);
				         
				     }
				     else
				           return(TOKEN_ABBREV);
				}


[Pp][Rr][Ee][Aa][Mm][Bb][Ll][Ee] {  
					printf("\n @PREAMBLE ENCOUNTERED........it will be ignored");	
					if(last_token==TOKEN_AT)
				     {
				     	  last_token=TOKEN_PREAMBLE;
				          return(TOKEN_PREAMBLE);
				          
				      }
				   else
				           return(TOKEN_ABBREV);
				}


[Ss][Tt][Rr][Ii][Nn][Gg]	{  
					printf("\n @STRING ENCOUNTERED........it will be ignored");	
					if(last_token==TOKEN_AT)
				    {
				    	last_object=TOKEN_STRING;
				         return(TOKEN_STRING);
				         
				    }
				   else
				           return(TOKEN_ABBREV);
				}


[#]{S}				{
					last_token=TOKEN_HASH;	
					return(TOKEN_HASH);}

{N}				{
					char c; 
				    if((brace_level!=0)||(last_token==TOKEN_AT)||(last_token==TOKEN_HASH))
				    {    
					    if (last_object == TOKEN_STRING)
						return(TOKEN_ABBREV);
					    switch (last_token)
					    {
					    case TOKEN_COMMA:
					    	yylval=strdup(yytext);
					    	last_token=TOKEN_FIELD;
						return(TOKEN_FIELD);
					    case TOKEN_LBRACE:
					    	last_token=TOKEN_KEY;
					    	yylval=strdup(yytext);
						return(TOKEN_KEY);
					    case TOKEN_AT:
					    	last_token=TOKEN_ENTRY;
					    	yylval=strdup(yytext);
						return(TOKEN_ENTRY);
					     case TOKEN_EQUALS:
					     	{
						    int blevel;
						    int c;
						    int n;
						
						    for ( blevel=1,n = 1; c!=','; )
						    {
							c = input();
							if (c == EOF)
							    break;
							//yytext[n++] = c;
							switch (c)
							{
								case '{':
								    blevel++;
								    break;
								case '}':
								    blevel--;
								    break;
														
								  default:
								    break;
							}
						    }
					    	n = strlen((const char*)&yytext[0]);
						
						yytext[n+2] = '\0';
						yytext[n+1] = '"';
						for (; n > 0; --n)
							yytext[n] = yytext[n-1];
						yytext[0]='"';
					     last_token=TOKEN_VALUE;
					 
					 yylval=strdup(yytext);
					 
				    	 return(TOKEN_VALUE);
				    	 
					    
					    
				}
				default:
					braced_literal();
					     
					     	
					    
					    }
				     }
				else return(TOKEN_ABBREV);}

[0-9]+				{
					int n,c;
					n=1;
					if(last_token==TOKEN_EQUALS)
					{
						
						if (isdigit(yytext[0]))
		    				{				
							/*n = strlen((const char*)&yytext[0]);
							
							yytext[n+2] = '\0';
							yytext[n+1] = '"';
							for (; n > 0; --n)
							    yytext[n] = yytext[n-1];
							yytext[0]='"';*/
							
							while((c=input())!=',')
							yytext[n++]=c;
						 }
						 ;
						 last_token=TOKEN_VALUE;
						 
						 yylval=strdup(yytext);
						 
					    	 return(TOKEN_VALUE);
					 }
				 }

[%].*[\n]{S}			return(TOKEN_INLINE);


["]				{
				    int blevel;
				    int c;
				    int n;
				   
					if(last_token==TOKEN_EQUALS);
					{
					brace_level++;
				    for (blevel = 0, n = 1; ; )
				    {
					c = input();
					if (c == EOF)
					    break;
					yytext[n++] = c;
					switch (c)
					{
						case '{':
						    blevel++;
						    break;
						case '}':
						    blevel--;
						    break;
						case '"':
						
						    if (blevel == 0)
						    {
						    	yytext[n++] = '\0';
					    		int n;
							last_token=TOKEN_VALUE;
							if (isdigit(yytext[0]))
			    				{				
								n = strlen((const char*)&yytext[0]);
								yytext[n+2] = '\0';
								yytext[n+1] = '"';
								for (; n > 0; --n)
								    yytext[n] = yytext[n-1];
							 }
							 
							 yylval=strdup(yytext);
							 brace_level--;
						    	 return(TOKEN_VALUE);;
					    	    }
						default:
						    break;
					}
				    }
				}}

[{]				{
					    if ((brace_level == 0))
					    {
						brace_level++;
						switch (last_object)
						{
							case TOKEN_COMMENT:
							case TOKEN_INCLUDE:
							    braced_literal();
							    
    								return(TOKEN_LITERAL);
							default:
							{
							    last_token=TOKEN_LBRACE;
							    
							    return(TOKEN_LBRACE);
							}
						}
					    }
					    else
						braced_string();
						 
					    last_token=TOKEN_VALUE;
					    yylval=strdup(yytext);  return(TOKEN_VALUE);
				}

[}]				{
					   if (brace_level == 1)
					    {
						brace_level--;
						last_token=TOKEN_RBRACE;
						
						return(TOKEN_RBRACE);
					    }
					    else
					    {
					    	brace_level--;
					    	last_token=TOKEN_VALUE;
					    	
					    	return(TOKEN_VALUE);
					    }
				}

[(]				{
					    switch (last_token)
					    {
						    case TOKEN_ENTRY:
						    case TOKEN_PREAMBLE:
						    case TOKEN_STRING:
							yytext[0] = '{';
							paren_level++;
							brace_level++;
							last_token=TOKEN_LBRACE;
							
							return(TOKEN_LBRACE);

						    case TOKEN_COMMENT:
						    case TOKEN_INCLUDE:
							yytext[0] = '{';
							paren_level++;
							brace_level++;
							braced_literal();
							
    return(TOKEN_LITERAL);

						    default:
						    	last_token=TOKEN_LITERAL;
						    	
							return(TOKEN_LITERAL);
					    }
				}

[)]				{
				    paren_level--;
				    if (paren_level  == 0)
				    {
					yytext[0] = '}';
					brace_level--;
					last_token=TOKEN_RBRACE;
					
					return(TOKEN_RBRACE);
				    }
				    else
				    {
				    	last_token= TOKEN_LITERAL;
				    	
				    					    	return (TOKEN_LITERAL);
				    }
				}

[=]{S}				{
					last_token = TOKEN_EQUALS;
					return(TOKEN_EQUALS);
				}


[,]{X}*				{
					last_token = TOKEN_COMMA;
					
					return(TOKEN_COMMA);
				}

[\n]				{	
					if((last_token==TOKEN_VALUE)||(number==1))
					{
						number=0;
						last_token=TOKEN_COMMA;
						return(TOKEN_COMMA);
					}
					return(TOKEN_NEWLINE); }

{W}+				{ return(TOKEN_SPACE);}



%%


int braced_literal(void)
{
    int c;
    int n;
    int plevel = paren_level;

    for (n = 1; brace_level > 0; )
    {
	c = input();
	if (c == EOF)
	    break;
	yytext[n++] = c;
	switch (c)
	{
		case '(':
		    plevel++;
		    break;
		case ')':
		    plevel--;
		    break;
		case '{':
		    brace_level++;
		    break;
		case '}':
		    brace_level--;
		    break;
		default:
		    break;
	}
	if ((paren_level > 0) && (plevel == 0))
	    break;
    }
    yytext[0] = '{';
    yytext[n-1] = '}';
    yytext[n] = '\0';
    
}


int braced_string(void)
{					
    int blevel;
    char c;
    int n;

    for (blevel = 1, n = 1; (blevel > 0); )
    {
	c = input();
	yytext[n++] = c;
	switch (c)
	{
		case '{':
		    
		    blevel++;
		    break;

		case '}':
		    
		    blevel--;
		    break;

		case '"':
		
		    if (blevel == 1)
		    {
			if (yytext[n-2] == '\\')
			{
			    c = input();
			    yytext[n-2] = '{';
			    yytext[n-1] = '\\';
			    yytext[n++] = '"';
			    yytext[n++] = c;
			    yytext[n++] = '}';
			}
			else
		    
		    if(isalpha(yytext[n]=input()))
			break;}
		    break;

		default:
		    break;
	}
    }
    yytext[0] = '"';
    yytext[n-1] = '"';
    yytext[n] = '\0';
   
}


