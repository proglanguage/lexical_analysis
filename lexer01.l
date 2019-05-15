%{
   #include "y.tab.h"
   int yycolno = 0;
%}

%%

^[ |\t]*[\n\r]            {/* Ignore any blank line*/ yycolno=0;}

","                       {yycolno++;return(COMMA);}
"."                       {yycolno++;return(DOT);}
[\n\r;]                   {yycolno++;return(END);}
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
"<="                      {yycolno++;return(LESS_EQ);}
">="                      {yycolno++;return(BIG_EQ);}
"<"                       {yycolno++;return(LESS);}
">"                       {yycolno++;return(BIG);}
"="                       {yycolno++;return(ASSIGN);}
"=="                      {yycolno++;return(EQ);}
"procedure"               {yycolno++;return(PROCEDURE);}
"end_procedure"           {yycolno++;return(END_PROCEDURE);}
"if"                      {yycolno++;return(IF);}
"then"                    {yycolno++;return(THEN);}
"end_if"                  {yycolno++;return(END_IF);}
"else"                    {yycolno++;return(ELSE);}
"do"                      {yycolno++;return(DO);}
"while"                   {yycolno++;return(WHILE);}
"end_while"               {yycolno++;return(END_WHILE);}
"for"                     {yycolno++;return(FOR);}
"end_for"                 {yycolno++;return(END_FOR);}
"int"                     {yycolno++;return(INTEGER);}
"char"                    {yycolno++;return(CHAR);}
"str"                     {yycolno++;return(STRING);}
"#.*"                     {yylval.sValue = strdup(yytext);
                           yycolno++;return(BEGIN_COMMENT);}

"\".*\""                  {yylval.sValue = strdup(yytext);
                           yycolno++;return(STRING_VAL);}

"\'.\'"                   {yylval.cValue = yytext[1];
                           yycolno++;return(CHAR_VAL);}

[0-9]+                    {yylval.iValue = atoi(yytext);
                           yycolno++;return(NUMBER);}

[a-zA-Z][a-zA-Z0-9_]*     {yylval.sValue = strdup(yytext);
                           yycolno++;return(ID);}

[\t]                      {yycolno++;return(INDENT);}
[ ]{2,4}                  {yycolno++;return(INDENT);}

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
