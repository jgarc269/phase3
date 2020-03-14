%{
 #include <stdio.h>
 #include <stdlib.h>
 #include <string>

 void yyerror(const char *msg);
 extern int currLine;
 extern int currPos;
 FILE * yyin;

 std::vector<std::string> statement_vec;
 std::vector<std::string> operation_vec;
 std::vector<std::string> expression_vec;
 std::vector<std::string> declaration_vec;
 std::vector<std::string> function_vec;

 std::string new_label();
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
}
| Function prog_start {};

Function: 		
FUNCTION Ident SEMICOLON BEGIN_PARAMS Declaration_loop END_PARAMS BEGIN_LOCALS Declaration_loop END_LOCALS BEGIN_BODY Statement_loop END_BODY
{
	for(int i = 0; i < function_vec.size(); i++)
	{
		
	}
};
Declaration_loop: 	Declaration SEMICOLON Declaration_loop ;}
					| %empty 
					;

Declaration:	Ident_loop COLON INTEGER 
				| Ident_loop COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {printf("Declaration -> Ident_loop COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);}
				;

Ident_loop: 	Ident
				| Ident COMMA Ident_loop 
				;

Statement: 	
Statement1
{
	$$.code = $1.code;
}
| Statement2
{
	$$.code = $1.code;
}
| Statement3 
{
	$$.code = $1.code;
}
| Statement4 
{
	$$.code = $1.code;
}
| Statement5 
{
	$$.code = $1.code;
}
| Statement6 
{
	$$.code = $1.code;
}
| Statement7 
{
	$$.code = $1.code;
}
| Statement8 
{
	$$.code = $1.code;
}
| Statement9 
{
	$$.code = $1.code;
};

Statement1:  	Var ASSIGN Expression 
				;
		
Statement2: 	
IF Bool_Expr THEN Statement_loop ElseStatement ENDIF 
{
	std::string l = new_label();
	std::string m = new_label();

	stringstream oss;

	oss << $2.code;
	oss << "?:=" << $2.result_id << ";" << l << std::endl;
	oss << ":=" << m << std::endl;
	oss << ":" << l << std::endl;
	oss << $4.code;
	oss << ":" << m << std::endl;
	$$.code = oss.str();
};

Statement3: 	
WHILE Bool_Expr BEGINLOOP Statement_loop ENDLOOP 
{

};

Statement4:		DO BEGINLOOP Statement_loop ENDLOOP WHILE Bool_Expr 
				;

Statement5: 	FOR Var ASSIGN NUMBER SEMICOLON Bool_Expr SEMICOLON Var ASSIGN Expression BEGINLOOP Statement_loop ENDLOOP 
				;

Statement6: 	READ Var_loop 
				;

Statement7: 	WRITE Var_loop 
				;

Statement8: 	CONTINUE 
				;

Statement9: 	RETURN Expression 
				;

Statement_loop: 	Statement SEMICOLON Statement_loop 
					| Statement SEMICOLON 
					;

ElseStatement: 		ELSE Statement_loop
					| %empty 
					;

Bool_Expr:		Relation_And_Expr
{
	stringstream oss;
	$1.code = oss.str();
	$1.result_id = oss.str();
}
					  | Relation_Expr OR Bool_Expr 
					  ; 

Relation_And_Expr:		Relation_Expr 
{
	stringstream oss;
	$1.code = oss.str();
	$1.result_id = oss.str();
}
						| Relation_Expr AND Relation_And_Expr 
						;						


Relation_Expr:		
NOT Relation_Expr_loop 
{
	stringstream oss;
	$1.code = oss.str();
	$1.result_id = oss.str();
}
					| Relation_Expr_loop 
					;

Relation_Expr_loop: 	
Expression Comp Expression 
{

}                 		
| TRUE
{
	std::string s = "1";
    $$.result_id = s;
    $$.code = new string();
}	
| FALSE
{
	std::string s = "0";
    $$.result_id = s;
    $$.code = new string();
} 
| L_PAREN Bool_Expr R_PAREN
{

};
		
Comp: 		
EQ 
{
	std::string s "==";
	$$.result_id = s;
	$$.code = new string();
}
| NEQ
{
	std::string s "!=";
	$$.result_id = s;
	$$.code = new string();
} 
| LT
{
	std::string s "<";
	$$.result_id = s;
	$$.code = new string();
} 
| GT 
{
	std::string s ">";
	$$.result_id = s;
	$$.code = new string();
}
| LTE 
{
	std::string s "<=";
	$$.result_id = s;
	$$.code = new string();
}
| GTE 
{
	std::string s "=>";
	$$.result_id = s;
	$$.code = new string();
};

Expression: 		 Multiplicative_Expr 
					| Multiplicative_Expr SUB Expression 
					| Multiplicative_Expr ADD Expression 
					;

Expression_loop: 	Expression COMMA Expression_loop 
					| Expression 
					| %empty 
					;

Multiplicative_Expr:		Term  
							| Term MOD Multiplicative_Expr 
							| Term DIV Multiplicative_Expr 
							| Term MULT Multiplicative_Expr 
							;

Term:		 
Var 
| NUMBER 
{

}
| SUB Var 
{

}
| SUB NUMBER 
{

}
| L_PAREN Expression R_PAREN 
{
	$$.code = $1.result_id;
    $$.result_id = $1.result_id;
}
| SUB L_PAREN Expression R_PAREN 
| Ident L_PAREN Expression_loop R_PAREN 
			;

Var:		  Ident 
				| Ident L_SQUARE_BRACKET Expression R_SQUARE_BRACKET 
				;

Var_loop: 		Var 
				| Var COMMA Var_loop 
				;

Ident:      
IDENT
{
	stringstream oss;
	$1.result_id = oss.str();
	$$.code = oss.str();
}			
%%

void yyerror(const char* msg)
{
  extern int currLine;
  extern char* yytext;

  printf("ERROR: %s at symbol \"%s\" on line %d\n", msg, yytext, currLine);
  exit(1);
}

std::string new_label()
{
	static int num = 0;
	return 'L' + std::to_string(num++); 
}
