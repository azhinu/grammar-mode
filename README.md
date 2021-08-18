# grammar-mode package

This is an Atom editor package to let the author of a source file add a comment to force the file to use a certain grammar (aka "mode" in EMACS) and show the appropriate syntax highlighting. This is needed on files with no extensions or files that start with one language but then are mostly another language (like react view files).

### Installation
Enter the terminal command `apm install azhinu-grammar-mode` or use the `+ Install` button in the settings tab (`ctrl-,`) and search for azhinu-grammar-mode.

### Usage

Add a string with this format anywhere in the file, usually in a comment. `EXTENSION` should be a typical source file extension for the type of file that uses the grammar you want your file to use.  The period at the beginning is optional and nothing is case-sensitive.
Extension check grammar tag on file open.

```
syntax=EXTENSION

Examples ...
  #syntax=coffee
  // syntax=js

or

syntax=grammar.name

Examples ...
  #syntax=source.yaml
  // syntax=source.

```


### License

Grammar-mode is copyright Mark Hahn with the MIT license.
