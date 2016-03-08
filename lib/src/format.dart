library markov.format;

import 'package:markov/src/token.dart';

String format(List<Token> tokens) {
  var buffer = new StringBuffer();
  var previousSkipsSpaceAfter = true;
  for (var token in tokens) {
    if (!previousSkipsSpaceAfter && !token.skipsSpaceBefore) {
      buffer.write(" ");
    }
    buffer.write(token.string);
    previousSkipsSpaceAfter = token.skipsSpaceAfter;
  }
  return buffer.toString();
}
