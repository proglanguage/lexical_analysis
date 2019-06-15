# Lexical Analysis

Lexical and Syntactical Analysis for our new language to be named afterwords

## Requirements

+ [Flex](https://www.gnu.org/software/flex/)
+ [GNUMake](http://gnu.org/software/make)

## Compiling & Using It

Run the following comands on your system (if Unix based)

```bash
make lexer yacc
make grace
./bin/grace < <file_name>
```

Remember of changing the `<file_name>` with the path to the file to be parsed.
We give an exemple of a quicksort on our language at `quicksort.txt` file on this repository.

**OBS.:** To clean the files run `make clean`. To test run `make test`.

## References

+ [Flex manpage](http://dinosaur.compilertools.net/flex/manpage.html)
