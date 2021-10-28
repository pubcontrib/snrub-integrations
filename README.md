# snrub-integrations
> Unoffical integration test coverage of snrub.

This project includes scripts for running a suite of integration tests for
the [snrub](https://bitbucket.org/wareification/snrub) programming language.
To avoid repeating test cases and to create a suite that is independent of
the language version, this project leverages the unit tests built-in each
version of the program for the snippets of code to test. Unlike the unit
tests that run very quickly and don't modify the tester's system at all,
these integration tests may perform heavy tasks like checking for memory
leaks as well as writing temporary files.

## Running
For the sake of simplicity the snrub GIT repo is used as the input for these
integration tests. To test a version of code simply point a local clone of
the repo to the commit you'd like to test.

Run all integration tests:
```shell
sh run.sh ~/Repos/snrub
```

With the `-t` option you can limit the test cases run by test. The options
supported today are `unit`, `batch`, `file`, `interactive`, and `memory`.

Run only memory tests:
```shell
sh run.sh -t memory ~/Repos/snrub
```

With the `-s` option you can limit the test cases run by suite. See the suites
listed in the `test/suite` repo of your local snrub GIT repo for options.

Run only add tests:
```shell
sh run.sh -s operator/add ~/Repos/snrub
```

## License
This project uses the unlicense license. See `LICENSE` file for more details.
