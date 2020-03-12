%{
 #include <stdio.h>
 #include <stdlib.h>

 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;

 std::vector<std::string> statement_vec;
 std::vector<std::string> operation_vec;
 std::vector<std::string> expression_vec;
 std::vector<std::string> declaration_vec;
 std::vector<std::string> function_vec;
%}

%union{
  char* ival;
  double dval;

    struct Statement_val
    {
	std::string code;
    }stat;

    struct Expression_val
    {
	std::string code;
	std::string result_id;
    }expr;

}
%error-verbose
%start prog_start


%type <stat> ElseStatement Statement Statement1 Statement2 Statement3 Statement4 Statement5 Statement6 Statement7 Statement8 Statement9 Statement_loop
%type <expr> Declaration Declartation_loop Function Ident_loop Bool_Expr Relation_And_Expr
%type <expr> Relation_Expr Relation_Expr_loop Comp Expression Expression_loop
%type <expr> Multiplicative_Expr Term Var Var_loop Ident

%token <ival> IDENT
%token <dval> NUMBER

%token FUNCTION BEGIN_PARAMS END_PARAMS BEGIN_LOCALS END_LOCALS BEGIN_BODY END_BODY
%token INTEGER ARRAY OF IF THEN ENDIF ELSE WHILE DO FOR BEGINLOOP ENDLOOP CONTINUE
%token READ WRITE TRUE FALSE RETURN SEMICOLON COLON COMMA L_PAREN R_PAREN
%token L_SQUARE_BRACKET R_SQUARE_BRACKET
%token AND OR SUB ADD MULT DIV MOD
%token EQ NEQ LT GT LTE GTE ASSIGN NOT

%right UMINUS

%left MULT
%left DIV
%left MOD
%left ADD 
%left SUB
%left LT
%left LTE 
%left GT 
%left GTE
%left EQ 
%left NEQ 

%right NOT

%left AND
%left OR 

%right ASSIGN


%%

/* Grammer Rules */


