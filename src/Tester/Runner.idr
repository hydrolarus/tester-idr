-- SPDX-FileCopyrightText: 2021 The test-idr developers
--
-- SPDX-License-Identifier: MPL-2.0

module Tester.Runner

import Tester
import Data.List


import Control.ANSI
import Control.Monad.Either


||| Run the set of tests in `tests` and print out the test result.
||| 
||| If a test failed the fail-message will be displayed.
|||
||| @ tests The tests to run
export
runTests : (tests : List Test) -> IO Bool
runTests tests = do
    let longestDesc = foldl (\acc,t => max acc (length t.description)) 0 tests
    let padding = \len =>
            let diff = longestDesc `minus` len
            in pack $ replicate diff ' '

    res <- for tests \t => do
        putStr $ t.description ++ padding (length t.description) ++ " ... " 
        case !(runEitherT t.run) of
            Left err => do

                printLn $ colored Red "failed"
                putStrLn err
                pure False
            Right () => do
                printLn $ colored Green "passed"
                pure True
    pure $ all (==True) res
