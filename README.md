<!--
SPDX-FileCopyrightText: 2021 The test-idr developers

SPDX-License-Identifier: CC0-1.0
-->

# `test-idr`

A testing framework for Idris 2.

## Installation

At least version `0.3.0` of the Idris 2 compiler is required.

```sh
idris2 --install test.ipkg
```

## Usage

After installing the package, add `test` to the `depends` section in the `.ipkg` file.

To construct a `Test`, use the `test` function from the `Test` module.

Multiple assertion functions are provided in the `Test` module as well.

```idris
itWorks = test "it works" $ do
    assertEq (1 + 1) 2
```

To run a series of tests, the `runTests` function in `Test.Runner` can be used.

```idris
import Test
import Test.Runner

tests : List Test
tests = [
    itWorks
]

main : IO ()
main = do
    success <- runTests tests
    if success
        then putStrLn "All tests passed"
        else putStrLn "Not all tests passed"
```

## License

All code is licensed under the [MPL-2.0](LICENSES/MPL-2.0.txt).

All files that are not properly copyrightable are in the public domain, using
the [CC0 license](LICENSES/CC0-1.0.txt).

This project aims to be [REUSE compliant](https://reuse.software/).