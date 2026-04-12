import 'package:tokenizer_parser/src/token_model/token_base.dart';

/// Base type for token models used by the tokenizer.
abstract class TokenModel extends TokenBase {
  /// Indicates whether token is a language keyword.
  final bool isKeyword;

  /// Indicates whether token is a symbol/punctuation.
  final bool isSymbol;

  /// Creates a token model with optional keyword/symbol metadata.
  const TokenModel({
    this.isKeyword = false,
    this.isSymbol = false,
    required super.name,
  });
}
