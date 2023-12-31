# Exercism C++ Representer

The Docker image to automatically create a representation for C++ solutions submitted to [Exercism].

## Run the representer

To create a representation for an arbitrary exercise, do the following:

1. Open a terminal in the project's root
2. Run `./bin/run.sh <exercise-slug> <solution-dir> <output-dir>`

Once the representer has finished, its results will be written to `<output-dir>/representation.txt` and `<output-dir>/mapping.json`.

## Run the representer on an exercise using Docker

_This script is provided for testing purposes, as it mimics how representers run in Exercism's production environment._

To create a representation for an using the Docker image, do the following:

1. Open a terminal in the project's root
2. Run `./bin/run-in-docker.sh <exercise-slug> <solution-dir> <output-dir>`

Once the representer has finished, its results will be written to `<output-dir>/representation.txt` and `<output-dir>/mapping.json`.

## Run the tests

To run the tests to verify the behavior of the representer, do the following:

1. Open a terminal in the project's root
2. Run `./bin/run-tests.sh`

These are [golden tests][golden] that compare the `representation.txt` and `mapping.json` generated by running the current state of the code against the "known good" `tests/<test-name>/representation.txt` and `tests/<test-name>/mapping.json`. All files created during the test run itself are discarded.

When you've made modifications to the code that will result in a new "golden" state, you'll need to generate and commit a new `tests/<test-name>/representation.txt` and `tests/<test-name>/mapping.json` file.

## Run the tests using Docker

_This script is provided for testing purposes, as it mimics how representers run in Exercism's production environment._

To run the tests to verify the behavior of the representer using the Docker image, do the following:

1. Open a terminal in the project's root
2. Run `./bin/run-tests-in-docker.sh`

These are [golden tests][golden] that compare the `representation.txt` and `mapping.json` generated by running the current state of the code against the "known good" `tests/<test-name>/representation.txt` and `tests/<test-name>/mapping.json`. All files created during the test run itself are discarded.

When you've made modifications to the code that will result in a new "golden" state, you'll need to generate and commit a new `tests/<test-name>/representation.txt` and `tests/<test-name>/mapping.json` file.

## Version Information

### Version 1:

The version 1 implementaion is using Python and the [__pygmentize__][pygments] library. 
Pygments is mostly used as a highlighter to format code, but works fine for a first pass.

Currently the reprenter will:

- strip preprocessor marcors like `#pragma` or `#define`
- remove all whitespace outside strings
- remove all comments
- replace all names with placeholders

### Notes for future Version

A future version might be able to sort functions, variables, classes and enums in a standardized way.
[Tree-sitter][treesitter] might be an option to use an AST to help with the sorting.
Clang's AST representation has lost official support and was never functioning.

[representers]: https://github.com/exercism/docs/tree/main/building/tooling/representers
[golden]: https://ro-che.info/articles/2017-12-04-golden-tests
[exercism]: https://exercism.io
[pygments]: https://pygments.org
[treesitter]: https://tree-sitter.github.io