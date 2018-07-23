library markov.token_sequence;

import 'dart:collection';

import 'package:markov/src/token.dart';
import 'package:quiver/core.dart';

/// A sequence of tokens.
class TokenSequence {
  final Queue<Token> _tokens;

  /// Creates a token sequence from an [Iterable] of [Token]s.
  TokenSequence(Iterable<Token> tokens) : _tokens = new Queue.from(tokens);

  /// Create a new sequence, taking all members of [previous] except the first
  /// one, and adding [nextToken].
  factory TokenSequence.fromPrevious(TokenSequence previous, Token nextToken) {
    final nextTokens = new Queue<Token>.from(previous._tokens);
    nextTokens.removeFirst();
    nextTokens.addLast(nextToken);
    return new TokenSequence(nextTokens);
  }

  /// Generates a token sequence from a simple concatenation of strings,
  /// such as "This is a sentence . This is another one .".
  TokenSequence.fromString(String str)
      : this(str.split(' ').map((string) => new Token(string)));

  @override
  int get hashCode => hashObjects(_tokens.map((token) => token.string));

  @override
  bool operator ==(Object other) =>
      other is TokenSequence && hashCode == other.hashCode;

  @override
  String toString() => _tokens.map((t) => t.string).join(' '); // TODO
}
