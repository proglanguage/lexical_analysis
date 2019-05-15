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

%type <npValue> stmlist stm exp term alias

%%

lines :
      | lines line

line  : coment  {}
      | stmlist {printtree($1);
                 printf("\n");
                 generate($1);}
      ;

coment : BEGIN_COMMENT END    {}

stmlist : stm                 {$$ = $1;}
        | stmlist END stm     {$$ = $3;}
        ;

stm : exp                                                 {$$ = $1;}
    | WHILE stm DO END stmlist END_WHILE END              {$$ = mknode( $2, $5, WHILE, "while");}
    | LEFT_PARENTHESIS stmlist RIGHT_PARENTHESIS          {$$ = $2;}
    | LEFT_BRACKET stmlist RIGHT_BRACKET                  {$$ = $2;}
    | LEFT_KEY stmlist RIGHT_KEY                          {$$ = $2;}
    | IF stm THEN END stmlist END_IF END                  {$$ = mknode( $2, $5, IF, "if");}
    | IF stm THEN END stmlist ELSE END stmlist END_IF END {$$ = mknode( $5, $8, ELSE, "if");}
    | stm COMMA stmlist END                               {$$ = mknode( $1, $3, COMMA, ",");}
    ;

exp : term
    | alias ASSIGN exp END        {$$ = mknode($1, $3, ASSIGN, "=");}
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

term : ID                      {char *str = (char *) malloc(10);
                               sprintf(str, "%s", $1);
                               $$ = mknode( 0, 0, ID, str);}
     | NUMBER                  {char *str = (char *) malloc(10);
                               sprintf(str, "%i", $1);
                               $$ = mknode( 0, 0, NUMBER, str);}
     | CHAR_VAL                {char *str = (char *) malloc(2);
                               sprintf(str, "%c", $1);
                               $$ = mknode( 0, 0, CHAR_VAL, str);}
     | STRING_VAL              {char *str = (char *) malloc(100);
                               sprintf(str, "%s", $1);
                               $$ = mknode( 0, 0, STRING_VAL, str);}
     ;

%%

int main (void) {
  return yyparse();
}

int yyerror (char *msg) {
  fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
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
