module CSS.Validate
  ( isClassNameValid
  , isDeclarationValid
  , Declaration
  , parseDeclaration
  ) where

import Data.Either (Either(..))
import Data.Function.Uncurried (Fn4, runFn4)
import Effect.Exception (Error)

-- | Validate CSS roperty and value.
-- |
-- | `isDeclarationValid "color" "white" == true`
-- |
-- | `isDeclarationValid "color" "bg" == false`
foreign import isDeclarationValid :: String -> String -> Boolean

-- | A valid class name must begins with an underscore (_), a hyphen (-), or a
-- | letter(a–z), followed by any number of hyphens, underscores, letters, or
-- | numbers. See https://stackoverflow.com/a/449000
-- |
-- | `isClassNameValid "abc" == true`
-- |
-- | `isClassNameValid "123" == false`
foreign import isClassNameValid :: String -> Boolean

-- | A type to represent a CSS declaration.
-- | https://developer.mozilla.org/en-US/docs/Web/CSS/Syntax#CSS_declarations
type Declaration =
  { property :: String
  , value :: String
  , important :: Boolean
  , valid :: Boolean
  }

-- | Parse CSS property and value to Declaration.
parseDeclaration :: String -> String -> Either Error Declaration
parseDeclaration property value =
  runFn4 parseDeclaration_ Left Right property value
foreign import parseDeclaration_
  :: Fn4 (Error -> Either Error Declaration)
         (Declaration -> Either Error Declaration)
         String
         String
         (Either Error Declaration)
