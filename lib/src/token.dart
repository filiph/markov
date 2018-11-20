library markov.token;

/// A single token of a markov chain, represented as a string.
///
/// This implementation assumes a word-like token.
class Token {
  static final _noSpaceBefore = RegExp(r'^[\.!?,:\-]+$');

  static final _noSpaceAfter = RegExp(r'^(["]+|\-\-)$');

  /// The string representation of the token.
  final String string;

  /// Whether this string should be concatenated directly to the previous
  /// token. By default (when [skipsSpaceBefore] is `false`), there is
  /// a ` ` (space) between every token.
  final bool skipsSpaceBefore;

  /// Whether this string should be concatenated directly to the following
  /// token. By default (when [skipsSpaceBefore] is `false`), there is
  /// a ` ` (space) between every token.
  final bool skipsSpaceAfter;

  /// Generate a token from the [string].
  factory Token(String string) {
    final skipsSpaceBefore = _noSpaceBefore.hasMatch(string);
    final skipsSpaceAfter = _noSpaceAfter.hasMatch(string);
    return Token._(string, skipsSpaceBefore, skipsSpaceAfter);
  }

  Token._(this.string, this.skipsSpaceBefore, this.skipsSpaceAfter);
}
