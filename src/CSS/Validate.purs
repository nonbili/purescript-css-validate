module CSS.Validate
  ( isDeclarationValid
  , Declaration
  , parseDeclaration
  ) where

import Data.Either (Either(..))
import Data.Function.Uncurried (Fn4, runFn4)
import Effect.Exception (Error)

foreign import isDeclarationValid :: String -> String -> Boolean

type Declaration =
  { property :: String
  , value :: String
  , important :: Boolean
  , valid :: Boolean
  }

foreign import parseDeclaration_
  :: Fn4 (Error -> Either Error Declaration)
         (Declaration -> Either Error Declaration)
         String
         String
         (Either Error Declaration)
parseDeclaration :: String -> String -> Either Error Declaration
parseDeclaration property value =
  runFn4 parseDeclaration_ Left Right property value
