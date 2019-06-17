%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"
#include "hash_table.h"

int yydebug=0;

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
extern hash_table* symbols;

node *mknode(node *left, node *right, int tokcode, char *token);
void printtree(node *tree);
void generate(node *tree);
char *solve_exp_type(node* exp);

#pragma GCC diagnostic ignored "-Wformat-zero-length"
%}

%union {
  int    iValue;  /* integer value */
  float  fValue;  /* float value */
  char   cValue;  /* char value */
  char * sValue;  /* string value */
  struct var_info * varInfo; /* variable information */
  struct list * varInfoList; /* variables information */
  struct node * npValue; /* node pointer value */
  struct ht_node * htnValue;  /* htn pointer value */
  };

%token <sValue> ID
%token <iValue> NUMBER
%token <fValue> FLOAT_NUMBER
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
%token AMPERSAND
%token ENDL
%token INDENT
%token EXIT
%token BREAK
%token RETURN
%token SEMICOLON

 /*CONTROL STRUCTURES*/
%token PROCEDURE END_PROCEDURE FUNCTION END_FUNCTION IF THEN ELSE END_IF
%token DO WHILE END_WHILE FOR IN END_FOR LOOP END_LOOP
%token STRUCT

 /* OPERATORS */
%token ASSIGN
%token PLUS MINUS TIMES DIVIDE POWER MODULUS
%token LESS_EQ BIG_EQ LESS BIG EQ NEQ
%token AND OR NEG

 /* TYPES */
%token INTEGER
%token CHAR
%token STRING
%token FLOAT
%token BOOLEAN
%token STDIN STDOUT

 /* %start prog */
%start stmts

// %right '='
// %left '+' '-'
// %left '*' '/' '%'
%right ASSIGN OR NEG
%left PLUS MINUS TIMES DIVIDE POWER MODULUS AND
%type <htnValue> declare structs
%type <npValue> stmts stmt cond_structs exp exps for if elseif elseifs forcond
%type <sValue> types type id ids term array_op array_ops cast numeral bool
%type <varInfoList> params declist
%type <varInfo> param

%%

stmts: stmt                 {(yydebug?printf("reduce to statement rule 1\n"):printf(""));}
     | stmts ENDL stmt      {(yydebug?printf("reduce to statement rule 2\n"):printf(""));}
     ;

stmt:                 {(yydebug?printf("reduce to stmt vazio\n"):printf(""));}
    | declare         {
                        (yydebug?printf("reduce to declare\n"):printf(""));
                        if (symbols == NULL) { symbols = create_ht(15); }
                        symbols->insert(symbols, $1);
                      }
    | structs         {
                        (yydebug?printf("reduce to structs\n"):printf(""));
                        if (symbols == NULL) { symbols = create_ht(15); }
                        symbols->insert(symbols, $1);
                      }
    | cond_structs    {
                        (yydebug?printf("reduce to conditional structures\n"):printf(""));
                      }
    | exps            {
                        (yydebug?printf("reduce to exp\n"):printf(""));
                      }
    | BREAK           {
                        (yydebug?printf("reduce to break\n"):printf(""));
                      }
    | EXIT NUMBER     {
                        (yydebug?printf("reduce to exit\n"):printf(""));
                      }
    | RETURN exp      {
                        (yydebug?printf("reduce to return\n"):printf(""));
                      }
    | RETURN          {
                        (yydebug?printf("reduce to return\n"):printf(""));
                      }
    | ids ASSIGN exps {
                        (yydebug?printf("reduce to assign\n"):printf(""));
                      }
    ;

