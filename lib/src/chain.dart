library markov.chain;

import 'dart:math';

import 'package:markov/src/probability_distribution.dart';
import 'package:markov/src/token.dart';
import 'package:markov/src/token_sequence.dart';

class MarkovChain {
  static const totalCountKey = " "; // Space is an invalid token.
  final Map<TokenSequence, ProbabilityDistribution<String>> _edges = new Map();

  final int order;

  final Random _random;

  MarkovChain(this.order, {int randomSeed}) : _random = new Random(randomSeed);

  Map get asMap => _edges;

  Iterable<Token> generate({TokenSequence currentState: null}) sync* {
    if (currentState == null) {
      currentState = new TokenSequence(
          new List.filled(order, "\n").map((string) => new Token(string)));
    }

    while (true) {
      ProbabilityDistribution<String> distribution = _edges[currentState];
      String nextWord = distribution.pick(_random);
      var nextToken = new Token(nextWord);
      yield nextToken;
      currentState = new TokenSequence.fromPrevious(currentState, nextToken);
    }
  }

  void record(TokenSequence precedent, String word) {
    ProbabilityDistribution<String> distribution =
        _edges.putIfAbsent(precedent, () => new ProbabilityDistribution());
    distribution.record(word);
  }

  toJson() => {"edges": _edges, "order": order};
}
