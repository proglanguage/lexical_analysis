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
  char   cValue;  /* char value */
  char * sValue;  /* string value */
  struct node * npValue;  /* node pointer value */
  };

%token <sValue> ID
%token <iValue> NUMBER
%token <sValue> STRING_VAL
%token <cValue> CHAR_VAL


 /* DELIMITERS */
%token BEGIN_COMMENT
%token LEFT_PARENTHESIS  RIGHT_PARENTHESIS
%token LEFT_BRACKET RIGHT_BRACKET
%token LEFT_KEY RIGHT_KEY
%token COMMA
%token DOT
%token END
%token INDENT
 /* %token SEMICOLON */

 /*CONTROL STRUCTURES*/
%token PROCEDURE END_PROCEDURE FUNCTION END_FUNCTION IF THEN ELSE END_IF
%token DO WHILE END_WHILE FOR END_FOR

 /* OPERATORS */
%token ASSIGN
%token PLUS MINUS TIMES DIVIDE  POWER
%token LESS_EQ BIG_EQ LESS BIG EQ

 /* TYPES */
%token INTEGER
%token CHAR
%token STRING

 /* %start prog */
%start stms

 /* %left INTEGER CHAR STRING */
%type <npValue> stms stm exp term block type ids array params param // declare

%%

/* lines :
      | lines line

line  : coment  {}
      | stms    {}
      ;

coment : BEGIN_COMMENT END      {} */

stms : stm END                {}
     | stms stm END           {}
     ;

stm : declare         {}
    | block           {}
    | structs         {}
    ;

structs : PROCEDURE ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS END block END_PROCEDURE            {}
        | types FUNCTION ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS END block END_FUNCTION              {}
        | WHILE stm DO END stms END_WHILE                        {}
        | IF stm THEN END block END_IF                           {}
        | IF stm THEN END block ELSE END block END_IF            {}
        ;

block : INDENT stms                                           {}
      | LEFT_BRACKET stms RIGHT_BRACKET                       {}
      | LEFT_KEY stms RIGHT_KEY                               {}
      ;

params :                                                      {}
       | param                                          {}
       | params COMMA param                             {}
       /*| LEFT_PARENTHESIS params RIGHT_PARENTHESIS            {}*/
       ;

param : types ids                          {}
      /*| types ids assign                   {}*/
      ;

assign : ASSIGN exps        {}
       ;

ids : ID                  {}
    | ids COMMA ID        {}
    /* | ID array            {}
    | ids COMMA ID array  {} */
    ;

declare : types ids         {}
        | types ids assign  {}
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
    ;

types : type              {}
      | type array        {}
      ;

type : INTEGER    {}
     | CHAR       {}
     | STRING     {}
     ;

array : LEFT_BRACKET RIGHT_BRACKET        {}
      | LEFT_BRACKET term RIGHT_BRACKET   {}

term : ID                     {char *str = (char *) malloc(10);
                               sprintf(str, "%s", $1);
                               $$ = mknode( 0, 0, ID, str);}
     | NUMBER                 {char *str = (char *) malloc(10);
                               sprintf(str, "%i", $1);
                               $$ = mknode( 0, 0, NUMBER, str);}
     | CHAR_VAL               {char *str = (char *) malloc(2);
                               sprintf(str, "%c", $1);
                               $$ = mknode( 0, 0, CHAR_VAL, str);}
     | STRING_VAL             {char *str = (char *) malloc(100);
                               sprintf(str, "%s", $1);
                               $$ = mknode( 0, 0, STRING_VAL, str);}
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