structs: PROCEDURE ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_PROCEDURE          {
                                                                                                    (yydebug?printf("reduce to procedure\n"):printf(""));
                                                                                                    proc_info * proc = create_proc_info($2, $4);
                                                                                                    info* i = malloc(sizeof(info));
                                                                                                    i->var = NULL;
                                                                                                    i->func = NULL;
                                                                                                    i->proc = proc;
                                                                                                    ht_node * n = malloc(sizeof(ht_node));
                                                                                                    n->key = $2; n->value = i;
                                                                                                    $$=n;
                                                                                                  }
       | types FUNCTION ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_FUNCTION      {
                                                                                                    (yydebug?printf("reduce to function\n"):printf(""));
                                                                                                    func_info * func = create_func_info($1,$3,$5);
                                                                                                    info* i = malloc(sizeof(info));
                                                                                                    i->var = NULL;
                                                                                                    i->func = func;
                                                                                                    i->proc = NULL;
                                                                                                    ht_node * n = malloc(sizeof(ht_node));
                                                                                                    n->key = $3; n->value = i;
                                                                                                    $$=n;
                                                                                                  }
       | ids FUNCTION ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_FUNCTION        {
                                                                                                    (yydebug?printf("reduce to function\n"):printf(""));
                                                                                                    func_info * func = create_func_info($1,$3,$5);
                                                                                                    info* i = malloc(sizeof(info));
                                                                                                    i->var = NULL;
                                                                                                    i->func = func;
                                                                                                    i->proc = NULL;
                                                                                                    ht_node * n = malloc(sizeof(ht_node));
                                                                                                    n->key = $3; n->value = i;
                                                                                                    $$=n;
                                                                                                  }
       | ID SEMICOLON STRUCT LEFT_KEY ENDL declist ENDL RIGHT_KEY                                 {
                                                                                                    (yydebug?printf("reduce to struct\n"):printf(""));
                                                                                                    func_info * func = create_func_info($1,"struct",$6);
                                                                                                    info* i = malloc(sizeof(info));
                                                                                                    i->var = NULL;
                                                                                                    i->func = func;
                                                                                                    i->proc = NULL;
                                                                                                    ht_node * n = malloc(sizeof(ht_node));
                                                                                                    char * str = malloc(255);
                                                                                                    sprintf(str, "struct.%s", $1);
                                                                                                    n->key = str; n->value = i;
                                                                                                    $$=n;
                                                                                                  }
       ;

cond_structs: WHILE exps DO ENDL stmts END_WHILE                                                {
                                                                                                  (yydebug?printf("reduce to while\n"):printf(""));
                                                                                                }
            | LOOP ENDL stmts END_LOOP                                                          {
                                                                                                  (yydebug?printf("reduce to loop\n"):printf(""));
                                                                                                }
            | if                                                                                {
                                                                                                  (yydebug?printf("reduce to if\n"):printf(""));
                                                                                                }
            | for                                                                               {
                                                                                                  (yydebug?printf("reduce to for\n"):printf(""));
                                                                                                }
            ;

if: IF exps THEN ENDL stmts elseifs END_IF       {(yydebug?printf("reduce to preif\n"):printf(""));}
  ;

elseifs: else            {(yydebug?printf("reduce to else after elseifs\n"):printf(""));}
       | elseif elseifs  {(yydebug?printf("reduce to elsifs\n"):printf(""));}
       ;

elseif: ELSE IF exps THEN ENDL stmts  {(yydebug?printf("reduce to else if\n"):printf(""));}
      ;

else:
    | ELSE ENDL stmts     {(yydebug?printf("reduce to else\n"):printf(""));}
    ;

declist: declare                {
                                  (yydebug?printf("reduce to declare on declist\n"):printf(""));
                                  list* lst = create_ll(sizeof(var_info*));
                                  lst->push(lst, $1->value->var);
                                  $$=lst;
                                }
       | declist ENDL declare   {
                                  (yydebug?printf("reduce to declist\n"):printf(""));
                                  list* lst = create_ll(sizeof(var_info*));
                                  lst->push(lst, $3->value->var);
                                  $$=lst->merge($1, lst);
                                }
       ;

for: FOR forcond stmts END_FOR         {(yydebug?printf("reduce to for\n"):printf(""));}
   ;

