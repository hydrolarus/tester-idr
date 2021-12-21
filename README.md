<!--
SPDX-FileCopyrightText: 2021 The test-idr developers

SPDX-License-Identifier: CC0-1.0
-->

# `tester-idr`

A testing framework for Idris 2.

## Installation

At least version `0.5.0` of the Idris 2 compiler is required.

```sh
idris2 --install tester.ipkg
```

## Usage

After installing the package, add `tester` to the `depends` section in the `.ipkg` file.

To construct a `Test`, use the `test` function from the `Tester` module.

Multiple assertion functions are provided in the `Tester` module as well.

```idris
itWorks = test "it works" $ do
    assertEq (1 + 1) 2
```

To run a series of tests, the `runTests` function in `Tester.Runner` can be used.

```idris
import Tester
import Tester.Runner

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
