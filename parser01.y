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
%token PROCEDURE END_PROCEDURE IF THEN ELSE END_IF
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

%start lines

 /* %left INTEGER CHAR STRING */
%type <npValue> stmlist stm exp term block ass type declaration alias paramslist param array

%%

lines :
      | lines line

line  : coment  {}
      | stmlist {printtree($1);
                 printf("\n");
                 generate($1);}
      ;

coment : BEGIN_COMMENT END      {}

stmlist : stm END               {$$ = $1;}
        | stmlist END stm END       {$$ = $3;}
        ;

stm : ass                                                                                    {$$ = $1;}
    | WHILE stm DO END stmlist END_WHILE                                                     {$$ = mknode( $2, $5, WHILE, "while");}
    | LEFT_PARENTHESIS stmlist RIGHT_PARENTHESIS                                             {$$ = $2;}
    | LEFT_BRACKET stmlist RIGHT_BRACKET                                                     {$$ = $2;}
    | LEFT_KEY stmlist RIGHT_KEY                                                             {$$ = $2;}
    | IF stm THEN END block END_IF                                                           {$$ = mknode( $2, $5, IF, "if");}
    | IF stm THEN END block ELSE END block END_IF                                            {$$ = mknode( $5, $8, ELSE, "if");}
    | PROCEDURE alias LEFT_PARENTHESIS paramslist RIGHT_PARENTHESIS END block END_PROCEDURE  {$$ = mknode( $2, $4, PROCEDURE, "procedure");}
    | block                                                                                  {$$ = $1;}
    | declaration                                                                            {$$ = $1;}
    ;

declaration : type param
            ;

ass : alias ASSIGN exp {$$ = mknode($1,$3,ID,"assignment");}
    ;

block : INDENT stmlist END {$$ = $2;}
      ;

paramslist :                                {$$ = mknode( 0, 0,ID,"params");}
           | type param                     {$$ = mknode($1,$2,ID,"params");}
           | paramslist COMMA type param    {$$ = mknode($3,$4,ID,"params");}
           ;

param : ass           {$$ = $1;}
      | alias         {$$ = $1;}
      | array alias   {$$ = mknode($1,$2,ID,"array");}
      ;

array : LEFT_BRACKET RIGHT_BRACKET        {$$ = mknode( 0, 0,ID,"array");}
      | LEFT_BRACKET term RIGHT_BRACKET   {$$ = mknode( 0,$2,ID,"array");}
      ;

type : INTEGER {$$ = mknode( 0, 0, INTEGER, "int");}
     | CHAR    {$$ = mknode( 0, 0, CHAR, "char");}
     | STRING  {$$ = mknode( 0, 0, STRING, "str");}
     ;

exp : term
    | exp PLUS term            {$$ = mknode($1, $3, PLUS, "+");}
    | exp TIMES term           {$$ = mknode($1, $3, TIMES, "*");}
    | exp DIVIDE term          {$$ = mknode($1, $3, DIVIDE, "/");}
    | exp MINUS term           {$$ = mknode($1, $3, MINUS, "-");}
    | exp POWER term           {$$ = mknode($1, $3, POWER, "^");}
    | exp LESS term            {$$ = mknode($1, $3, LESS, "<");}
    | exp LESS_EQ term         {$$ = mknode($1, $3, LESS_EQ, "<=");}
    | exp BIG term             {$$ = mknode($1, $3, BIG, ">");}
    | exp BIG_EQ term          {$$ = mknode($1, $3, BIG_EQ, ">=");}
    | exp EQ term              {$$ = mknode($1, $3, EQ, "==");}
    ;

alias : ID                    {char *str = (char *) malloc(10);
                               sprintf(str, "%s", $1);
                               $$ = mknode( 0, 0, ID, str);}
      ;

term : alias                  {$$ = $1;}
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
