-- SPDX-FileCopyrightText: 2021 The test-idr developers
--
-- SPDX-License-Identifier: MPL-2.0

module Test

import public Control.Monad.Either
import Data.Strings
import Control.ANSI

||| A function which can report test failures.
public export
TestFunc : Type -> Type
TestFunc = EitherT String IO

||| Value representing a test.
|||
||| Use the `test` function to create a value of this type.
public export
record Test where
    constructor MkTest
    description : String
    run : TestFunc ()

red : String -> String
red s = show $ colored Red s

||| Create a new `Test` with a description and function to run.
|||
||| Use `Test.Runner.runTests` to run the tests.
|||
||| ```idris example
||| itWorks = test "it works" $ do
|||     assertEq (1 + 1) 2
||| ```
public export
test : (description : String) -> (run : TestFunc ()) -> Test
test = MkTest

||| Assert that two values are equal.
|||
||| Stops the test and reports a test failure if the values are not equal.
public export
assertEq : (Eq a, Show a) => (left, right : a) -> TestFunc ()
assertEq left right =
    if left /= right then 
        let msg = unlines [
                    red "assertEq" ++ " failed:",
                    "  left  `" ++ red (show left) ++ "`",
                    "  right `" ++ red (show right) ++ "`"
                ]
        in throwE msg
    else
        pure ()

||| Assert that two values are not equal.
|||
||| Stops the test and reports a test failure if the values are equal.
public export
assertNotEq : (Eq a, Show a) => (left, right : a) -> TestFunc ()
assertNotEq left right =
    if left == right then 
        let msg = unlines [
                    red "assertNotEq" ++ " failed:",
                    "  left  `" ++ red (show left) ++ "`",
                    "  right `" ++ red (show right) ++ "`"
                ]
        in throwE msg
    else
        pure ()

||| Assert that a condition holds.
|||
||| Stops the test and reports a test failure if the condition does not hold.
public export
assert : (cond : Bool) -> TestFunc ()
assert cond =
    if not cond then 
        let msg = red "assert" ++ "failed"
        in throwE msg
    else
        pure ()

||| Cause a test failure with a message.
public export
throw : (msg : String) -> TestFunc a
throw = throwE