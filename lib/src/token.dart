import 'package:tokenizer_parser/src/token_model/token_model.dart';
import 'package:tokenizer_parser/src/utils/iterables.dart';

/// Represents a raw input segment with source coordinates.
class Input {
  /// Segment text.
  final String input;

  /// Zero-based line of the segment start.
  final int line;

  /// Zero-based column of the segment start.
  final int column;

  /// Zero-based absolute character index of the segment start.
  final int index;

  Input({
    required this.input,
    this.line = 0,
    this.column = 0,
    this.index = 0,
  });

  @override
  String toString() {
    return '($input)($line:$column:$index)'
        .replaceAll('\n', r'\n')
        .replaceAll('\r', r'\r')
        .replaceAll('\t', r'\t');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Input &&
        other.input == input &&
        other.line == line &&
        other.column == column &&
        other.index == index;
  }

  @override
  int get hashCode {
    return input.hashCode ^ line.hashCode ^ column.hashCode ^ index.hashCode;
  }
}

/// A token matched from input based on a [TokenModel].
class Token implements Comparable<Token> {
  /// Start line (zero-based).
  final int startLine;

  /// End line (zero-based).
  final int endLine;

  /// Start column (zero-based).
  final int startColumn;

  /// End column (zero-based).
  final int endColumn;

  /// Matched token model.
  final TokenModel model;

  /// Raw token text.
  final String value;

  /// Child tokens for composed/non-literal tokens.
  final List<Token> children;

  /// Character length of [value].
  int get length => value.length;

  const Token({
    required this.startLine,
    required this.endLine,
    required this.startColumn,
    required this.endColumn,
    required this.model,
    required this.value,
    this.children = const [],
  });

  /// Builds a composed token from [tokens] as children.
  factory Token.from(TokenModel model, List<Token> tokens) {
    if (tokens.isEmpty) {
      throw ArgumentError('tokens cannot be empty');
    }
    return Token(
      startLine: tokens.first.startLine,
      endLine: tokens.last.endLine,
      startColumn: tokens.first.startColumn,
      endColumn: tokens.last.endColumn,
      model: model,
      children: tokens,
      value: tokens.map((e) => e.value).join(''),
    );
  }

  @override
  String toString() {
    return '$model($value)($startLine:$startColumn:$endLine:$endColumn)';
  }

  @override
  int compareTo(Token other) {
    if (startLine == other.startLine) {
      return startColumn.compareTo(other.startColumn);
    }
    return startLine.compareTo(other.startLine);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Token) {
      return false;
    }
    if (other.model != model) {
      return false;
    }
    if (other.value != value) {
      return false;
    }
    if (notEqual(other.children, children)) {
      return false;
    }
    if (other.startLine != startLine) {
      return false;
    }
    if (other.endLine != endLine) {
      return false;
    }
    if (other.startColumn != startColumn) {
      return false;
    }
    if (other.endColumn != endColumn) {
      return false;
    }

    return true;
  }

  @override
  int get hashCode =>
      model.hashCode ^
      value.hashCode ^
      hash(children) ^
      startLine.hashCode ^
      endLine.hashCode ^
      startColumn.hashCode ^
      endColumn.hashCode;
}
