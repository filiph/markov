// Copyright (c) 2016, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library markov.test;

import 'dart:async';

import 'package:markov/markov.dart';
import 'package:test/test.dart';

void main() {
  group('Converter', () {
    MarkovChainGenerator converter;
    MarkovChain chain;

    group('"tick tock" of first order', () {
      setUp(() async {
        converter = new MarkovChainGenerator(1);
        await converter.addStream(new Stream.fromIterable([
          'tick tock tick tock tick tock tick tock',
          'tick tock tick tock tick tock'
        ]));
        chain = await converter.close();
      });

      test('always generates "tock" after "tick"', () {
        final start = new TokenSequence.fromString('tick');
        for (var i = 0; i < 1000; i++) {
          expect(chain.generate(initialState: start).first.string, 'tock');
        }
      });
      test('generates "tick" or EOL after "tock"', () {
        final start = new TokenSequence.fromString('tock');
        var generatedAtLeastOneTick = false;
        var generatedAtLeastOneEOL = false;
        for (var i = 0; i < 1000; i++) {
          final string = chain.generate(initialState: start).first.string;
          expect(string, anyOf('tick', '\n'));
          if (string == 'tick') {
            generatedAtLeastOneTick = true;
          }
          if (string == '\n') {
            generatedAtLeastOneEOL = true;
          }
        }
        expect(generatedAtLeastOneTick, true);
        expect(generatedAtLeastOneEOL, true);
      });
    });
  });
}
