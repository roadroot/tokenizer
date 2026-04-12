import 'package:tokenizer_parser/tokenizer_parser.dart';

import 'ql_lang.dart';

void main() {
  const sample = 'query User { user(id: 1) { name } }';
  final (tokens, remaining) =
      Tokenizer.tokenize(sample, QlLang.lang, QlLang.ignore);

  print('tokens: ${tokens.length}');
  print('remaining segments: ${remaining.length}');
}
