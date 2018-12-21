# purescript-css-validate

[![purescript-css-validate on Pursuit](https://pursuit.purescript.org/packages/purescript-css-validate/badge)](https://pursuit.purescript.org/packages/purescript-css-validate)
[![CircleCI](https://circleci.com/gh/nonbili/purescript-css-validate.svg?style=svg)](https://circleci.com/gh/nonbili/purescript-css-validate)

Validate single CSS property and value pair.

## Usage

[csstree](https://github.com/csstree/csstree) is used underneath, install it by

```
# csstree is a different package
npm i css-tree
```


```
import CSS.Validate (isDeclarationValid)
isDeclarationValid "color" "indigo"   -- true
isDeclarationValid "color" "indigogo" -- false
```
