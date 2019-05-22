# Lexical Analysis
Lexical and Syntactical Analysis for our new language to be named afterwords

## Requirements

+ [Flex](https://www.gnu.org/software/flex/)

## Compiling & Using It

Run the following comands on your system (if Unix based)

```bash
lex lexer01.l
yacc parser01.y -d -v # use -g if you desire to see a graph with the
gcc lex.yy.c y.tab.c -o parser
./parser < <file_name>
```

Remember of changing the `<file_name>` with the path to the file to be parsed.
We give an exemple of a quicksort on our language at `quicksort.txt` file on this repository.

## References

+ [Flex manpage](http://dinosaur.compilertools.net/flex/manpage.html)
