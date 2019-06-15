%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"
#include "hash_table.h"

// typedef struct node
// {
//   struct node *left;
//   struct node *right;
//   int tokcode;
//   char *token;
// } node;

/*******************************
  #define YYSTYPE struct node *
********************************/

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;
extern int yycolno;

// node *mknode(node *left, node *right, int tokcode, char *token);
// void printtree(node *tree);
// void generate(node *tree);

%}

%union {
  int    iValue;  /* integer value */
  float  fValue;  /* float value */
  char   cValue;  /* char value */
  char * sValue;  /* string value */
  struct ht_node * npValue;  /* node pointer value */
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
%token PLUS MINUS TIMES DIVIDE  POWER
%token LESS_EQ BIG_EQ LESS BIG EQ NEQ
%token AND OR NEG

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

stmts: stmt                 {printf("reduce to statement rule 1\n");}
     | stmts ENDL stmt      {printf("reduce to statement rule 2\n");}
     ;

stmt:                 {printf("reduce to stmt vazio\n");}
    | declare         {printf("reduce to declare\n");}
    | structs         {printf("reduce to structs\n");}
    | exp             {printf("reduce to exp\n");}
    | BREAK           {printf("reduce to break\n");}
    | EXIT NUMBER     {printf("reduce to exit\n");}
    | RETURN exp      {printf("reduce to return\n");}
    | RETURN          {printf("reduce to return\n");}
    | ids ASSIGN exps {printf("reduce to assign\n");}
    ;

structs: PROCEDURE ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_PROCEDURE                   {printf("reduce to procedure\n");}
       | types FUNCTION ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_FUNCTION               {printf("reduce to function\n");}
       | ids FUNCTION ID LEFT_PARENTHESIS params RIGHT_PARENTHESIS ENDL stmts END_FUNCTION                 {printf("reduce to function\n");}
       | WHILE exps DO ENDL stmts END_WHILE                                                                {printf("reduce to while\n");}
       | LOOP ENDL stmts END_LOOP                                                                          {printf("reduce to loop\n");}
       | ID SEMICOLON STRUCT LEFT_KEY ENDL declist ENDL RIGHT_KEY                                          {printf("reduce to struct\n");}
       | if                                                                                                {printf("reduce to if\n");}
       | for                                                                                               {printf("reduce to for\n");}
       ;

if: IF exps THEN ENDL stmts elseifs END_IF       {printf("reduce to preif\n");}
  ;

elseifs: else            {printf("reduce to else after elseifs\n");}
       | elseif elseifs  {printf("reduce to elsifs\n");}
       ;

elseif: ELSE IF exps THEN ENDL stmts  {printf("reduce to else if\n");}
      ;

else:
    | ELSE ENDL stmts                                      {printf("reduce to else\n");}
    ;

declist: declare                {printf("reduce to declare on declist\n");}
       | declist ENDL declare   {printf("reduce to declist\n");}
       ;

for: FOR forcond stmts END_FOR         {printf("reduce to for\n");}
   ;

forcond: ID IN exp ENDL                                           {printf("reduce to forcond\n");}
       | LEFT_PARENTHESIS declare RIGHT_PARENTHESIS                  {printf("reduce to forcond\n");}
       ;

cast: LEFT_PARENTHESIS types RIGHT_PARENTHESIS             {printf("reduce to cast\n");}
    ;

ids: id                      {printf("reduce to id\n");}
   | ids id                  {printf("reduce to ids");}
   | ids COMMA id            {printf("reduce to ids\n");}
   | ids DOT id              {printf("reduce to ids\n");}
   ;

id: ID                      {printf("reduce to id\n");}
  | ID array_ops            {printf("reduce to array\n");}
  ;

declare: types ids                 {printf("reduce to declare\n");}
       | types ids ASSIGN exps     {printf("reduce to declare with assign\n");}
       ;

params:                                                {}
      | param                                          {printf("reduce to param\n");}
      | params COMMA param                             {printf("reduce to params\n");}
      ;

param: types ID                          {printf("reduce to param\n");}
     | id id                             {printf("reduce to param\n");}
     ;

exps: exp              {printf("reduce to exp\n");}
    | exps exp         {printf("reduce to exps\n");}
    ;

exp: term                                        {printf("reduce to term\n");}
   | exp PLUS term                               {printf("reduce to adition\n");}
   | exp TIMES term                              {printf("reduce to multiplication\n");}
   | exp DIVIDE term                             {printf("reduce to division\n");}
   | exp MINUS term                              {printf("reduce to subtraction\n");}
   | exp POWER term                              {printf("reduce to power\n");}
   | exp LESS term                               {printf("reduce to less\n");}
   | exp LESS_EQ term                            {printf("reduce to less equal\n");}
   | exp BIG term                                {printf("reduce to big\n");}
   | exp BIG_EQ term                             {printf("reduce to big equal\n");}
   | exp EQ term                                 {printf("reduce to equal\n");}
   | exp NEQ term                                {printf("reduce to not equal\n");}
   | NEG exp                                     {printf("reduce to negate\n");}
   | exp AND term                                {printf("reduce to and\n");}
   | exp OR term                                 {printf("reduce to or\n");}
   | exp DOT term                                {printf("reduce to dot\n");}
   | exp COMMA term                              {printf("reduce to comma\n");}
   | exp PLUS PLUS                               {printf("reduce to assign++\n");}
   | exp MINUS MINUS                             {printf("reduce to assign--\n");}
   | exp LEFT_PARENTHESIS RIGHT_PARENTHESIS      {printf("reduce to exp()\n");}
   | exp LEFT_PARENTHESIS exp RIGHT_PARENTHESIS  {printf("reduce to exp(exp)\n");}
   | LEFT_PARENTHESIS exp RIGHT_PARENTHESIS      {printf("reduce to (exp)\n");}
   ;

types: type              {printf("reduce to type\n");}
     | type array_ops    {printf("reduce to type[]\n");}
     ;

type: INTEGER    {printf("reduce to int\n");}
    | CHAR       {printf("reduce to char\n");}
    | STRING     {printf("reduce to string\n");}
    | FLOAT      {printf("reduce to float\n");}
    | BOOLEAN    {printf("reduce to bool\n");}
    ;

numeral: NUMBER             {printf("reduce to number\n");}
       | FLOAT_NUMBER       {printf("reduce to float_number\n");}
       ;

bool: TRUE  {printf("reduce to true\n");}
    | FALSE {printf("reduce to false\n");}
    ;

array_ops: array_op            {printf("reduce to array_op\n");}
         | array_ops array_op  {printf("reduce to array_ops\n");}
         ;

array_op: LEFT_BRACKET RIGHT_BRACKET        {printf("reduce to []\n");}
        | LEFT_BRACKET exp RIGHT_BRACKET    {printf("reduce to [exp]\n");}
        ;


term: ids                    {printf("reduce to id\n");}
    | array_ops              {printf("reduce to array_ops\n");}
    | numeral                {printf("reduce to numeral\n");}
    | CHAR_VAL               {printf("reduce to charval\n");}
    | STRING_VAL             {printf("reduce to stringval\n");}
    | bool                   {printf("reduce to boolean\n");}
    | cast                   {printf("reduce to cast\n");}
    ;


%%

// int parse () {
  // return yyparse();
// }

int yyerror (char *msg) {
  fprintf (stderr, "%d: %s at '%s' in col %d\n", yylineno, msg, yytext, yycolno);
  return 0;
}

// node *mknode(node *left, node *right, int tokcode, char *token)
// {
//   /* malloc the node */
//   node *newnode = (node *) malloc(sizeof(node));
//   char *newstr = (char *) malloc(strlen(token)+1);
//   strcpy(newstr, token);
//   newnode->left = left;
//   newnode->right = right;
//   newnode->tokcode = tokcode;
//   newnode->token = newstr;
//   return(newnode);
// }

// void printtree(node *tree)
// {
//   if (tree == (node *) 0)
//     return;

//   if (tree->left || tree->right)
//     printf("(");

//   printf(" %s ", tree->token);

//   if (tree->left)
//     printtree(tree->left);
//   if (tree->right)
//     printtree(tree->right);

//   if (tree->left || tree->right)
//     printf(")");
// }

// void generate(node *tree)
// {
//   int i;

//   /* generate the code for the left side */
//   if (tree->left)
//     generate(tree->left);
//   /* generate the code for the right side */
//   if (tree->right)
//     generate(tree->right);

//   /* generate code for this node */

//   switch(tree->tokcode)
//   {
//   case 0:
//     /* we need no code for this node */
//     break;

//   case ID:
//     /* push the number onto the stack */
//     printf("PUSH %s\n", tree->token);
//     break;

//   case NUMBER:
//     /* push the number onto the stack */
//     printf("PUSH %s\n", tree->token);
//     break;

//   case CHAR_VAL:
//     /* push the number onto the stack */
//     printf("PUSH %s\n", tree->token);
//     break;

//   case STRING_VAL:
//     /* push the number onto the stack */
//     printf("PUSH %s\n", tree->token);
//     break;

//   case PLUS:
//     printf("POP A\n");
//     printf("POP B\n");
//     printf("ADD A= A+B\n");
//     printf("PUSH A\n");
//     break;

//   case MINUS:
//     printf("POP A\n");
//     printf("POP B\n");
//     printf("SUB A= A-B\n");
//     printf("PUSH A\n");
//     break;

//   case TIMES:
//     printf("POP A\n");
//     printf("POP B\n");
//     printf("MULT A= A*B\n");
//     printf("PUSH A\n");
//     break;

//   default:
//     printf("error unkown AST code %d\n", tree->tokcode);
//   }

// }