prog_start:	%empty
{
	if(function_vec.size() == 0)
	{
	    char temp[50];
	    printf(temp, 50, "main not found");
}
		| Function prog_start
		;

Function: 		FUNCTION Ident SEMICOLON BEGIN_PARAMS Declaration_loop END_PARAMS BEGIN_LOCALS Declaration_loop END_LOCALS BEGIN_BODY Statement_loop END_BODY{printf("Function -> FUNCTION Ident SEMICOLON BEGIN_PARAMS Declaration_loop END_PARAMS BEGIN_LOCALS Declaration_loop END_LOCALS BEGIN_BODY Statement_loop END_BODY\n");};

Declaration_loop: 	Declaration SEMICOLON Declaration_loop {printf("Declaration_loop -> Declaration SEMICOLON Declaration_loop\n");}
					| %empty {printf("Declaration_loop -> EPSILON\n");}
					;

Declaration:	Ident_loop COLON INTEGER {printf("Declaration -> Ident_loop COLON INTEGER\n");}
				| Ident_loop COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("Declaration -> Ident_loop COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
				;

Ident_loop: 	Ident {printf("Ident_loop -> Ident \n");}
				| Ident COMMA Ident_loop {printf("Ident_loop -> Ident COMMA Ident_loop\n");}
				;

Statement: 	Statement1 {printf("Statement -> Statement1\n");}
			| Statement2 {printf("Statement -> Statement2\n");}
			| Statement3 {printf("Statement -> Statement3\n");}
			| Statement4 {printf("Statement -> Statement4\n");}
			| Statement5 {printf("Statement -> Statement5\n");}
			| Statement6 {printf("Statement -> Statement6\n");}
			| Statement7 {printf("Statement -> Statement7\n");}
			| Statement8 {printf("Statement -> Statement8\n");}
			| Statement9 {printf("Statement -> Statement9\n");}
			;

Statement1:  	Var ASSIGN Expression {printf("Statement1 -> Var ASSIGN Expression\n");}
				;
		
Statement2: 	IF Bool_Expr THEN Statement_loop ElseStatement ENDIF {printf("Statement -> IF Bool_Expr THEN Statement_loop ElseStatement ENDIF\n");}
				;

Statement3: 	WHILE Bool_Expr BEGINLOOP Statement_loop ENDLOOP {printf("Statement -> WHILE Bool_Expr BEGINLOOP Statement_loop SEMICOLON ENDLOOP\n");}
				;

Statement4:		DO BEGINLOOP Statement_loop ENDLOOP WHILE Bool_Expr {printf("Statement -> DO BEGINLOOP Statement_loop SEMICOLON ENDLOOP WHILE Bool_Expr\n");}
				;

Statement5: 	FOR Var ASSIGN NUMBER SEMICOLON Bool_Expr SEMICOLON Var ASSIGN Expression BEGINLOOP Statement_loop ENDLOOP {printf("Statement -> FOR Var ASSIGN NUMBER SEMICOLON Bool_Expr SEMICOLON Var ASSIGN Expression BEGINLOOP Statement_loop SEMICOLON ENDLOOP\n");}
				;

Statement6: 	READ Var_loop {printf("Statement -> READ Var_loop\n");}
				;

Statement7: 	WRITE Var_loop {printf("Statement -> WRITE Var_loop\n");}
				;

Statement8: 	CONTINUE {printf("Statement -> CONTINUE\n");}
				;

Statement9: 	RETURN Expression {printf("Statement -> Expression\n");}
				;

Statement_loop: 	Statement SEMICOLON Statement_loop {printf("Statement_loop -> Statement SEMICOLON Statement_loop\n");}
					| Statement SEMICOLON {printf("Statement_loop -> Statement SEMICOLON\n");}
					;

ElseStatement: 		ELSE Statement_loop {printf("ElseStatement -> ELSE Statement_loop\n");}
					| %empty {printf("ElseStatement -> EPSILON\n");}					
					;

Bool_Expr:		Relation_And_Expr {printf("Bool_Expr -> Relation_And_Expr\n");}
					  | Relation_Expr OR Bool_Expr {printf("Bool_Expr -> Relation_Expr OR Bool_Expr\n");}
					  ; 

Relation_And_Expr:		Relation_Expr {printf("Relation_And_Expr -> Relation_Expr\n");}
						| Relation_Expr AND Relation_And_Expr  {printf("Relation_And_Expr -> Relation_Expr AND Relation_And_Expr\n");}
						;						


Relation_Expr:		NOT Relation_Expr_loop {printf("Relation_Expr -> NOT Relation_Expr_loop\n");}
					| Relation_Expr_loop {printf("Relation_Expr -> Relation_Expr_loop\n");}
					;

Relation_Expr_loop: 	Expression Comp Expression {printf("Relation_Expr_loop -> Expression Comp Expression\n");}
                 		| TRUE	{printf("Relation_Expr_loop -> TRUE\n");}
				| FALSE {printf("Relation_Expr_loop -> FALSE\n");}
				| L_PAREN Bool_Expr R_PAREN {printf("Relation_Expr_loop -> L_PAREN Bool_Expr R_PAREN\n");}
				;
		
Comp: 		EQ {printf("Comp -> EQ\n");}
			| NEQ {printf("Comp -> NEQ\n");}
			| LT {printf("Comp -> LT\n");}
			| GT {printf("Comp -> GT\n");}
			| LTE {printf("Comp -> LTE\n");}
			| GTE {printf("Comp -> GTE\n");}
			;

Expression: 		 Multiplicative_Expr {printf("Expression -> Multiplicative_Expr\n");}
					| Multiplicative_Expr SUB Expression {printf("Expression -> Multiplicative_Expr SUB Expression\n");}
					| Multiplicative_Expr ADD Expression {printf("Expression -> Multiplicative_Expr ADD Expression\n");}
					;

Expression_loop: 	Expression COMMA Expression_loop {printf("Expression -> COMMA Expression\n");}
					| Expression {printf("Expression_loop -> Expression\n");}
					| %empty {printf("Expression_loop -> EPSILON\n");}
					

Multiplicative_Expr:		Term  {printf("Multiplicative_Expr -> Term\n");}
							| Term MOD Multiplicative_Expr {printf("Multiplicative_Expr -> Term MOD Term\n");}
							| Term DIV Multiplicative_Expr {printf("Multiplicative_Expr -> Term DIV Term\n");}
							| Term MULT Multiplicative_Expr {printf("Multiplicative_Expr-> Term MULT Term\n");} 
							;

Term:		 Var {printf("Term -> Var\n");}
			| NUMBER {printf("Term -> NUMBER %d\n", $1);}
			| SUB Var {printf("Term -> SUB Var\n");}
			| SUB NUMBER {printf("Term -> SUB NUMBER %d\n", $2);}
			| L_PAREN Expression R_PAREN {printf("Term -> L_PAREN Expression R_PAREN\n");}
			| SUB L_PAREN Expression R_PAREN {printf("Term -> SUB L_PAREN Expression R_PAREN\n");}
			| Ident L_PAREN Expression_loop R_PAREN {printf("Term -> Ident L_PAREN Expression R_PAREN\n");}
			;

Var:		  Ident {printf("Var -> Ident\n");}
				| Ident L_SQUARE_BRACKET Expression R_SQUARE_BRACKET {printf("Var -> Ident L_SQUARE_BRACKET Expression R_SQUARE_BRACKET\n");}
				;

Var_loop: 		Var {printf("Var_loop -> Var\n");}
				| Var COMMA Var_loop {printf("Var_loop -> Var COMMA Var_loop\n");}
				;

Ident:      IDENT
			{printf("Ident -> IDENT %s \n", $1);};
%%

void yyerror(const char* msg)
{
  extern int currLine;
  extern char* yytext;

  printf("ERROR: %s at symbol \"%s\" on line %d\n", msg, yytext, currLine);
  exit(1);
}
