%{
   #include "y.tab.h"
   int yycolno = 0;
   int lldebug = 0;
   #pragma GCC diagnostic ignored "-Wformat-zero-length"
%}

%%
^[ |\t]*[\n\r]            {/* Ignore any blank line */ yycolno=0;}

","                       {yycolno++;(lldebug?printf("COMMA "):printf(""));return(COMMA);}
"."                       {yycolno++;(lldebug?printf("DOT "):printf(""));return(DOT);}
":"                       {yycolno++;(lldebug?printf("SEMICOLON "):printf(""));return(SEMICOLON);}
[\r\n;]                   {yycolno=0;(lldebug?printf("ENDL\n"):printf(""));return(ENDL);}
"+"                       {yycolno++;(lldebug?printf("PLUS "):printf(""));return(PLUS);}
"-"                       {yycolno++;(lldebug?printf("MINUS "):printf(""));return(MINUS);}
"*"                       {yycolno++;(lldebug?printf("TIMES "):printf(""));return(TIMES);}
"/"                       {yycolno++;(lldebug?printf("DIVIDE "):printf(""));return(DIVIDE);}
"^"                       {yycolno++;(lldebug?printf("POWER "):printf(""));return(POWER);}
"%"                       {yycolno++;(lldebug?printf("MODULUS "):printf(""));return(MODULUS);}
"("                       {yycolno++;(lldebug?printf("LEFT_PARENTHESIS "):printf(""));return(LEFT_PARENTHESIS);}
")"                       {yycolno++;(lldebug?printf("RIGHT_PARENTHESIS "):printf(""));return(RIGHT_PARENTHESIS);}
"["                       {yycolno++;(lldebug?printf("LEFT_BRACKET "):printf(""));return(LEFT_BRACKET);}
"]"                       {yycolno++;(lldebug?printf("RIGHT_BRACKET "):printf(""));return(RIGHT_BRACKET);}
"{"                       {yycolno++;(lldebug?printf("LEFT_KEY "):printf(""));return(LEFT_KEY);}
"}"                       {yycolno++;(lldebug?printf("RIGHT_KEY "):printf(""));return(RIGHT_KEY);}
"<="                      {yycolno+=2;(lldebug?printf("LESS_EQ "):printf(""));return(LESS_EQ);}
">="                      {yycolno+=2;(lldebug?printf("BIG_EQ "):printf(""));return(BIG_EQ);}
"=="                      {yycolno+=2;(lldebug?printf("EQ "):printf(""));return(EQ);}
"!="                      {yycolno+=2;(lldebug?printf("NEQ "):printf(""));return(NEQ);}
"<"                       {yycolno++;(lldebug?printf("LESS "):printf(""));return(LESS);}
">"                       {yycolno++;(lldebug?printf("BIG "):printf(""));return(BIG);}
"="                       {yycolno++;(lldebug?printf("ASSIGN "):printf(""));return(ASSIGN);}
"!"                       {yycolno+=1;(lldebug?printf("NEG "):printf(""));return(NEG);}
"and"                     {yycolno+=3;(lldebug?printf("AND "):printf(""));return(AND);}
"or"                      {yycolno+=2;(lldebug?printf("OR "):printf(""));return(OR);}
"true"                    {yycolno+=4;(lldebug?printf("TRUE "):printf(""));return(TRUE);}
"false"                   {yycolno+=5;(lldebug?printf("FALSE "):printf(""));return(FALSE);}
"begin_program"           {yycolno+=13;(lldebug?printf("BEGIN_PROGRAM "):printf(""));return(BEGIN_PROGRAM);}
"end_program"             {yycolno+=13;(lldebug?printf("END_PROGRAM "):printf(""));return(END_PROGRAM);}
"procedure"               {yycolno+=9;(lldebug?printf("PROCEDURE "):printf(""));return(PROCEDURE);}
"end_procedure"           {yycolno+=11;(lldebug?printf("END_PROCEDURE "):printf(""));return(END_PROCEDURE);}
"function"                {yycolno+=8;(lldebug?printf("FUNCTION "):printf(""));return(FUNCTION);}
"end_function"            {yycolno+=10;(lldebug?printf("END_FUNCTION "):printf(""));return(END_FUNCTION);}
"if"                      {yycolno+=2;(lldebug?printf("IF "):printf(""));return(IF);}
"then"                    {yycolno+=4;(lldebug?printf("THEN "):printf(""));return(THEN);}
"end_if"                  {yycolno+=6;(lldebug?printf("END_IF "):printf(""));return(END_IF);}
"else"                    {yycolno+=4;(lldebug?printf("ELSE "):printf(""));return(ELSE);}
"do"                      {yycolno+=2;(lldebug?printf("DO "):printf(""));return(DO);}
"while"                   {yycolno+=5;(lldebug?printf("WHILE "):printf(""));return(WHILE);}
"end_while"               {yycolno+=9;(lldebug?printf("END_WHILE "):printf(""));return(END_WHILE);}
"for"                     {yycolno+=3;(lldebug?printf("FOR "):printf(""));return(FOR);}
"in"                      {yycolno+=2;(lldebug?printf("IN "):printf(""));return(IN);}
"end_for"                 {yycolno+=7;(lldebug?printf("END_FOR "):printf(""));return(END_FOR);}
"break"                   {yycolno+=5;(lldebug?printf("BREAK "):printf(""));return(BREAK);}
"loop"                    {yycolno+=4;(lldebug?printf("LOOP "):printf(""));return(LOOP);}
"end_loop"                {yycolno+=8;(lldebug?printf("END_LOOP "):printf(""));return(END_LOOP);}
"exit"                    {yycolno+=4;(lldebug?printf("EXIT "):printf(""));return(EXIT);}
"return"                    {yycolno+=4;(lldebug?printf("RETURN "):printf(""));return(RETURN);}

