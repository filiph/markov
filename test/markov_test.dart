// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library markov.test;

import 'package:markov/markov.dart';
import 'package:test/test.dart';
import 'dart:async';

void main() {
  group('Converter', () {
    MarkovChainGenerator converter;
    MarkovChain chain;

    group('"tick tock" of first order', () {
      setUp(() async {
        converter = new MarkovChainGenerator(1);
        converter.addStream(new Stream.fromIterable([
          "tick tock tick tock tick tock tick tock",
          "tick tock tick tock tick tock"
        ]));
        chain = await converter.close();
      });

      test('always generates "tock" after "tick"', () {
        var start = new TokenSequence.fromString("tick");
        for (int i = 0; i < 1000; i++) {
          expect(chain.generate(state: start).first.string, "tock");
        }
      });
      test('generates "tick" or EOL after "tock"', () {
        var start = new TokenSequence.fromString("tock");
        bool generatedAtLeastOneTick = false;
        bool generatedAtLeastOneEOL = false;
        for (int i = 0; i < 1000; i++) {
          var string = chain.generate(state: start).first.string;
          expect(string, anyOf("tick", "\n"));
          if (string == "tick") generatedAtLeastOneTick = true;
          if (string == "\n") generatedAtLeastOneEOL = true;
        }
        expect(generatedAtLeastOneTick, true);
        expect(generatedAtLeastOneEOL, true);
      });
    });
  });
}
