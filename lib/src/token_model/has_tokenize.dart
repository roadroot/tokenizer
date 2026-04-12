import 'package:tokenizer_parser/src/token.dart';
import 'package:tokenizer_parser/src/token_model/token_base.dart';

/// Contract for models that tokenize raw input segments.
abstract class HasTokenizeLiteral extends TokenBase {
  const HasTokenizeLiteral({required super.name});

  /// Produces tokens and remaining unmatched segments.
  (List<Token>, List<Input>) tokenize(List<Input> input);
}

/// Contract for models that transform existing token streams.
abstract class HasTokenizeNonLiteral extends TokenBase {
  const HasTokenizeNonLiteral({required super.name});

  /// Produces a transformed token list.
  List<Token>? tokenize(List<Token> inputTokens);
}

/// Contract for models that can match at token-stream start.
abstract class HasTokenizeStart extends TokenBase {
  const HasTokenizeStart({required super.name});

  /// Matches from stream start and returns created + remaining tokens.
  (List<Token>, List<Token>)? tokenizeStart(List<Token> inputTokens);

  const HasTokenizeStart.empty({required super.name});
}
