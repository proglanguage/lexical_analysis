APPNAME = grace
APPDIR = application
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

BIN = ${BINDIR}/${APPNAME}
APP = $(wildcard ${APPDIR}/*.c)

SRC = $(wildcard $(SRCDIR)/*.c)
OBJS = $(patsubst $(SRCDIR)/%.c,$(OBJDIR)/%.o,$(SRC))

_LEX = $(wildcard $(LEXDIR)/*.l)

_YACC = $(wildcard $(YACCDIR)/*.y)

_TESTS = $(wildcard $(TESTDIR)/*.c)
TESTS = $(patsubst %.c,%,$(_TESTS))

${APPNAME}: $(OBJS)
	$(CC) -o $(BIN) $(APP) $(OBJS) $(CFLAGS) $(LDFLAGS)

${OBJDIR}/%.o: $(SRCDIR)/%.c
	$(CC) -c -o $@ $< $(CFLAGS)

lexer: ${LEXDIR}/*.l
	lex --yylineno -o $(SRCDIR)/lex.yy.c $<

yacc: ${YACCDIR}/*.y
	yacc $< --defines=${INCLUDEDIR}/y.tab.h --graph=${GDIR}/y.dot --report-file=${YOUTDIR}/y.output -v --output=${SRCDIR}/y.tab.c

test: $(TESTS) 
	$(info ************  Testes concluídos com sucesso! ************)

$(TESTDIR)/t_%: $(TESTDIR)/t_%.c $(OBJS)
	$(CC) -o $@ $< $(OBJS) $(CFLAGS) $(LDFLAGS)
	valgrind $@ --leak-check=full --show-leak-kinds=all --show-reachable=yes -v

clean:
	rm -f $(BIN) $(OBJS) $(APPOBJ)
	rm -f $(TESTS)
	rm -f $(SRCDIR)/lex.yy.c $(SRCDIR)/y.tab.c $(INCLUDEDIR)/y.tab.h
	rm -f y.output $(GDIR)/y.dot

dirs:
	mkdir -p ${APPDIR} ${BINDIR} ${SRCDIR} ${INCLUDEDIR} ${LEXDIR} ${YACCDIR} ${OBJDIR} ${TESTDIR} ${GDIR} ${YOUTDIR}
