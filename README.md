# Lexical Analysis

Lexical and Syntactical Analysis for our new language to be named afterwords

## Requirements

+ [Flex](https://www.gnu.org/software/flex/)
+ [Bison](https://www.gnu.org/software/bison/)
+ [GNUMake](http://gnu.org/software/make)
* [Valgrind](http://www.valgrind.org/)
+ [ld](https://linux.die.net/man/1/ld)

## Compiling & Using It

Run the following comands on your system (if Unix based)

```bash
make lexer
make yacc
make
./bin/grace < <file_name>
```

**OBS.:** To clean the files run `make clean`.

Remember of changing the `<file_name>` with the path to the file to be parsed.
We give examples of code in our language at the `examples` directory on this repository.

## References

+ [Flex manpage](http://dinosaur.compilertools.net/flex/manpage.html)
