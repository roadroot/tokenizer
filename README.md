A dart package for creating parsers.

## Features

Parse any syntax you want. This package is a simple parser generator that can be used to create parsers for any syntax.

## Getting started

To use this package, add it to your `pubspec.yaml` file:

```yaml
dependencies:
  tokenizer_parser: ^0.1.0
```

Then, run `dart pub get` to install the package.

## Usage

```dart
// parse a string
Tokenizer.tokenize('input', [...tokens], [...commentTokens]);

// parse a file
Tokenizer.tokenizeFile('inputFile', [...tokens], [...commentTokens]);
```

## Additional information

An example of how to use the package can be found in the `example` directory.
