BINDIR = bin
SRCDIR = src
INCLUDEDIR = include
LEXDIR = lex
YACCDIR = yacc
OBJDIR = build
TESTDIR = test
GDIR = graph
YOUTDIR = youtput

CC = gcc
CFLAGS = -I $(INCLUDEDIR)
LDFLAGS =

BIN = ${BINDIR}/grace

SRC = $(wildcard $(SRCDIR)/*.c)
OBJS = $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRC))

_LEX = $(wildcard $(LEXDIR)/*.l)

_YACC = $(wildcard $(YACCDIR)/*.y)

_TESTS = $(wildcard $(TESTDIR)/*.c)
TESTS = $(patsubst %.c,%,$(_TESTS))

$(BIN): $(OBJS)
	$(CC) -o $(BIN) $(OBJS) $(CFLAGS) $(LDFLAGS)

${OBJDIR}/%.o: $(SRCDIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

lexer: ${LEXDIR}/*.l
	lex --yylineno -o $(SRCDIR)/lex.yy.c $<

bison: ${YACCDIR}/*.y
	yacc $< -d -g -v
	mv y.tab.h $(INCLUDEDIR)/
	mv y.tab.c $(SRCDIR)/
	mv y.dot $(GDIR)/

test: $(TESTS) 
	$(info ************  Testes concluídos com sucesso! ************)

$(TESTDIR)/t_%: $(TESTDIR)/t_%.c $(OBJS)
	$(CC) -o $@ $< $(OBJS) $(CFLAGS) $(LDFLAGS)
	$@
	
clean:
	rm -f $(BIN) $(OBJS) $(APPOBJ)
	rm -f $(TESTS)
	rm -f $(SRCDIR)/lex.yy.c $(SRCDIR)/y.tab.c $(INCLUDEDIR)/y.tab.h
	rm -f y.output $(GDIR)/y.dot
