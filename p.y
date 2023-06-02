%{

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>
#include <string.h>

int yylex(void);
int yyerror(const char* message);
char* removeChar(char* s, char c);

%}

%union {
  char* string;
}

%token <string> STRING
%token HEADING1 HEADING2 HEADING3 HEADING4 HEADING5 HEADING6 BR NL BOLD ITALIC

%%

FISIER: INTRO BODYPART OUTRO;

BODYPART: BREAK | HEADING | P | BODYPART BREAK | BODYPART HEADING | BODYPART P | ITA | BODYPART ITA | BLD | BODYPART BLD;

BREAK: BR NL { printf("   <br>\n"); }

P: STRING NL NL { printf("   <p>%s</p>\n", removeChar($1, '\n')); }

ITA: ITALIC STRING ITALIC NL {
  char* s = removeChar($2, '\n');
  printf("   <em>%s</em>\n", removeChar(s, s[strlen(s) - 1]));
}

BLD: BOLD STRING BOLD NL {
  char* s = removeChar($2, '\n');
  printf("   <strong>%s</strong>\n", removeChar(s, s[strlen(s) - 1]));
}

HEADING: HEADING1 STRING NL { printf("   <h1>%s</h1>\n", removeChar($2, '\n')); }
        | HEADING2 STRING NL { printf("   <h2>%s</h2>\n", removeChar($2, '\n')); }
        | HEADING3 STRING NL { printf("   <h3>%s</h3>\n", removeChar($2, '\n')); }
        | HEADING4 STRING NL { printf("   <h4>%s</h4>\n", removeChar($2, '\n')); }
        | HEADING5 STRING NL { printf("   <h5>%s</h5>\n", removeChar($2, '\n')); }
        | HEADING6 STRING NL { printf("   <h6>%s</h6>\n", removeChar($2, '\n')); };

INTRO: {
  printf("<!DOCTYPE html>\n");
  printf("<html>\n");
  printf("<body>\n");
}

OUTRO: {
  printf("</body>\n");
  printf("</html>\n");
}

%%

char* removeChar(char* s, char c) {
  int j, n = strlen(s);
  for (int i = j = 0; i < n; i++) {
    if (s[i] != c) {
      s[j++] = s[i];
    }
  }

  s[j] = '\0';
  return s;
}

#include <ctype.h>

int main() {
  yyparse();
  return 0;
}

int yyerror(const char* s) {
  fprintf(stderr, "Eroare de analiză sintactică: %s\n", s);
  return -1;
}
