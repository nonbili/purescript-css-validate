module Test.Main where

import Prelude

import CSS.Validate (isClassNameValid, isDeclarationValid, parseDeclaration)
import Data.Bifunctor (lmap)
import Data.Either (Either(..), isLeft)
import Data.Foldable (for_)
import Effect (Effect)
import Jest (describe, expectToBeFalse, expectToBeTrue, expectToEqual, test)

validColors :: Array String
validColors =
  [ "indigo"
  , "transparent!important"
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

validClassNames :: Array String
validClassNames =
  [ "_abc"
  , "-webkit"
  , "container"
  , "__internal__"
  , "list3"
  , "hover\\:list3"
  ]

invalidClassNames :: Array String
invalidClassNames =
  [ "*abc"
  -- , "--webkit"
  , "3list"
  -- , "hover:list3"
  ]

main :: Effect Unit
main = do
  describe "Valid class names" $
    for_ validClassNames $ \cls ->
      test cls $
        expectToBeTrue $ isClassNameValid cls

  describe "Invalid class names" $
    for_ invalidClassNames $ \cls ->
      test cls $
        expectToBeFalse $ isClassNameValid cls

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

  test "parseDeclaration valid" $ do
    expectToEqual (lmap show $ parseDeclaration "color" "#333 !important") $
      Right
        { property: "color"
        , value: "#333"
        , important: true
        , valid: true
        }
    expectToEqual (lmap show $ parseDeclaration "display" " grid ") $
      Right
        { property: "display"
        , value: "grid"
        , important: false
        , valid: true
        }

  test "parseDeclaration invalid" $ do
    expectToBeTrue (isLeft $ parseDeclaration " " "  ")
    expectToBeTrue (isLeft $ parseDeclaration " k " "  ")
    expectToBeTrue (isLeft $ parseDeclaration "  " " v  ")
    expectToEqual (lmap show $ parseDeclaration "k" "v") $
      Right
        { property: "k"
        , value: "v"
        , important: false
        , valid: false
        }
    expectToEqual (lmap show $ parseDeclaration "color" "#css") $
      Right
        { property: "color"
        , value: "#css"
        , important: false
        , valid: false
        }

  test "isDeclarationValid should work for custom properties" $ do
    expectToBeTrue $ isDeclarationValid "--primary" "blue"
    expectToBeTrue $ isDeclarationValid "color" "var(--primary)"
