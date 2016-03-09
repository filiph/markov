library markov.chain_generator;

import 'dart:async';
import 'dart:collection';

import 'package:markov/src/chain.dart';
import 'package:markov/src/token.dart';
import 'package:markov/src/token_sequence.dart';
import 'package:string_scanner/string_scanner.dart';

class MarkovChainGenerator extends StreamConsumer<String> {
  static final _word = new RegExp(r"[^\s\.!?,:]+");
  static final _whiteSpace = new RegExp(r"\s+");
  static final _punctuation = new RegExp(r"[\.!?,:]+");
  static final _link = new RegExp(r"https?://[^\s]+");
  static final _twitterMention = new RegExp(r"\.@[^\s]+");
  static final _numberOrTime = new RegExp(r"\d+[\.,:]+\d+");

  final int order;

  /// When the input text is just lines that have no relation to each other.
  /// Like, for example, a dump of tweets.
  final bool newlineMeansNewSequence = true;
  MarkovChain _chain;
  Queue<String> _stringTokens;

  MarkovChainGenerator(this.order) {
    _chain = new MarkovChain(order);
    _stringTokens = new Queue.from(new List.filled(order, "\n"));
  }

  @override
  Future addStream(Stream<String> stream) {
    return stream.forEach((String line) {
      _stringTokens.addAll(_tokenizeLine(line));
      while (_stringTokens.length >= order + 1) {
        var precedent = new TokenSequence(
            _stringTokens.take(order).map((string) => new Token(string)));
        _chain.record(precedent, _stringTokens.skip(order).first);
        _stringTokens.removeFirst();
      }
    });
  }

  @override
  Future<MarkovChain> close() {
    return new Future.value(_chain);
  }

  Iterable<String> _duplicateNewlines(String string) {
    if (string == "\n") {
      return new List.filled(order, "\n");
    }
    return [string];
  }

  Iterable<String> _tokenizeLine(String line) sync* {
    var scanner = new StringScanner(line.trim());
    while (!scanner.isDone) {
      if (scanner.scan(_link) ||
          scanner.scan(_twitterMention) ||
          scanner.scan(_numberOrTime) ||
          scanner.scan(_word) ||
          scanner.scan(_punctuation)) {
        yield scanner.lastMatch[0];
      }
      // Skip whitespace if any.
      scanner.scan(_whiteSpace);
    }
    // Add a newline at the end. More than one if each line is a sequence of
    // its own.
    if (newlineMeansNewSequence) {
      for (int i = 0; i < order; i++) {
        yield "\n";
      }
    } else {
      yield "\n";
    }
  }
}
