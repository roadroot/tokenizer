# tokenizer_parser

`tokenizer_parser` is a lightweight tokenizer and parser-composition toolkit
for Dart. It helps you define literal token patterns and compose them into
higher-level grammar nodes (for example: fields, declarations, or AST-like
structures) without code generation.

This package is useful when you need:

- custom DSL parsing,
- structured token streams from plain text,
- deterministic composition of flat tokens into nested tokens.

## Features

- Regex-based literal token matching with line/column/index tracking.
- Non-literal composition using sequence and alternatives.
- Optional ignore list for tokens such as whitespace and comments.
- File and string entry points:
  - `Tokenizer.tokenize(...)`
  - `Tokenizer.tokenizeFile(...)`
- Public, composable model primitives (`LiteralModel`, `NonLiteralModel`,
  `TokenSequence`, `TokenAlternatives`).

## Installation

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  tokenizer_parser: ^0.1.1
```

Then install dependencies:

```bash
dart pub get
```

## Quick Start

```dart
import 'package:tokenizer_parser/tokenizer_parser.dart';

const identifier = LiteralModel(name: 'identifier', pattern: r'[A-Za-z_]+');
const whitespace = LiteralModel(name: 'whitespace', pattern: r'\s+');
const equals = LiteralModel(name: 'equals', pattern: r'=');

const assignment = NonLiteralModel(
  name: 'assignment',
  sequence: TokenSequence('identifier-equals-identifier', [
    identifier,
    equals,
    identifier,
  ]),
);

final language = <TokenModel>[identifier, whitespace, equals, assignment];

void main() {
  final result = Tokenizer.tokenize('name = value', language, [whitespace]);
  final tokens = result.$1;
  final remaining = result.$2;

  print(tokens);
  print(remaining); // Unmatched input segments, if any.
}
```

## Core Concepts

### 1) LiteralModel

Matches direct text with a regex pattern.

```dart
const number = LiteralModel(name: 'number', pattern: r'\d+');
```

### 2) NonLiteralModel

Builds higher-level tokens from existing tokens.

```dart
const pair = NonLiteralModel(
  name: 'pair',
  sequence: TokenSequence('key-colon-value', [key, colon, value]),
);
```

### 3) TokenSequence

Requires all elements to match in order.

### 4) TokenAlternatives

Matches the first successful alternative.

## Tokenizing Files

```dart
final result = Tokenizer.tokenizeFile('example/input.gql', language, [whitespace]);
```

## Return Value

Both `Tokenizer.tokenize` and `Tokenizer.tokenizeFile` return:

- `$1`: `List<Token>` created tokens.
- `$2`: `List<Input>` unmatched input segments.

This makes it easy to detect parse gaps or unsupported syntax.

## Example Project

See the full GraphQL-like grammar example in:

- `example/ql_lang.dart`
- `example/tokenizer_example.dart`

## Contributing

Issues and pull requests are welcome. If you add grammar features, include
tests that validate both matched tokens and unmatched remainder behavior.
