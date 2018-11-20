library markov.chain;

import 'dart:math';

import 'package:markov/src/probability_distribution.dart';
import 'package:markov/src/token.dart';
import 'package:markov/src/token_sequence.dart';

/// A markov chain generator. Feed it with [record] and let it generate
/// new outputs with [generate].
class MarkovChain {
  final Map<TokenSequence, ProbabilityDistribution<String>> _edges = {};

  /// The order of the Markov chain, i.e. the length of its memory.
  final int order;

  final Random _random;

  /// Generates a Markov chain of order [order].
  ///
  /// Optionally takes [randomSeed] for the random number generator.
  MarkovChain(this.order, {int randomSeed}) : _random = Random(randomSeed);

  /// Generates an infinite iterable of tokens.
  Iterable<Token> generate({TokenSequence initialState}) sync* {
    var state = initialState ??
        TokenSequence(List.filled(order, '\n').map((string) => Token(string)));

    // ignore: literal_only_boolean_expressions
    while (true) {
      final distribution = _edges[state];
      final nextWord = distribution.pick(_random);
      final nextToken = Token(nextWord);
      yield nextToken;
      state = TokenSequence.fromPrevious(state, nextToken);
    }
  }

  /// Record an instance of continuation from [precedent] to the next [word].
  void record(TokenSequence precedent, String word) {
    final distribution =
        _edges.putIfAbsent(precedent, () => ProbabilityDistribution());
    distribution.record(word);
  }

  /// Return JSON representation of this Markov chain.
  Map<String, Object> toJson() => {'edges': _edges, 'order': order};
}
