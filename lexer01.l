%{
   #include "y.tab.h"
%}

%%

^[ |\t]*\n                {/* Ignore any blank line*/};

","                       {return(COMMA);}
"."                       {return(DOT);}
[\n;]                     {return(END);}
"+"                       {return(PLUS);}
"-"                       {return(MINUS);}
"*"                       {return(TIMES);}
"/"                       {return(DIVIDE);}
"^"                       {return(POWER);}
"("                       {return(LEFT_PARENTHESIS);}
")"                       {return(RIGHT_PARENTHESIS);}
"["                       {return(LEFT_BRACKET);}
"]"                       {return(RIGHT_BRACKET);}
"{"                       {return(LEFT_KEY);}
"}"                       {return(RIGHT_KEY);}
"<="                      {return(LESS_EQ);}
">="                      {return(BIG_EQ);}
"<"                       {return(LESS);}
">"                       {return(BIG);}
"="                       {return(ASSIGN);}
"=="                      {return(EQ);}
"procedure"               {return(PROCEDURE);}
"end_procedure"           {return(END_PROCEDURE);}
"if"                      {return(IF);}
"then"                    {return(THEN);}
"end_if"                  {return(END_IF);}
"else"                    {return(ELSE);}
"do"                      {return(DO);}
"while"                   {return(WHILE);}
"end_while"               {return(END_WHILE);}
"for"                     {return(FOR);}
"end_for"                 {return(END_FOR);}
"int"                     {return(INTEGER);}
"char"                    {return(CHAR);}
"str"                     {return(STRING);}
"#.*"                     {yylval.sValue = strdup(yytext);
                           return(BEGIN_COMMENT);}

"\".*\""                  {yylval.sValue = strdup(yytext);
                           return(STRING_VAL);}

"\'.\'"                   {yylval.cValue = yytext[1];
                           return(CHAR_VAL);}

[0-9]+                    {yylval.iValue = atoi(yytext);
                           return(NUMBER);}

[a-zA-Z][a-zA-Z0-9_]*     {yylval.sValue = strdup(yytext);
                           return(ID);}

[\t]                      {return(INDENT);}
[ ]{2,4}                  {return(INDENT);}

[ ]                       {/* Ignore white spaces */};

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
