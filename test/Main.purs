module Test.Main where

import Prelude

import CSS.Validate (isDeclarationValid)
import Data.Foldable (for_)
import Effect (Effect)
import Jest (describe, expectToBeFalse, expectToBeTrue, test)

validColors :: Array String
validColors =
  [ "indigo"
  , "transparent"
  , "rgb(11, 22, 33)"
  , "rgba(111, 222, 333, 0.6)"
  , "hsl(11, 22%, 33%)"
  , "hsla(111, 22%, 33%, 0.4)"
  ]

invalidColors :: Array String
invalidColors =
  [ "random!"
  , "opaque"
  , "rgb(11, 22, )"
  , "rgba(111, 222, 333, 0.6, )"
  , "hsl(11, 22%, )"
  , "hsla(111, 22%, 33%, 0.4, )"
  ]

main :: Effect Unit
main = do
  test "empty string is invalid" $ do
    expectToBeFalse $ isDeclarationValid "" ""
    expectToBeFalse $ isDeclarationValid " " " "
    expectToBeFalse $ isDeclarationValid "p" " "
    expectToBeFalse $ isDeclarationValid " " "v"

  describe "Valid colors" $
    for_ validColors $ \color ->
      test color $
        expectToBeTrue $ isDeclarationValid "color" color

  describe "Invalid colors" $
    for_ invalidColors $ \color ->
      test color $
        expectToBeFalse $ isDeclarationValid "color" color
