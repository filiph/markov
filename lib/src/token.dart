library markov.token;

class Token {
  static final _noSpaceBefore = new RegExp(r"^[\.!?,:\-]+$");
  static final _noSpaceAfter = new RegExp(r"""^(["]+|\-\-)$""");

  final String string;
  final bool skipsSpaceBefore;
  final bool skipsSpaceAfter;

  factory Token(String string) {
    bool skipsSpaceBefore = _noSpaceBefore.hasMatch(string);
    bool skipsSpaceAfter = _noSpaceAfter.hasMatch(string);
    return new Token._internal(string, skipsSpaceBefore, skipsSpaceAfter);
  }
  Token._internal(this.string, this.skipsSpaceBefore, this.skipsSpaceAfter);
}
