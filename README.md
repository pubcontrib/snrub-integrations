# snrub-integrations
> Unoffical integration test coverage of snrub program.

This project includes scripts for running a suite of integration tests for
the snrub programming language. To avoid repeating test cases and to create a
suite that is independent of the language version, this project leverages the
unit tests built-in each version of the program for the snippets of code to
test. Unlike the unit tests that run very quickly and don't modify the
tester's system at all, these integration tests may perform heavy tasks like
checking for memory leaks as well as writing temporary files.

## Running
For the sake of simplicity the snrub GIT repo is used as the input for these
integration tests. To test a version of code simply point a local clone of
the repo to the commit you'd like to test.

*Caution:* Uncommitted changes will be reverted after integration tests are
run.

*Caution:* Killing the integration test process early may result in
unreverted test changes.

Run integration test suite against a branch of code:
```shell
sh run.sh ~/Repos/snrub
```

## License
This project uses the unlicense license. See `LICENSE` file for more details.