forcond: ID IN exp ENDL                                           {(yydebug?printf("reduce to forcond\n"):printf(""));}
       | LEFT_PARENTHESIS declare RIGHT_PARENTHESIS                  {(yydebug?printf("reduce to forcond\n"):printf(""));}
       ;

cast: LEFT_PARENTHESIS types RIGHT_PARENTHESIS             {(yydebug?printf("reduce to cast\n"):printf(""));}
    ;

ids: id                       {
                                (yydebug?printf("reduce to id\n"):printf(""));
                                $$=$1;
                              }
   | ids id                   {
                                (yydebug?printf("reduce to ids"):printf(""));
                                char* tmp= malloc(255); sprintf(tmp, "%s %s", $1, $2);
                                $$=tmp;
                              }
   | ids COMMA id             {
                                (yydebug?printf("reduce to ids\n"):printf(""));
                                char* tmp= malloc(255); sprintf(tmp, "%s,%s", $1, $3);
                                $$=tmp;
                              }
   | ids DOT id               {
                                (yydebug?printf("reduce to ids\n"):printf(""));
                                char* tmp= malloc(255); sprintf(tmp, "%s.%s", $1, $3);
                                $$=tmp;
                              }
   ;

id: ID                      {
                              (yydebug?printf("reduce to id\n"):printf(""));
                              char* tmp= malloc(255); sprintf(tmp, "%s", $1);
                              $$=tmp;
                            }
  | ID array_ops            {
                              (yydebug?printf("reduce to array\n"):printf(""));
                              char* tmp= malloc(255); sprintf(tmp, "%s[%s]", $1, $2);
                              $$=tmp;
                            }
  ;

declare: types ids                  {
                                      (yydebug?printf("reduce to declare\n"):printf(""));
                                      var_info * var = create_var_info($2,$1);
                                      info* i = malloc(sizeof(info));
                                      i->var = var;
                                      i->func = NULL;
                                      i->proc = NULL;
                                      ht_node * n = malloc(sizeof(ht_node));
                                      n->key = $2; n->value = i;
                                      $$=n;
                                    }
       | id ids                     {
                                      (yydebug?printf("reduce to declare\n"):printf(""));
                                      var_info * var = create_var_info($2,$1);
                                      info* i = malloc(sizeof(info));
                                      i->var = var;
                                      i->func = NULL;
                                      i->proc = NULL;
                                      ht_node * n = malloc(sizeof(ht_node));
                                      n->key = $2; n->value = i;
                                      $$=n;
                                    }
       | types ids ASSIGN exps      {
                                      (yydebug?printf("reduce to declare with assign\n"):printf(""));
                                      var_info * var = create_var_info($2,$1);
                                      info* i = malloc(sizeof(info));
                                      i->var = var;
                                      i->func = NULL;
                                      i->proc = NULL;
                                      ht_node * n = malloc(sizeof(ht_node));
                                      n->key = $2; n->value = i;
                                      $$=n;
                                    }
       | id ids ASSIGN exps         {
                                      (yydebug?printf("reduce to declare with assign\n"):printf(""));
                                      var_info * var = create_var_info($2,$1);
                                      info* i = malloc(sizeof(info));
                                      i->var = var;
                                      i->func = NULL;
                                      i->proc = NULL;
                                      ht_node * n = malloc(sizeof(ht_node));
                                      n->key = $2; n->value = i;
                                      $$=n;
                                    }
       ;

params:                                                 {
                                                          (yydebug?printf("reduce to void params"):printf(""));
                                                          list* lst = create_ll(sizeof(var_info*));
                                                          $$=lst;
                                                        }
      | param                                           {
                                                          (yydebug?printf("reduce to param\n"):printf(""));
                                                          list* lst = create_ll(sizeof(var_info*));
                                                          lst->push(lst, $1);
                                                          $$=lst;
                                                        }
      | params COMMA param                              {
                                                          (yydebug?printf("reduce to params\n"):printf(""));
                                                          list* lst = create_ll(sizeof(var_info*));
                                                          lst->push(lst, $3);
                                                          $$=lst->merge($1, lst);
                                                        }
      ;

