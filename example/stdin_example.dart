// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library markov.example;

import 'dart:convert';
import 'dart:io';

import 'package:markov/markov.dart';

main() async {
  print("Provide source text by stdin. For best result, provide a large number "
      "of tweets, one per line.\n\n"
      "  \$ dart stdin_example.dart < tweets.txt\n"
      "  Here's your generated tweet.");

  // List<String> lines = await stdin
  //     .transform(new Utf8Decoder())
  //     .transform(new LineSplitter())
  //     .fold([], (List prev, next) {
  //   prev.add(next);
  //   return prev;
  // });
  //
  // // Chunked conversion is currently unimplemented, otherwise we could just
  // // use another `transform()` above.
  // MarkovChain chain = new MarkovConverter(2).convert(lines);

  // Take POSIX standard input stream (or any other byte
  // stream) and use it as source text.
  var chain = await stdin
      .transform(new Utf8Decoder())
      .transform(new LineSplitter())
      .pipe(new MarkovChainGenerator(2));

  // Take just one tweet worth of generated content (terminated by a newline).
  List<Token> tokens =
      chain.generate().takeWhile((token) => token.string != "\n").toList();

  print(format(tokens));
}
