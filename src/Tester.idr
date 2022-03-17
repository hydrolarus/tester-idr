-- SPDX-FileCopyrightText: 2021 The test-idr developers
--
-- SPDX-License-Identifier: MPL-2.0

module Tester

import public Control.Monad.Either
import Data.String
import Control.ANSI
import Language.Reflection
import Language.Reflection.TTImp

%language ElabReflection

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

public export
record Location where
    constructor Loc
    inner : FC

export
emptyLoc : Location
emptyLoc = Loc EmptyFC

||| Get a `Location` token
||| This can be passed to assertion to attach source location
|||
||| ```idris example
||| let loc = here `(())
|||  in assertEq {loc} 
export %macro
here : TTImp -> Elab Location
here ttimp = pure $ Loc $ getFC ttimp

getFile : OriginDesc -> String
getFile (PhysicalIdrSrc (MkMI path)) = showSep "/" (reverse path) ++ ".idr"
getFile (PhysicalPkgSrc fname) = fname
getFile (Virtual _) = "virtual"

formatFC : FC -> String
formatFC (MkFC origin (startLn, startCol) (endLn, endCol)) = " at \{getFile origin}:\{show startLn}:\{show startCol}--\{show endLn}:\{show endCol}"
formatFC (MkVirtualFC origin (startLn, startCol) (endLn, endCol)) = " at \{getFile origin}:\{show startLn}:\{show startCol}--\{show endLn}:\{show endCol}"
formatFC EmptyFC = ""

export
formatLoc : Location -> String
formatLoc loc = formatFC loc.inner

||| Assert that two values are equal.
|||
||| Stops the test and reports a test failure if the values are not equal.
public export
assertEq :
    (Eq a, Show a) =>
    {default emptyLoc loc : Location} ->
    (left, right : a) ->
    TestFunc ()
assertEq left right =
    unless (left == right) $
        let msg = unlines [
                    red "assertEq" ++ " failed\{formatLoc loc}",
                    "  left  `" ++ red (show left) ++ "`",
                    "  right `" ++ red (show right) ++ "`"
                ]
        in throwE msg

||| Assert that two values are not equal.
|||
||| Stops the test and reports a test failure if the values are equal.
public export
assertNotEq :
    (Eq a, Show a) =>
    {default emptyLoc loc : Location} ->
    (left, right : a) ->
    TestFunc ()
assertNotEq left right =
    if left == right then 
        let msg = unlines [
                    red "assertNotEq" ++ " failed\{formatLoc loc}:",
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
assert :
    {default emptyLoc loc : Location} ->
    (cond : Bool) ->
    TestFunc ()
assert cond =
    if not cond then 
        let msg = red "assert" ++ "failed\{formatLoc loc}"
        in throwE msg
    else
        pure ()

||| Cause a test failure with a message.
public export
throw : (msg : String) -> TestFunc a
throw = throwE