param: types id                           {
                                            (yydebug?printf("reduce to param\n"):printf(""));
                                            var_info * var = create_var_info($2,$1);
                                            $$=var;
                                          }
     | id id                              {
                                            (yydebug?printf("reduce to param\n"):printf(""));
                                            var_info * var = create_var_info($2,$1);
                                            $$=var;
                                          }
     ;

exps: exp              {(yydebug?printf("reduce to exp\n"):printf(""));}
    | exps exp         {(yydebug?printf("reduce to exps\n"):printf(""));}
    ;

exp: term                                        {(yydebug?printf("reduce to term\n"):printf(""));}
   | exp PLUS exp                                {(yydebug?printf("reduce to adition\n"):printf(""));}
   | exp TIMES exp                               {(yydebug?printf("reduce to multiplication\n"):printf(""));}
   | exp DIVIDE exp                              {(yydebug?printf("reduce to division\n"):printf(""));}
   | exp MINUS exp                               {(yydebug?printf("reduce to subtraction\n"):printf(""));}
   | exp POWER exp                               {(yydebug?printf("reduce to power\n"):printf(""));}
   | exp MODULUS exp                             {(yydebug?printf("reduce to modulus\n"):printf(""));}
   | exp LESS exp                                {(yydebug?printf("reduce to less\n"):printf(""));}
   | exp LESS_EQ exp                             {(yydebug?printf("reduce to less equal\n"):printf(""));}
   | exp BIG exp                                 {(yydebug?printf("reduce to big\n"):printf(""));}
   | exp BIG_EQ exp                              {(yydebug?printf("reduce to big equal\n"):printf(""));}
   | exp EQ exp                                  {(yydebug?printf("reduce to equal\n"):printf(""));}
   | exp NEQ exp                                 {(yydebug?printf("reduce to not equal\n"):printf(""));}
   | NEG exp                                     {(yydebug?printf("reduce to negate\n"):printf(""));}
   | exp AND exp                                 {(yydebug?printf("reduce to and\n"):printf(""));}
   | exp OR exp                                  {(yydebug?printf("reduce to or\n"):printf(""));}
   | exp DOT exp                                 {(yydebug?printf("reduce to dot\n"):printf(""));}
   | exp COMMA exp                               {(yydebug?printf("reduce to comma\n"):printf(""));}
   | exp PLUS PLUS                               {(yydebug?printf("reduce to assign++\n"):printf(""));}
   | exp MINUS MINUS                             {(yydebug?printf("reduce to assign--\n"):printf(""));}
   | exp LEFT_PARENTHESIS RIGHT_PARENTHESIS      {(yydebug?printf("reduce to exp()\n"):printf(""));}
   | exp LEFT_PARENTHESIS exp RIGHT_PARENTHESIS  {(yydebug?printf("reduce to exp(exp)\n"):printf(""));}
   | LEFT_PARENTHESIS exp RIGHT_PARENTHESIS      {(yydebug?printf("reduce to (exp)\n"):printf(""));}
   ;

types: type               {
                            (yydebug?printf("reduce to type\n"):printf(""));
                          }
     | type array_ops     {
                            (yydebug?printf("reduce to type[]\n"):printf(""));
                          }
     ;

type: INTEGER     {
                    (yydebug?printf("reduce to int\n"):printf(""));
                    $$="int";
                  }
    | CHAR        {
                    (yydebug?printf("reduce to char\n"):printf(""));
                    $$="char";
                  }
    | STRING      {
                    (yydebug?printf("reduce to string\n"):printf(""));
                    $$="str";
                  }
    | FLOAT       {
                    (yydebug?printf("reduce to float\n"):printf(""));
                    $$="float";
                  }
    | BOOLEAN     {
                    (yydebug?printf("reduce to bool\n"):printf(""));
                    $$="bool";
                  }
    ;

