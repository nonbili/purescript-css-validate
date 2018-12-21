module CSS.Validate
  ( isDeclarationValid
  ) where

foreign import isDeclarationValid :: String -> String -> Boolean