"int"                     {yycolno+=3;(lldebug?printf("INTEGER "):printf(""));return(INTEGER);}
"float"                   {yycolno+=5;(lldebug?printf("FLOAT "):printf(""));return(FLOAT);}
"char"                    {yycolno+=4;(lldebug?printf("CHAR "):printf(""));return(CHAR);}
"str"                     {yycolno+3;(lldebug?printf("STRING "):printf(""));return(STRING);}
"bool"                    {yycolno+4;(lldebug?printf("BOOLEAN "):printf(""));return(BOOLEAN);}
"struct"                  {yycolno+6;(lldebug?printf("STRUCT "):printf(""));return(STRUCT);}
"puts"                    {yycolno+4;(lldebug?printf("STDOUT "):printf(""));return(STDOUT);}
"gets"                    {yycolno+4;(lldebug?printf("STDIN "):printf(""));return(STDIN);}

"#".*[\r\n]               {(lldebug?printf("COMMENT\n"):printf(""));}
"#".*                     {(lldebug?printf("COMMENT "):printf(""));}

\".*\"                      {yylval.sValue = strdup(yytext);
                             yycolno+=strlen(yylval.sValue)+2;(lldebug?printf("STRING_VAL "):printf(""));return(STRING_VAL);}

\'.\'                       {yylval.cValue = yytext[1];
                             yycolno+=3;(lldebug?printf("CHAR_VAL "):printf(""));return(CHAR_VAL);}

[0-9]*\.[0-9]*              {yylval.fValue = atof(yytext);
                             yycolno+=strlen(yytext);(lldebug?printf("FLOAT_NUMBER "):printf(""));return(FLOAT_NUMBER);}

[0-9]+f                     {yylval.fValue = atof(yytext);
                             yycolno+=strlen(yytext);(lldebug?printf("FLOAT_NUMBER "):printf(""));return(FLOAT_NUMBER);}


[0-9]+                      {yylval.iValue = atoi(yytext);
                             yycolno+=strlen(yytext);(lldebug?printf("NUMBER "):printf(""));return(NUMBER);}

"0x"[0-9a-fA-F]+                {yylval.iValue = atoi(yytext);
                             yycolno+=strlen(yytext);(lldebug?printf("NUMBER "):printf(""));return(NUMBER);}


[a-zA-Z][a-zA-Z0-9_]*     {yylval.sValue = strdup(yytext);
                           yycolno+=strlen(yytext);(lldebug?printf("ID "):printf(""));return(ID);}

^[\t]                     {yycolno++;}

[ ]                       {/* Ignore white spaces */yycolno++;}

.                         {return *yytext;} /* Anything not defined is a syntax error */

%%

#ifndef yywrap
    int yywrap (void) {return 1;}
#endif

/*
int main(void)
{
  yylex();
  return 0;
}
*/