numeral: NUMBER             {
                              (yydebug?printf("reduce to number\n"):printf(""));
                              char * tmp = malloc(255);
                              sprintf(tmp,"%i",$1);
                              $$=tmp;
                            }
       | FLOAT_NUMBER       {
                              (yydebug?printf("reduce to float_number\n"):printf(""));
                              char * tmp = malloc(255);
                              sprintf(tmp,"%f",$1);
                              $$=tmp;
                            }
       | MINUS NUMBER       {
                              (yydebug?printf("reduce to number\n"):printf(""));
                              char * tmp = malloc(255);
                              sprintf(tmp,"-%i",$2);
                              $$=tmp;
                            }
       | MINUS FLOAT_NUMBER {
                              (yydebug?printf("reduce to float_number\n"):printf(""));
                              char * tmp = malloc(255);
                              sprintf(tmp,"-%f",$2);
                              $$=tmp;
                            }
       ;

bool: TRUE  {
              (yydebug?printf("reduce to true\n"):printf(""));
              char * tmp = malloc(5);
              sprintf(tmp,"true");
              $$=tmp;
            }
    | FALSE {
              (yydebug?printf("reduce to false\n"):printf(""));
              char * tmp = malloc(6);
              sprintf(tmp,"false");
              $$=tmp;
            }
    ;

array_ops: array_op             {
                                  (yydebug?printf("reduce to array_op\n"):printf(""));
                                  $$=$1;
                                }
         | array_ops array_op   {
                                  (yydebug?printf("reduce to array_ops\n"):printf(""));
                                  char* tmp = malloc(255);
                                  sprintf(tmp,"%s%s", $1, $2);
                                  $$=tmp;
                                }
         ;

array_op: LEFT_BRACKET RIGHT_BRACKET        {
                                              (yydebug?printf("reduce to []\n"):printf(""));
                                              char* tmp = malloc(255);
                                              sprintf(tmp,"[]");
                                              $$=tmp;
                                            }
        | LEFT_BRACKET exp RIGHT_BRACKET    {
                                              (yydebug?printf("reduce to [exp]\n"):printf(""));
                                              char* tmp = malloc(255);
                                              sprintf(tmp,"[%s]", solve_exp_type($2));
                                              $$=tmp;
                                            }
        ;


term: ids         {
                    (yydebug?printf("reduce to id\n"):printf(""));
                    $$=$1;
                  }
    | array_ops   {
                    (yydebug?printf("reduce to array_ops\n"):printf(""));
                    $$=$1;
                  }
    | numeral     {
                    (yydebug?printf("reduce to numeral\n"):printf(""));
                    $$=$1;
                  }
    | CHAR_VAL    {
                    (yydebug?printf("reduce to charval\n"):printf(""));
                    char * tmp = malloc(1);
                    sprintf(tmp, "%c", $1);
                    $$=tmp;
                  }
    | STRING_VAL  {
                    (yydebug?printf("reduce to stringval\n"):printf(""));
                    char * tmp = malloc(255);
                    sprintf(tmp, "%s", $1);
                    $$=tmp;
                  }
    | bool        {
                    (yydebug?printf("reduce to boolean\n"):printf(""));
                    $$=$1;
                  }
    | cast        {
                    (yydebug?printf("reduce to cast\n"):printf(""));
                    $$=$1;
                  }
    | STDIN       {
                    (yydebug?printf("reduce to puts\n"):printf(""));
                    char * tmp = malloc(5);
                    sprintf(tmp, "puts");
                    $$=tmp;
                  }
    | STDOUT      {
                    (yydebug?printf("reduce to gets\n"):printf(""));
                    char * tmp = malloc(5);
                    sprintf(tmp, "gets");
                    $$=tmp;
                  }
    ;


%%

// int parse () {
  // return yyparse();
// }

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
  if (tree == NULL/* (node *) 0 */)
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

/**
 * Deve chamar a função de erro em caso de tipos de operandos incompatíveis
 * Caso contrário, retorna o tipo da expressão
 */
char * solve_exp_type(node* exp){
  return NULL;
}