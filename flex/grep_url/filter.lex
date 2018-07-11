%{
#include <iostream>
%}

%option c++
%option debug

TEST            test
PROTOCOL        https?|ftp|sftp|ftps|ssh
EXT             fr|org|net|com
SUBDOMAIN       [a-zA-Z0-9-]+"."
DOMAIN          {SUBDOMAIN}+
SUBPATH         \/[^ \t\n]+
PATH            {SUBPATH}*
URL             {PROTOCOL}:\/\/{DOMAIN}{EXT}{PATH}
WS              [ \t\n]


%%

{WS}            ;
{URL}      { std::cout << YYText() << "\n"; }
.               ;
%%

extern "C" {
    int yywrap();
}

int yyFlexLexer::yywrap(){
    return ::yywrap();
}


int main( int /* argc */, char** /* argv */ )
{
    FlexLexer* lexer = new yyFlexLexer;
    while(lexer->yylex() != 0);
    std::cout << std::endl;
    return 0;
}
