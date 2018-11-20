library markov.format;

import 'package:markov/src/token.dart';

/// Takes [tokens] and constructs a [String].
///
/// Mostly just joins the string representations of the tokens
/// with ` ` (space). There are special cases, like with `.` (period),
/// which is placed just after the previous word, without the space.
String format(List<Token> tokens) {
  final buffer = StringBuffer();
  var previousSkipsSpaceAfter = true;
  for (var token in tokens) {
    if (!previousSkipsSpaceAfter && !token.skipsSpaceBefore) {
      buffer.write(' ');
    }
    buffer.write(token.string);
    previousSkipsSpaceAfter = token.skipsSpaceAfter;
  }
  return buffer.toString();
}
