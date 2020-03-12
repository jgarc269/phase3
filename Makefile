CFLAGS = -g -Wall -ansi -pedantic

make:
	bison -v -d --file-prefix=y mini_l.y
	flex mini_l.lex
	g++ $(CFLAGS) -std=c++11 lex.yy.c y.tab.c -lfl -o minil

