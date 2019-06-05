%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct node
{
  struct node *left;
  struct node *right;
  int tokcode;
  char *token;
} node;

/*******************************
  #define YYSTYPE struct node *
********************************/

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern int yycolno;

node *mknode(node *left, node *right, int tokcode, char *token);
void printtree(node *tree);
void generate(node *tree);

%}

%union {
  int    iValue;  /* integer value */
  /*float  fValue;  /* float value */
  char   cValue;  /* char value */
  char * sValue;  /* string value */
  struct node * npValue;  /* node pointer value */
  };

%token <sValue> ID
%token <iValue> NUMBER
/*%token <fValue> FLOAT_NUMBER*/
%token <sValue> STRING_VAL
%token <cValue> CHAR_VAL
%token <iValue> BOOL_VAL

%token TRUE FALSE

 /* DELIMITERS */
%token BEGIN_PROGRAM END_PROGRAM
%token COMMENT
%token LEFT_PARENTHESIS  RIGHT_PARENTHESIS
%token LEFT_BRACKET RIGHT_BRACKET
%token LEFT_KEY RIGHT_KEY
%token COMMA
%token DOT
%token ENDL
%token INDENT
%token EXIT
%token BREAK
 /* %token SEMICOLON */

 /*CONTROL STRUCTURES*/
%token PROCEDURE END_PROCEDURE FUNCTION END_FUNCTION IF THEN ELSE END_IF
%token DO WHILE END_WHILE FOR END_FOR LOOP END_LOOP

 /* OPERATORS */
%token ASSIGN
%token PLUS MINUS TIMES DIVIDE  POWER
%token LESS_EQ BIG_EQ LESS BIG EQ
%token AND OR

 /* TYPES */
%token INTEGER
%token CHAR
%token STRING
%token FLOAT
%token BOOLEAN

 /* %start prog */
%start stmts

 /* %left INTEGER CHAR STRING */
 /*%type <npValue> stms stm exp term block type ids array_op params param declare // comment */

%%

stmts : stmt                 {printf("reduce to statement rule 1\n");}
      | stmts ENDL stmt      {printf("reduce to statement rule 2\n");}
      ;

stmt :                {printf("reduce to stmt vazio\n");}
     | declare        {printf("reduce to declare\n");}
     | structs        {printf("reduce to structs\n");}
     | proc           {printf("reduce to proc\n");}
     | assign         {printf("reduce to assign\n");}
     | BREAK          {}
     | EXIT NUMBER    {}
     ;

structs : PROCEDURE ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_PROCEDURE                   {}
        | types FUNCTION ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_FUNCTION               {}
        | WHILE exps DO ENDL stmts END_WHILE                                                                {}
        | LOOP ENDL stmts END_LOOP                                                                          {}
        | if                                                                                                {printf("reduce to if\n");}
        ;

if : IF exps THEN ENDL stmts elseifs END_IF       {}
   ;

elseifs : else            {printf("reduce to else if\n");}
        | elseif elseifs  {}
        ;

elseif : ELSE IF exps THEN ENDL stmts  {}
       ;

else :
     | ELSE ENDL stmts                                      {printf("reduce to else\n");}
     ;

cast : LEFT_PARENTHESIS types RIGHT_PARENTHESIS             {}
     ;

assign : ids ASSIGN exps             {}
       | ids ASSIGN cast exps        {}
       | ID PLUS PLUS                {}
       | ID MINUS MINUS              {}
       ;

ids : ID                      {}
    | ids COMMA ID            {}
    | ID array_ops            {}
    | ids COMMA ID array_ops  {}
    ;

declare : types ids     {}
        | types assign  {}
        ;


params :                                                {}
       | param                                          {}
       | params COMMA param                             {}
       ;

param : types ID                          {}
      /*| types ids assign                   {}*/
      ;

exps : exp              {}
     | exps COMMA exp   {}
     ;

exp : term
    | exp PLUS term            {}
    | exp TIMES term           {}
    | exp DIVIDE term          {}
    | exp MINUS term           {}
    | exp POWER term           {}
    | exp LESS term            {}
    | exp LESS_EQ term         {}
    | exp BIG term             {}
    | exp BIG_EQ term          {}
    | exp EQ term              {}
    | exp AND term              {}
    | exp OR term              {}
    | LEFT_PARENTHESIS exp RIGHT_PARENTHESIS {}
    | exp DOT proc              {}
    | proc                     {}
    ;

proc : ID LEFT_PARENTHESIS RIGHT_PARENTHESIS                  {}
     | ID LEFT_PARENTHESIS exps RIGHT_PARENTHESIS             {}
     ;

types : type              {}
      | type array_ops        {}
      ;

type : INTEGER    {}
     | CHAR       {}
     | STRING     {}
     | FLOAT      {}
     | BOOLEAN    {}
     ;

numeral : NUMBER  {}
        | NUMBER DOT        {}
        | NUMBER DOT NUMBER {}
        ;

bool : TRUE  {}
     | FALSE {}
     ;

array_ops : array_op            {}
          | array_ops array_op  {}
          ;

array_op : LEFT_BRACKET RIGHT_BRACKET        {}
         | LEFT_BRACKET exp RIGHT_BRACKET   {}
         ;

term : ID                     {}
     | ID array_ops           {}
     | numeral                {}
     | CHAR_VAL               {}
     | STRING_VAL             {}
     | bool                   {}
     ;

%%

int main (void) {
  return yyparse();
}

int yyerror (char *msg) {
  fprintf (stderr, "%d: %s at '%s' in col %d\n", yylineno, msg, yytext, yycolno);
  return 0;
}

node *mknode(node *left, node *right, int tokcode, char *token)
{
  /* malloc the node */
  node *newnode = (node *) malloc(sizeof(node));
  char *newstr = (char *) malloc(strlen(token)+1);
  strcpy(newstr, token);
  newnode->left = left;
  newnode->right = right;
  newnode->tokcode = tokcode;
  newnode->token = newstr;
  return(newnode);
}

void printtree(node *tree)
{
  if (tree == (node *) 0)
    return;

  if (tree->left || tree->right)
    printf("(");

  printf(" %s ", tree->token);

  if (tree->left)
    printtree(tree->left);
  if (tree->right)
    printtree(tree->right);

  if (tree->left || tree->right)
    printf(")");
}

void generate(node *tree)
{
  int i;

  /* generate the code for the left side */
  if (tree->left)
    generate(tree->left);
  /* generate the code for the right side */
  if (tree->right)
    generate(tree->right);

  /* generate code for this node */

  switch(tree->tokcode)
  {
  case 0:
    /* we need no code for this node */
    break;

  case ID:
    /* push the number onto the stack */
    printf("PUSH %s\n", tree->token);
    break;

  case NUMBER:
    /* push the number onto the stack */
    printf("PUSH %s\n", tree->token);
    break;

  case CHAR_VAL:
    /* push the number onto the stack */
    printf("PUSH %s\n", tree->token);
    break;

  case STRING_VAL:
    /* push the number onto the stack */
    printf("PUSH %s\n", tree->token);
    break;

  case PLUS:
    printf("POP A\n");
    printf("POP B\n");
    printf("ADD A= A+B\n");
    printf("PUSH A\n");
    break;

  case MINUS:
    printf("POP A\n");
    printf("POP B\n");
    printf("SUB A= A-B\n");
    printf("PUSH A\n");
    break;

  case TIMES:
    printf("POP A\n");
    printf("POP B\n");
    printf("MULT A= A*B\n");
    printf("PUSH A\n");
    break;

  default:
    printf("error unkown AST code %d\n", tree->tokcode);
  }

}
