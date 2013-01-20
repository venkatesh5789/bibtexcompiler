all: compiler

compiler: lexer.l sqlparser.y sqlite3.h y.tab.h
	flex lexer.l
	yacc sqlparser.y
	gcc lex.yy.c y.tab.c -lsqlite3 -fno-stack-protector -o  compiler
	
query: compiler takequery.c
	gcc takequery.c -lsqlite3 -o query 
		

