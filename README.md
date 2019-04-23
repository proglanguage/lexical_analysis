# Lexical Analysis
Lexical Analysis for our new language to be named afterwords

## Requirements

+ [Flex](https://www.gnu.org/software/flex/)

## Compiling & Using It

Run the following comands on your system (if Unix based)
```bash
lex lexer01.l
gcc lex.yy.c -ll -o parser.exe
parser.exe < <file_name>
```
Remember of changing the `<file_name>` with the path to the file to be parsed.
We give an exemple of a quicksort on our language at `quicksort.txt` file on this repository.
