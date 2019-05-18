%{
   #include "y.tab.h"
   int yycolno = 0;
   extern int yylineno;
%}

%%

^[ |\t]*[\n\r]            {/* Ignore any blank line */ yycolno=0;yylineno++;}

","                       {yycolno++;return(COMMA);}
"."                       {yycolno++;return(DOT);}
[\n\r;]                   {yycolno=0;return(END);}
"+"                       {yycolno++;return(PLUS);}
"-"                       {yycolno++;return(MINUS);}
"*"                       {yycolno++;return(TIMES);}
"/"                       {yycolno++;return(DIVIDE);}
"^"                       {yycolno++;return(POWER);}
"("                       {yycolno++;return(LEFT_PARENTHESIS);}
")"                       {yycolno++;return(RIGHT_PARENTHESIS);}
"["                       {yycolno++;return(LEFT_BRACKET);}
"]"                       {yycolno++;return(RIGHT_BRACKET);}
"{"                       {yycolno++;return(LEFT_KEY);}
"}"                       {yycolno++;return(RIGHT_KEY);}
"<="                      {yycolno+=2;return(LESS_EQ);}
">="                      {yycolno+=2;return(BIG_EQ);}
"<"                       {yycolno++;return(LESS);}
">"                       {yycolno++;return(BIG);}
"="                       {yycolno++;return(ASSIGN);}
"=="                      {yycolno+=2;return(EQ);}
"procedure"               {yycolno+=9;return(PROCEDURE);}
"end_procedure"           {yycolno+=11;return(END_PROCEDURE);}
"function"                {yycolno+=8;return(FUNCTION);}
"end_function"            {yycolno+=10;return(END_FUNCTION);}
"if"                      {yycolno+=2;return(IF);}
"then"                    {yycolno+=4;return(THEN);}
"end_if"                  {yycolno+=6;return(END_IF);}
"else"                    {yycolno+=4;return(ELSE);}
"do"                      {yycolno+=2;return(DO);}
"while"                   {yycolno+=5;return(WHILE);}
"end_while"               {yycolno+=9;return(END_WHILE);}
"for"                     {yycolno+=3;return(FOR);}
"end_for"                 {yycolno+=7;return(END_FOR);}
"int"                     {yycolno+=3;return(INTEGER);}
"char"                    {yycolno+=4;return(CHAR);}
"str"                     {yycolno+3;return(STRING);}
"#.*"                     {yylval.sValue = strdup(yytext);
                           return(BEGIN_COMMENT);}

"\".*\""                  {yylval.sValue = strdup(yytext);
                           yycolno+=strlen(yylval.sValue);return(STRING_VAL);}

"\'.\'"                   {yylval.cValue = yytext[1];
                           yycolno++;return(CHAR_VAL);}

[0-9]+                    {yylval.iValue = atoi(yytext);
                           yycolno+=strlen(yytext);return(NUMBER);}

[a-zA-Z][a-zA-Z0-9_]*     {yylval.sValue = strdup(yytext);
                           yycolno+=strlen(yytext);return(ID);}

^[\t]                     {yycolno++;return(INDENT);}
^[ ]{2}                   {yycolno+=2;return(INDENT);}
^[ ]{4}                   {yycolno+=4;return(INDENT);}

[ ]                       {/* Ignore white spaces */yycolno++;}

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
