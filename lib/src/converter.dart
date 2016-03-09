library markov.converter;

import 'dart:convert';

import 'package:markov/src/chain.dart';
import 'package:markov/src/token.dart';
import 'package:markov/src/token_sequence.dart';
import 'package:string_scanner/string_scanner.dart';

/// DEPRECATED. Use MarkovChainGenerator instead.
class MarkovConverter extends Converter<List<String>, MarkovChain> {
  static final _word = new RegExp(r"[^\s\.!?,:]+");
  static final _whiteSpace = new RegExp(r"\s+");
  static final _punctuation = new RegExp(r"[\.!?,:]+");
  static final _link = new RegExp(r"https?://[^\s]+");
  static final _twitterMention = new RegExp(r"\.@[^\s]+");
  static final _numberOrTime = new RegExp(r"\d+[\.,:]+\d+");

  final int order;

  MarkovConverter(this.order);

  MarkovChain convert(List<String> lines) {
    List<String> strings = lines
        .map(_tokenizeLine)
        .expand((tokens) => tokens)
        // Every newline means end of one sequence and beginning of next one.
        // We need to separate the sequences by [order] newlines.
        // TODO: make this optional
        .expand(_duplicateNewlines)
        .toList();
    var chain = new MarkovChain(order);
    // First, add [order] newlines as the beggining of file.
    strings.insertAll(0, new List.filled(order, "\n"));
    for (int i = 0; i < strings.length - order - 1; i++) {
      var precedent = new TokenSequence(
          strings.sublist(i, i + order).map((string) => new Token(string)));
      chain.record(precedent, strings[i + order]);
    }
    return chain;
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
    // Add a newline at the end.
    yield "\n";
  }
}
