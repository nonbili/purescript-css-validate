var csstree = require("css-tree");
var syntax = csstree.lexer;

exports.isDeclarationValid = function(property) {
  return function(value) {
    if (!property.trim() || !value.trim()) return false;

    var valid = true;
    var declaration = property + ":" + value;
    var ast;
    try {
      ast = csstree.parse(declaration, {
        context: "declaration",
        onParseError: function() {
          valid = false;
        }
      });
    } catch (e) {
      valid = false;
    }

    if (!valid) {
      return false;
    }

    csstree.walk(ast, {
      visit: "Declaration",
      enter: function(node) {
        var match = syntax.matchDeclaration(node);
        if (match.error) {
          valid = false;
        }
      }
    });
    return valid;
  };
};
