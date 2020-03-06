// Adapted from https://github.com/csstree/validator

var csstree = require("css-tree");

function parse(property, value, parseValue) {
  var declaration = property + ":" + value;
  var ast, error;
  try {
    ast = csstree.parse(declaration, {
      context: "declaration",
      parseValue: parseValue,
      onParseError: function(e) {
        error = e;
      }
    });
  } catch (e) {
    error = e;
  }
  return { ast: ast, error: error };
}

function walk(ast, validate) {
  var match, decl;
  csstree.walk(ast, {
    visit: "Declaration",
    enter: function(node) {
      decl = node;
      if (validate) {
        match = csstree.lexer.matchDeclaration(node);
      }
    }
  });
  return { match: match, decl: decl };
}

const syntaxErrors = ["SyntaxMatchError", "SyntaxReferenceError"];

exports.isDeclarationValid = function(property) {
  return function(value) {
    var parsed = parse(property, value, true);

    if (parsed.error) {
      return false;
    }

    var walked = walk(parsed.ast, true);
    // csstree doesn't parse custom properties, so ignoring other errors.
    if (
      walked.match &&
      walked.match.error &&
      syntaxErrors.includes(walked.match.error.name)
    ) {
      const err = walked.match.error;
      return false;
    }

    return true;
  };
};

exports.isClassNameValid = function(cls) {
  let ast;
  try {
    ast = csstree.parse("." + cls, {
      context: "selector",
      parseValue: false,
      onParseError: function() {
        return false;
      }
    });
  } catch (e) {
    return false;
  }
  return true;
};

exports.parseDeclaration_ = function(left, right, property, value) {
  var parsed = parse(property, value, false);

  if (parsed.error) {
    return left(parsed.error);
  }

  var walked = walk(parsed.ast, false);
  if (walked.match && walked.match.error) {
    return left(walked.match.error);
  }

  return right({
    property: walked.decl.property,
    value: walked.decl.value.value,
    important: walked.decl.important,
    valid: exports.isDeclarationValid(property)(value)
  });
};
