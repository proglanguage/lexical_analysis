# Lexical Analysis

Grace compiller for Hop Language

## Introduction

This project aims the construction of a language wich has as main goal to help IT students that are starting in programming. We build this syntax with a vision of simplicity and facilities for the fresh programming student.

## Requirements

+ [Flex](https://www.gnu.org/software/flex/)
+ [Bison](https://www.gnu.org/software/bison/)
+ [GNUMake](http://gnu.org/software/make)
+ [Valgrind](http://www.valgrind.org/)
+ [ld](https://linux.die.net/man/1/ld)

## Compiling & Using It

Create the necessary dirctories

```bash
make dirs
```

Run the following comands on your system (if Unix based)

```bash
make lexer yacc
make grace
./bin/grace < <file_name>
```

Remember of changing the `<file_name>` with the path to the file to be parsed.
We give examples of code in our language at the `examples` directory on this repository.

**OBS.:** To clean the files run `make clean`. To test run `make test`.

## References

+ [Flex manpage](http://dinosaur.compilertools.net/flex/manpage.html)
