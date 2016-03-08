// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library markov.test;

import 'package:markov/markov.dart';
import 'package:test/test.dart';

void main() {
  group('Converter', () {
    MarkovConverter converter;
    MarkovChain chain;

    group('"tick tock" of first order', () {
      setUp(() {
        converter = new MarkovConverter(1);
        chain = converter.convert([
          "tick tock tick tock tick tock tick tock",
          "tick tock tick tock tick tock"
        ]);
      });

      test('always generates "tock" after "tick"', () {
        var start = new TokenSequence.fromString("tick");
        for (int i = 0; i < 1000; i++) {
          expect(chain.generate(currentState: start).first.string, "tock");
        }
      });
      test('generates "tick" or EOL after "tock"', () {
        var start = new TokenSequence.fromString("tock");
        bool generatedAtLeastOneTick = false;
        bool generatedAtLeastOneEOL = false;
        for (int i = 0; i < 1000; i++) {
          var string = chain.generate(currentState: start).first.string;
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
