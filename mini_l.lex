/*
	Jesse Garcia cs 152 Project
	Phase 2
*/
%{   
   #include "y.tab.h"
   int currLine = 1;
   int currPos = 1;
%}

DIGIT    [0-9]
LETTERS  [a-zA-Z]
IDENT  {LETTERS}(_?({LETTERS}|{DIGIT}))*
 
%%

	/* Reserved Words */
"function"              {return FUNCTION; currPos += yyleng;}
"beginparams"		{return BEGIN_PARAMS; currPos += yyleng;}
"endparams"		{return END_PARAMS; currPos += yyleng;}
"beginlocals"		{return BEGIN_LOCALS; currPos += yyleng;}
"endlocals"		{return END_LOCALS; currPos += yyleng;}
"beginbody"		{return BEGIN_BODY; currPos += yyleng;}
"endbody"		{return END_BODY; currPos += yyleng;}
"integer"		{return INTEGER; currPos += yyleng;}
"array"			{return ARRAY; currPos += yyleng;}
"of"			{return OF; currPos += yyleng;}
"if"			{return IF; currPos += yyleng;}
"then"			{return THEN; currPos += yyleng;}
"endif"			{return ENDIF; currPos += yyleng;}
"else"			{return ELSE; currPos += yyleng;}
"while"			{return WHILE; currPos += yyleng;}
"do"			{return DO; currPos += yyleng;}
"for"			{return FOR; currPos += yyleng;}
"beginloop"		{return BEGINLOOP; currPos += yyleng;}
"endloop"		{return ENDLOOP; currPos += yyleng;}
"continue"		{return CONTINUE; currPos += yyleng;}
"read"			{return READ; currPos += yyleng;}
"write"			{return WRITE; currPos += yyleng;}
"and"			{return AND; currPos += yyleng;}
"or"			{return OR; currPos += yyleng;}
"not"			{return NOT; currPos += yyleng;}
"true"			{return TRUE; currPos += yyleng;}
"false"			{return FALSE; currPos += yyleng;}
"return"		{return RETURN; currPos += yyleng;}

	/* Arithmetic Operators */
"-"		{return SUB; currPos += yyleng;}
"+"		{return ADD; currPos += yyleng;}
"*"		{return MULT; currPos += yyleng;}
"/"		{return DIV; currPos += yyleng;}
"%"		{return MOD; currPos += yyleng;}

	/* Comparison Operators */
"=="		{return EQ; currPos += yyleng;}
"<>"		{return NEQ; currPos += yyleng;}
"<"		{return LT; currPos += yyleng;}
">"		{return GT; currPos += yyleng;}
"<="		{return LTE; currPos += yyleng;}
">="		{return GTE; currPos += yyleng;}


	/* Other Special Symbols */
";"		{return SEMICOLON; currPos += yyleng;}
":"		{return COLON; currPos += yyleng;}
","		{return COMMA; currPos += yyleng;}
"("		{return L_PAREN; currPos += yyleng;}
")"		{return R_PAREN; currPos += yyleng;}
"["		{return L_SQUARE_BRACKET; currPos += yyleng;}
"]"		{return R_SQUARE_BRACKET; currPos += yyleng;}
":="		{return ASSIGN; currPos += yyleng;}



{IDENT} 	{yylval.ival = yytext; return IDENT; currPos += yyleng;}

{DIGIT}+{IDENT}  {printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter\n", currLine, currPos, yytext); exit(0);}

{IDENT}(_)	 {printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore\n", currLine, currPos, yytext); exit(0);}

{DIGIT}+     {currPos += yyleng; yylval.dval = atoi(yytext); return NUMBER;}

"##".*		/* Comments */

[ \t]+         {/* ignore spaces */ currPos += yyleng;}

"\n"           {currLine++; currPos = 1;}

.              {printf("Error at line %d, column %d: unrecognized symbol \"%s\"\n", currLine, currPos, yytext); exit(0);}

%%

int yyparse();
int main(int argc, char* argv[])
{
  if (argc == 2) 
   {
    yyin = fopen(argv[1], "r");
    if (yyin == 0) 
    {
      printf("Cannot Open File: %s\n", argv[1]);
      exit(1);
    }
  }
  else
    yyin = stdin;

  yyparse();
  return 0;
}
