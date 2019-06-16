%{
   #include "y.tab.h"
   int yycolno = 0;
%}

%%

^[ |\t]*[\n\r]            {/* Ignore any blank line */ yycolno=0;}

","                       {yycolno++;printf("COMMA ");return(COMMA);}
"."                       {yycolno++;printf("DOT ");return(DOT);}
":"                       {yycolno++;printf("SEMICOLON ");return(SEMICOLON);}
[\r\n;]                   {yycolno=0;printf("ENDL\n");return(ENDL);}
"+"                       {yycolno++;printf("PLUS ");return(PLUS);}
"-"                       {yycolno++;printf("MINUS ");return(MINUS);}
"*"                       {yycolno++;printf("TIMES ");return(TIMES);}
"/"                       {yycolno++;printf("DIVIDE ");return(DIVIDE);}
"^"                       {yycolno++;printf("POWER ");return(POWER);}
"%"                       {yycolno++;printf("MODULUS ");return(MODULUS);}
"("                       {yycolno++;printf("LEFT_PARENTHESIS ");return(LEFT_PARENTHESIS);}
")"                       {yycolno++;printf("RIGHT_PARENTHESIS ");return(RIGHT_PARENTHESIS);}
"["                       {yycolno++;printf("LEFT_BRACKET ");return(LEFT_BRACKET);}
"]"                       {yycolno++;printf("RIGHT_BRACKET ");return(RIGHT_BRACKET);}
"{"                       {yycolno++;printf("LEFT_KEY ");return(LEFT_KEY);}
"}"                       {yycolno++;printf("RIGHT_KEY ");return(RIGHT_KEY);}
"<="                      {yycolno+=2;printf("LESS_EQ ");return(LESS_EQ);}
">="                      {yycolno+=2;printf("BIG_EQ ");return(BIG_EQ);}
"=="                      {yycolno+=2;printf("EQ ");return(EQ);}
"!="                      {yycolno+=2;printf("NEQ ");return(NEQ);}
"<"                       {yycolno++;printf("LESS ");return(LESS);}
">"                       {yycolno++;printf("BIG ");return(BIG);}
"="                       {yycolno++;printf("ASSIGN ");return(ASSIGN);}
"!"                       {yycolno+=1;printf("NEG ");return(NEG);}
"and"                     {yycolno+=3;printf("AND ");return(AND);}
"or"                      {yycolno+=2;printf("OR ");return(OR);}
"true"                    {yycolno+=4;printf("TRUE ");return(TRUE);}
"false"                   {yycolno+=5;printf("FALSE ");return(FALSE);}
"begin_program"           {yycolno+=13;printf("BEGIN_PROGRAM ");return(BEGIN_PROGRAM);}
"end_program"             {yycolno+=13;printf("END_PROGRAM ");return(END_PROGRAM);}
"procedure"               {yycolno+=9;printf("PROCEDURE ");return(PROCEDURE);}
"end_procedure"           {yycolno+=11;printf("END_PROCEDURE ");return(END_PROCEDURE);}
"function"                {yycolno+=8;printf("FUNCTION ");return(FUNCTION);}
"end_function"            {yycolno+=10;printf("END_FUNCTION ");return(END_FUNCTION);}
"if"                      {yycolno+=2;printf("IF ");return(IF);}
"then"                    {yycolno+=4;printf("THEN ");return(THEN);}
"end_if"                  {yycolno+=6;printf("END_IF ");return(END_IF);}
"else"                    {yycolno+=4;printf("ELSE ");return(ELSE);}
"do"                      {yycolno+=2;printf("DO ");return(DO);}
"while"                   {yycolno+=5;printf("WHILE ");return(WHILE);}
"end_while"               {yycolno+=9;printf("END_WHILE ");return(END_WHILE);}
"for"                     {yycolno+=3;printf("FOR ");return(FOR);}
"in"                      {yycolno+=2;printf("IN ");return(IN);}
"end_for"                 {yycolno+=7;printf("END_FOR ");return(END_FOR);}
"break"                   {yycolno+=5;printf("BREAK ");return(BREAK);}
"loop"                    {yycolno+=4;printf("LOOP ");return(LOOP);}
"end_loop"                {yycolno+=8;printf("END_LOOP ");return(END_LOOP);}
"exit"                    {yycolno+=4;printf("EXIT ");return(EXIT);}
"return"                    {yycolno+=4;printf("RETURN ");return(RETURN);}

"int"                     {yycolno+=3;printf("INTEGER ");return(INTEGER);}
"float"                   {yycolno+=5;printf("FLOAT ");return(FLOAT);}
"char"                    {yycolno+=4;printf("CHAR ");return(CHAR);}
"str"                     {yycolno+3;printf("STRING ");return(STRING);}
"bool"                    {yycolno+4;printf("BOOLEAN ");return(BOOLEAN);}
"struct"                  {yycolno+4;printf("STRUCT ");return(STRUCT);}

"#".*[\r\n]               {printf("COMMENT\n");}
"#".*                     {printf("COMMENT ");}

\".*\"                      {yylval.sValue = strdup(yytext);
                             yycolno+=strlen(yylval.sValue)+2;printf("STRING_VAL ");return(STRING_VAL);}

\'.\'                       {yylval.cValue = yytext[1];
                             yycolno+=3;printf("CHAR_VAL ");return(CHAR_VAL);}

[0-9]*\.[0-9]*              {yylval.fValue = atof(yytext);
                             yycolno+=strlen(yytext);printf("FLOAT_NUMBER ");return(FLOAT_NUMBER);}

[0-9]+f                     {yylval.fValue = atof(yytext);
                             yycolno+=strlen(yytext);printf("FLOAT_NUMBER ");return(FLOAT_NUMBER);}


[0-9]+                      {yylval.iValue = atoi(yytext);
                             yycolno+=strlen(yytext);printf("NUMBER ");return(NUMBER);}

"0x"[0-9a-fA-F]+                {yylval.iValue = atoi(yytext);
                             yycolno+=strlen(yytext);printf("NUMBER ");return(NUMBER);}


[a-zA-Z][a-zA-Z0-9_]*     {yylval.sValue = strdup(yytext);
                           yycolno+=strlen(yytext);printf("ID ");return(ID);}

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
