%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"


%}
%option noyywrap
string ([a-zA-Z1-9.?! ]+)*
heading1 ("#")
heading2 ("##")
heading3 ("###")
heading4 ("####")
heading5 ("#####")
heading6 ("######")
bold ("_")
bold2 ("**")
italic ("*")
br  (" ")
NL \n
%%
{italic}    return ITALIC;
{NL} return NL;
{br}    return BR;
{bold}|{bold2} return BOLD;
{string} {yylval.string = yytext; return STRING;};
{heading1} return HEADING1;
{heading2} return HEADING2;
{heading3} return HEADING3;
{heading4} return HEADING4;
{heading5} return HEADING5;
{heading6} return HEADING6;
. { printf("Token necunoscut: %s\n", yytext);};
%%