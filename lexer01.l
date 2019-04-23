 /* %{
  * #include "y.tab.h"
  * %}
  */

%%

^[ |\t]*\n                {/* Ignore any blank line*/};

";"                       {printf("SEMICOLON ");/* return(SEMICOLON); */}
","                       {printf("COMMA ");/* return(COMMA); */}
"."                       {printf("DOT ");/* return(DOT); */}
[\n;]                     {printf("END_STMT\n");/* return(END); */}
"+"                       {printf("PLUS ");/* return(PLUS); */}
"-"                       {printf("MINUS ");/* return(MINUS); */}
"*"                       {printf("TIMES ");/* return(TIMES); */}
"/"                       {printf("DIVIDE ");/* return(DIVIDE); */}
"^"                       {printf("POWER ");/* return(POWER); */}
"("                       {printf("LEFT_PARENTHESIS ");/* return(LEFT_PARENTHESIS); */}
")"                       {printf("RIGHT_PARENTHESIS ");/* return(RIGHT_PARENTHESIS); */}
"["                       {printf("LEFT_BRACKET ");/* return(LEFT_BRACKET); */}
"]"                       {printf("RIGHT_BRACKET ");/* return(RIGHT_BRACKET); */}
"{"                       {printf("LEFT_KEY ");/* return(LEFT_KEY); */}
"}"                       {printf("RIGHT_KEY ");/* return(RIGHT_KEY); */}
"<="                      {printf("LESS_EQ ");/* return(LESS_EQ); */}
">="                      {printf("BIG_EQ ");/* return(BIG_EQ); */}
"<"                       {printf("LESS ");/* return(LESS); */}
">"                       {printf("BIG ");/* return(BIG); */}
"="                       {printf("EQ ");/* return(EQ); */}
"procedure"               {printf("PROCEDURE ");/* return(PROCEDURE); */}
"end_procedure"           {printf("END_PROCEDURE ");/* return(END_PROCEDURE) */}
"if"                      {printf("IF ");/* return(IF); */}
"then"                    {printf("THEN ");/* return(THEN); */}
"end_if"                  {printf("END_IF ");/* return(END_IF) */}
"else"                    {printf("ELSE ");/* return(ELSE); */}
"do"                      {printf("DO ");/* return(DO); */}
"while"                   {printf("WHILE ");/* return(WHILE); */}
"end_while"               {printf("END_WHILE ");/* return(END_WHILE) */}
"for"                     {printf("FOR ");/* return(FOR); */}
"end_for"                 {printf("END_FOR ");/* return(END_FOR) */}
"int"                     {printf("INTEGER ");/* return(INTEGER); */}

[0-9]+                    {/* yylval.iValue = atoi(yytext); */
                           printf("NUMBER(%s) ", yytext); /* return NUMBER; */}

[a-z][a-z0-9_]*           {/* sprintf(yylval.sValue,"%s",yytext); */
                           printf("ID(%s) ", yytext); /* return ID; */}

[\t]                      {printf("INDENT ");/* return(INDENT); */}
[ ]{2,4}                  {printf("INDENT ");/* return(INDENT); */}

[ ]                       {/* Ignore white spaces */};

%%

#ifndef yywrap
    int yywrap (void) {return 1;}
#endif

int main(void)
{
  yylex();
  return 0;
}
