# snrub-integrations
> Unoffical integration test coverage of snrub program.

This project includes scripts for running a suite of integration tests for
the snrub programming language. To avoid repeating test cases and to create a
suite that is independent of the language version, this project leverages the
unit tests built-in each version of the program for the snippets of code to
test. Unlike the unit tests that run very quickly and don't modify the
tester's system at all, these integration tests may perform heavy tasks like
checking for memory leaks as well as writing temporary files.
