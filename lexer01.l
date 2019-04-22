 /* %{
  * #include "y.tab.h"
  * %}
  */

%%

[0-9]+                    {
 /* yylval.iValue = atoi(yytext); */
                           printf("NUMBER"); /* return NUMBER; */}

"[a-zA-Z_][a-zA-Z0-9_]+"  {
 /* sprintf(yylval.sValue,"%s",yytext); */
                           printf("ALIAS"); /* return ALIAS; */}


[\t]+                     {printf("INDENT");/* return(INDENT); */}
[\n;]                     {printf("END_STMT\n");/* return(END); */}
"+"                       {printf("PLUS");/* return(PLUS); */}
"-"                       {printf("MINUS");/* return(MINUS); */}
"*"                       {printf("TIMES");/* return(TIMES); */}
"/"                       {printf("DIVIDE");/* return(DIVIDE); */}
"^"                       {printf("POWER");/* return(POWER); */}
"("                       {printf("LEFT_PARENTHESIS");/* return(LEFT_PARENTHESIS); */}
")"                       {printf("RIGHT_PARENTHESIS");/* return(RIGHT_PARENTHESIS); */}
"procedure"               {printf("PROCEDURE");/* return(PROCEDURE); */}

%%

#ifndef yywrap
    int yywrap (void) {return 1;}
#endif

int main(void)
{
  yylex();
  return 0;
}
